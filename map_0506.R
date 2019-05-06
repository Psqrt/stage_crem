###################################################################################################
# Packages
###################################################################################################
library(rjson)
library(leaflet)
# library(geojsonio)
library(tidyverse)

###################################################################################################
# Importations
###################################################################################################

# DONNEES - CARTE
data_map2003 = geojsonio::geojson_read("./data/map/NUTS_RG_01M_2003_4326_LEVL_2.geojson", what = "sp")
data_map2006 = geojsonio::geojson_read("./data/map/NUTS_RG_01M_2006_4326_LEVL_2.geojson", what = "sp")
data_map2010 = geojsonio::geojson_read("./data/map/NUTS_RG_01M_2010_4326_LEVL_2.geojson", what = "sp")
data_map2013 = geojsonio::geojson_read("./data/map/NUTS_RG_01M_2013_4326_LEVL_2.geojson", what = "sp")
data_map2016 = geojsonio::geojson_read("./data/map/NUTS_RG_01M_2016_4326_LEVL_2.geojson", what = "sp")

# DONNEES - ENQUETE
liste_nom_fichier = list.files("./data/enquete/")
liste_nom_fichier = substr(liste_nom_fichier, 1, nchar(liste_nom_fichier)-4)

type_fichier = c("h", "d", "p", "r")

df_h = data.frame()
df_d = data.frame()
df_p = data.frame()
df_r = data.frame()

# Logique d'importation : importer les 4 fichiers csv de chaque fichier zip.
for (fichier in liste_nom_fichier){
    # print(paste0("./data/enquete/", fichier, ".zip", sep = ""))
    print(fichier)
    dir_zip = paste0("./data/enquete/", fichier, ".zip", sep = "")
    for (type in type_fichier){
        print(type)
        # print(paste0(substr(fichier, 1, 7), type, substr(fichier, 8, nchar(fichier)), ".csv", sep = ""))
        dir_csv = paste0(substr(fichier, 1, 7), type, substr(fichier, 8, nchar(fichier)), ".csv", sep = "")
        provisoire = read.csv(con <- unz(dir_zip, dir_csv),
                              header = T,
                              sep = ",",
                              stringsAsFactors = F,
                              colClasses = c("character"))
        if (type == "h"){
            df_h = bind_rows(df_h, provisoire)
        } else if (type == "d") {
            df_d = bind_rows(df_d, provisoire)
        } else if (type == "p") {
            df_p = bind_rows(df_p, provisoire)
        } else if (type == "r") {
            df_r = bind_rows(df_r, provisoire)
        }
    }
}

# DONNEES - DICTIONNAIRE

dico_enquete = read.csv(file = "./data/dictionnaire_codage_apres_2010.csv",
                        sep = ",",
                        header = T,
                        stringsAsFactors = F)

dico_enquete = setNames(dico_enquete$code_carte, 
                        dico_enquete$code_enquete)


dico_enquete_croatie_apres_2010 = read.csv(file = "./data/dictionnaire_codage_croatie_apres_2010.csv",
                        sep = ",",
                        header = T,
                        stringsAsFactors = F)

dico_enquete_croatie_apres_2010 = setNames(dico_enquete_croatie_apres_2010$code_carte, 
                                           dico_enquete_croatie_apres_2010$code_enquete)

###################################################################################################
# Fusion - traitement (Selection des variables)
###################################################################################################

# Fusion table H avec table D à partir de l'identifiant household ID
df_t = df_h %>% 
    inner_join(df_d, by = c("HB030" = "DB030", "HB020" = "DB020"))

# codage_croatie_apres_2010 = c("HR01" = "HR04",
#                               "HR02" = "HR04")

df_t$DB040 = recode(df_t$DB040, !!!dico_enquete_croatie_apres_2010)

# TEST / Nombre d'observations pour chaque region de l'Europe
nb_obs_per_region = df_t %>% 
    group_by(DB040) %>% 
    summarise(n = n()) %>% 
    arrange(-n)
nb_obs_per_region

# TEST / Nombre d'observations pour chaque region formatte NUTS1
nb_obs_per_region_nuts1 = df_t %>% 
    group_by(DB040) %>% 
    filter(nchar(DB040) == 3) %>%
    summarise(n = n()) %>% 
    arrange(-n)
nb_obs_per_region_nuts1

# TEST / Nombre d'observations pour chaque region formatte NUTS2
nb_obs_per_region_nuts2 = df_t %>% 
    group_by(DB040) %>% 
    filter(nchar(DB040) == 4) %>%
    summarise(n = n()) %>% 
    arrange(-n)
nb_obs_per_region_nuts2
# Hongrie (HU) et Autriche (AT) en format NUTS1

# TEST / Autres regions ?
df_t %>% 
    group_by(DB040) %>% 
    filter(!(nchar(DB040) %in% c(3, 4))) %>%
    summarise(n = n()) %>% 
    arrange(-n)
