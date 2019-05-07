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

nuts = 0
annee_enquete = 2005
if (annee_enquete < 2006){
    annee_carte = 2003
} else if (annee_enquete >= 2006 & annee_enquete < 2010){
    annee_carte = 2006
} else if (annee_enquete >= 2010 & annee_enquete < 2013){
    annee_carte = 2010
} else if (annee_enquete >= 2013 & annee_enquete < 2016){
    annee_carte = 2013
} else {
    annee_carte = 2016
}


# # DONNEES - CARTE NUTS2
# data_map2003_nuts2 = geojsonio::geojson_read("./data/map/NUTS_RG_01M_2003_4326_LEVL_2.geojson", what = "sp")
# data_map2006_nuts2 = geojsonio::geojson_read("./data/map/NUTS_RG_01M_2006_4326_LEVL_2.geojson", what = "sp")
# data_map2010_nuts2 = geojsonio::geojson_read("./data/map/NUTS_RG_01M_2010_4326_LEVL_2.geojson", what = "sp")
# data_map2013_nuts2 = geojsonio::geojson_read("./data/map/NUTS_RG_01M_2013_4326_LEVL_2.geojson", what = "sp")
# data_map2016_nuts2 = geojsonio::geojson_read("./data/map/NUTS_RG_01M_2016_4326_LEVL_2.geojson", what = "sp")
# # DONNEES - CARTE NUTS1
# data_map2003_nuts1 = geojsonio::geojson_read("./data/map/NUTS_RG_01M_2003_4326_LEVL_1.geojson", what = "sp")
# data_map2006_nuts1 = geojsonio::geojson_read("./data/map/NUTS_RG_01M_2006_4326_LEVL_1.geojson", what = "sp")
# data_map2010_nuts1 = geojsonio::geojson_read("./data/map/NUTS_RG_01M_2010_4326_LEVL_1.geojson", what = "sp")
# data_map2013_nuts1 = geojsonio::geojson_read("./data/map/NUTS_RG_01M_2013_4326_LEVL_1.geojson", what = "sp")
# data_map2016_nuts1 = geojsonio::geojson_read("./data/map/NUTS_RG_01M_2016_4326_LEVL_1.geojson", what = "sp")
# # DONNEES - CARTE NUTS0
# data_map2003_nuts0 = geojsonio::geojson_read("./data/map/NUTS_RG_01M_2003_4326_LEVL_0.geojson", what = "sp")
# data_map2006_nuts0 = geojsonio::geojson_read("./data/map/NUTS_RG_01M_2006_4326_LEVL_0.geojson", what = "sp")
# data_map2010_nuts0 = geojsonio::geojson_read("./data/map/NUTS_RG_01M_2010_4326_LEVL_0.geojson", what = "sp")
# data_map2013_nuts0 = geojsonio::geojson_read("./data/map/NUTS_RG_01M_2013_4326_LEVL_0.geojson", what = "sp")
# data_map2016_nuts0 = geojsonio::geojson_read("./data/map/NUTS_RG_01M_2016_4326_LEVL_0.geojson", what = "sp")


# DONNEES - ENQUETE
liste_nom_fichier = list.files("./data/enquete/")
liste_nom_fichier = liste_nom_fichier[grep(annee_enquete, liste_nom_fichier)]
liste_nom_fichier = substr(liste_nom_fichier, 1, nchar(liste_nom_fichier)-4)

# type_fichier = c("h", "d", "p", "r")
type_fichier = c("h", "d")

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

dico_enquete_avant_2010 = read.csv(file = "./data/dictionnaire_codage_avant_2010.csv",
                        sep = ",",
                        header = T,
                        stringsAsFactors = F)

dico_enquete_avant_2010 = setNames(dico_enquete_avant_2010$code_carte, 
                                   dico_enquete_avant_2010$code_enquete)


dico_enquete_apres_2010 = read.csv(file = "./data/dictionnaire_codage_apres_2010.csv",
                        sep = ",",
                        header = T,
                        stringsAsFactors = F)

dico_enquete_apres_2010 = setNames(dico_enquete_apres_2010$code_carte, 
                                   dico_enquete_apres_2010$code_enquete)


dico_enquete_croatie_apres_2010 = read.csv(file = "./data/dictionnaire_codage_croatie_apres_2010.csv",
                        sep = ",",
                        header = T,
                        stringsAsFactors = F)

dico_enquete_croatie_apres_2010 = setNames(dico_enquete_croatie_apres_2010$code_carte, 
                                           dico_enquete_croatie_apres_2010$code_enquete)


dico_enquete_uk_apres_2013 = read.csv(file = "./data/dictionnaire_codage_uk_apres_2013.csv",
                                      sep = ",",
                                      header = T,
                                      stringsAsFactors = F)

dico_enquete_uk_apres_2013 = setNames(dico_enquete_uk_apres_2013$code_carte, 
                                      dico_enquete_uk_apres_2013$code_enquete)


###################################################################################################
# Fusion - traitement (Selection des variables)
###################################################################################################

# Fusion table H avec table D à partir de l'identifiant household ID
df_t = df_h %>% 
    inner_join(df_d, by = c("HB030" = "DB030", "HB020" = "DB020"))


### Recodage des regions pour etre conforme a la norme en vigueur #################################
if (nuts == 2){
    if (annee_carte >= 2010) 
        print("XX1")
        df_t$DB040 = recode(df_t$DB040, !!!dico_enquete_croatie_apres_2010)
    if (annee_carte >= 2013)
        print("XX2")
        df_t$DB040 = recode(df_t$DB040, !!!dico_enquete_uk_apres_2013)
}

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
if (nuts == 2){
    print("XX3")
    moy_region = data2 %>% 
        group_by(region) %>% 
        summarise_all(mean, na.rm = T) %>% 
        # mutate(region = as.character(region)) %>% 
        filter(region != "")
} else if (nuts <= 1){
    if (annee_carte < 2010){
        print("XX4")
        moy_region = data2 %>% 
            mutate(region = recode(region, !!!dico_enquete_avant_2010))
    } else if (annee_carte >= 2010 & annee_carte < 2013){
        print("XX5")
        moy_region = data2 %>% 
            mutate(region = recode(region, !!!dico_enquete_apres_2010))
    }
    print("XXXXXXXXXXXXXXXXXXXXXXX")
    moy_region = data2 %>% 
        mutate(region = substr(region, 1, nuts + 2)) %>%
        group_by(region) %>% 
        summarise_all(mean, na.rm = T) %>% 
        filter(region != "")
}

###################################################################################################
# Gestion des erreurs des données enquête
###################################################################################################

if (nuts == 2){
    if (annee_carte >= 2010){
        print("XX6")
        moy_region$region = recode(moy_region$region, !!!dico_enquete_apres_2010)
    } else if (annee_carte < 2010){
        print("XX7")
        moy_region$region = recode(moy_region$region, !!!dico_enquete_avant_2010)
    }
} else if (nuts == 0){
    if (annee_carte < 2010){
        print("ZZZZZZZZZZZZZZZZZ")
        moy_region = moy_region %>% 
            mutate(region = recode(region, !!!c("EL" = "GR")))
    }
}

###################################################################################################
# Récupération des régions de la carte
###################################################################################################

# liste des identifiants nuts2 de la carte

choix_carte = paste0("data_map", annee_carte, "_nuts", nuts, sep = "")
liste_ids = data.frame("region" = get(choix_carte)$NUTS_ID)
    
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
# Gestion du cas de Londres en 2013 (2 valeurs pour 5 régions)
###################################################################################################

if (nuts == 2 & annee_carte >= 2013){
    print("XX8")
    liste_ids_londres = liste_ids %>% 
        data.frame %>% 
        rownames_to_column() %>% 
        filter(substr(region, 1, 3) == "UKI")
    
    nb_region_londres = liste_ids_londres %>% nrow
    
    moyenne_londres = data2 %>%
        group_by(region) %>%
        summarise_all(mean, na.rm = T) %>%
        filter(region == "UKIX") %>% 
        slice(rep(1, each = nb_region_londres)) %>% 
        mutate(region = liste_ids_londres$region) %>% 
        left_join(liste_ids_londres, by = c("region"))
    
    moyenne_region = moyenne_region %>%
        rownames_to_column() %>%
        anti_join(moyenne_londres, by = c("region")) %>%
        bind_rows(moyenne_londres) %>%
        mutate(rowname = as.integer(rowname)) %>%
        arrange(rowname) %>% 
        select(-rowname)
}

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
leaflet(get(choix_carte)) %>% 
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