# 40448 observations ayant une region en chaine vide.

# Quels pays n'ont pas la variable DB040 (region) remplie ?
df_t %>% 
    filter(DB040 == "") %>%
    group_by(HB020) %>%
    summarise(n = n()) %>% 
    arrange(-n)

# REMARQUE 1 : On a detecte que le nombre de menages DE est plus eleve dans la base complete,
# que dans la base DE seule. Il y a donc des incoherences entre les regions et les pays.

df_t %>%
    group_by(HB020) %>% 
    summarise(n = n())

df_t %>% 
    filter(HB020 == "DE" & !(substr(DB040, 1, 2) %in% c("DE", ""))) %>% 
    select(HB020, DB040)


# Selection de variables a representer (essais)
data2 = df_t %>% 
    select("region" = DB040, 
           "warm" = HH050, 
           # "arrears" = HS021, 
           "leaking" = HH040)

# Recodage YES = 1 / NO = 0 pour donner un sens a la moyenne (proportion)
# Transformation en variable binaire si necessaire
data2 = data2 %>% 
    mutate(warm = if_else(warm == 2, 0, 1),
           # arrears = if_else(arrears == 3, 0, 1),
           leaking = if_else(leaking == 2, 0, 1))

# Calcul des moyennes par region
moy_region = data2 %>% 
    group_by(region) %>% 
    summarise_all(mean, na.rm = T) %>% 
    # mutate(region = as.character(region)) %>% 
    filter(region != "")

toto = data2 %>% 
    group_by(region) %>% 
    summarise_all(mean, na.rm = T) %>% 
    # mutate(region = as.character(region)) %>% 
    filter(region != "")

###################################################################################################
# Gestion des erreurs des données enquête
###################################################################################################

moy_region$region = recode(moy_region$region, !!!dico_enquete)






###################################################################################################
# Récupération des régions de la carte
###################################################################################################

# liste des identifiants nuts2 de la carte
liste_ids = data.frame("region" = data_map2013$NUTS_ID)
# conversion en char pour merger
liste_ids[, "region"] = as.character(liste_ids[, "region"])

# jointure : l'idee est d'associer une valeur existante pour chaque region, sinon un NA
moyenne_region = liste_ids %>%
    left_join(moy_region, by = "region")
    

# liste_ids %>% # à changer plus tard
#     filter(str_detect(region, "FR"))
# 
# data_agg
# 
# data_agg %>% nrow





###################################################################################################
# Gestion des cas NUTS1
###################################################################################################
# nb_obs_per_region_nuts1
# 
# 
# # Calcul des moyennes par region NUTS1
# moyenne_region_nuts1 = data2 %>% 
#     group_by(region) %>% 
#     summarise_all(mean, na.rm = T) %>% 
#     # mutate(region = as.character(region)) %>% 
#     filter(nchar(region) == 3)

# Logique : injecter la valeur de la region NUTS1 dans chaque sous region NUTS2

# moyenne_region %>% 
#     mutate(NUTS1 = substr(region, 1, 3)) %>% 
#     left_join(moyenne_region_nuts1, by = c("NUTS1" = "region"))



# moyenne_region_nuts1_corrige = moyenne_region %>%
#     rownames_to_column() %>% 
#     filter(substr(region, 1, 3) %in% nb_obs_per_region_nuts1$DB040) %>% 
#     mutate(NUTS1 = substr(region, 1, 3)) %>% 
#     select(region, NUTS1, rowname) %>% 
#     left_join(moyenne_region_nuts1, by = c("NUTS1" = "region")) %>% 
#     select(-NUTS1)
#
# moyenne_region_corrige = moyenne_region %>% 
#     rownames_to_column() %>% 
#     anti_join(moyenne_region_nuts1_corrige, by = c("region")) %>% 
#     bind_rows(moyenne_region_nuts1_corrige) %>% 
#     mutate(rowname = as.integer(rowname)) %>% 
#     arrange(rowname)
###################################################################################################

###################################################################################################
# Gestion du cas sans region
###################################################################################################









###################################################################################################
# Cartographie
###################################################################################################

# Choix de la palette
pal <- colorNumeric("viridis", NULL, na.color = "red", alpha = T)

# Carte leaflet
leaflet(data_map2013) %>% 
    addTiles(urlTemplate = "//{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png") %>% 
    addPolygons(stroke = FALSE,
                smoothFactor = 0.3,
                fillOpacity = 0.5,
                fillColor = ~pal(moyenne_region$leaking)) %>% 
    addLegend(pal = pal, 
              values = moyenne_region$leaking, 
              opacity = 1.0)
#              fillColor = ~pal(1-moyenne_region$warm)) %>% 
#    addLegend(pal = pal, values = 1-moyenne_region$warm, opacity = 1.0)
#                fillColor = ~pal(1-moyenne_region$arrears)) %>% 
#    addLegend(pal = pal, values = 1-moyenne_region$arrears, opacity = 1.0)

