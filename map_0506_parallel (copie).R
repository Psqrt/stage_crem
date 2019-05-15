###################################################################################################
# Packages
###################################################################################################
# library(rjson)
# library(leaflet)
# library(geojsonio)
library(tidyverse)
library(crayon)
library(doMC)
registerDoMC(1)

###################################################################################################
# Setup global
###################################################################################################
importer_carte = 0 # choix : 0 ou 1
precision = 60 # choix : 1 ou 60
date_premiere_enquete = 2004
date_derniere_enquete = 2013
nombre_enquete = date_derniere_enquete - date_premiere_enquete + 1
date_debut = Sys.time()
cat(green("######################################################################################
Paramètres d'importation :
    * Importer les fichiers geojson des cartes : ", as.logical(importer_carte), "
    * Précision des tracés des frontières      : 1:", precision, "
    * Année de la première enquête à importer  : ", date_premiere_enquete, "
    * Année de la dernière enquête à importer  : ", date_derniere_enquete, "
######################################################################################\n"),
    sep = "")

###################################################################################################
# Importations
###################################################################################################

# DONNEES - DICTIONNAIRE

cat(blue("Importation des dictionnaires de recodage [...]\n"))
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

dico_variable = read.csv(file = "./data/liste_variable.csv",
                         sep = ",",
                         header = T,
                         stringsAsFactors = F)

dico_variable = setNames(dico_variable$code,
                         dico_variable$label)


cat(green("[...] Terminé !\n"))

# DONNEES - CARTES

if (importer_carte == 1){
    cat(blue("Importation des cartes [...]\n"))
    if (precision == 60){
        # DONNEES - CARTE NUTS2
        data_map2003_nuts2 = geojsonio::geojson_read("./data/map1:60/NUTS_RG_20M_2003_4326_LEVL_2.geojson", what = "sp")
        data_map2006_nuts2 = geojsonio::geojson_read("./data/map1:60/NUTS_RG_60M_2006_4326_LEVL_2.geojson", what = "sp")
        data_map2010_nuts2 = geojsonio::geojson_read("./data/map1:60/NUTS_RG_60M_2010_4326_LEVL_2.geojson", what = "sp")
        data_map2013_nuts2 = geojsonio::geojson_read("./data/map1:60/NUTS_RG_60M_2013_4326_LEVL_2.geojson", what = "sp")
        data_map2016_nuts2 = geojsonio::geojson_read("./data/map1:60/NUTS_RG_60M_2016_4326_LEVL_2.geojson", what = "sp")
        # DONNEES - CARTE NUTS1
        data_map2003_nuts1 = geojsonio::geojson_read("./data/map1:60/NUTS_RG_20M_2003_4326_LEVL_1.geojson", what = "sp")
        data_map2006_nuts1 = geojsonio::geojson_read("./data/map1:60/NUTS_RG_60M_2006_4326_LEVL_1.geojson", what = "sp")
        data_map2010_nuts1 = geojsonio::geojson_read("./data/map1:60/NUTS_RG_60M_2010_4326_LEVL_1.geojson", what = "sp")
        data_map2013_nuts1 = geojsonio::geojson_read("./data/map1:60/NUTS_RG_60M_2013_4326_LEVL_1.geojson", what = "sp")
        data_map2016_nuts1 = geojsonio::geojson_read("./data/map1:60/NUTS_RG_60M_2016_4326_LEVL_1.geojson", what = "sp")
        # DONNEES - CARTE NUTS0
        data_map2003_nuts0 = geojsonio::geojson_read("./data/map1:60/NUTS_RG_20M_2003_4326_LEVL_0.geojson", what = "sp")
        data_map2006_nuts0 = geojsonio::geojson_read("./data/map1:60/NUTS_RG_60M_2006_4326_LEVL_0.geojson", what = "sp")
        data_map2010_nuts0 = geojsonio::geojson_read("./data/map1:60/NUTS_RG_60M_2010_4326_LEVL_0.geojson", what = "sp")
        data_map2013_nuts0 = geojsonio::geojson_read("./data/map1:60/NUTS_RG_60M_2013_4326_LEVL_0.geojson", what = "sp")
        data_map2016_nuts0 = geojsonio::geojson_read("./data/map1:60/NUTS_RG_60M_2016_4326_LEVL_0.geojson", what = "sp")
        # FRONTIERES
        data_map2003_nuts0_front = geojsonio::geojson_read("./data/map1:60/NUTS_BN_20M_2003_4326_LEVL_0.geojson", what = "sp")
        data_map2006_nuts0_front = geojsonio::geojson_read("./data/map1:60/NUTS_BN_60M_2006_4326_LEVL_0.geojson", what = "sp")
        data_map2010_nuts0_front = geojsonio::geojson_read("./data/map1:60/NUTS_BN_60M_2010_4326_LEVL_0.geojson", what = "sp")
        data_map2013_nuts0_front = geojsonio::geojson_read("./data/map1:60/NUTS_BN_60M_2013_4326_LEVL_0.geojson", what = "sp")
        data_map2016_nuts0_front = geojsonio::geojson_read("./data/map1:60/NUTS_BN_60M_2016_4326_LEVL_0.geojson", what = "sp")
    } else if (precision == 1){
        # DONNEES - CARTE NUTS2
        data_map2003_nuts2 = geojsonio::geojson_read("./data/map1:1/NUTS_RG_01M_2003_4326_LEVL_2.geojson", what = "sp")
        data_map2006_nuts2 = geojsonio::geojson_read("./data/map1:1/NUTS_RG_01M_2006_4326_LEVL_2.geojson", what = "sp")
        data_map2010_nuts2 = geojsonio::geojson_read("./data/map1:1/NUTS_RG_01M_2010_4326_LEVL_2.geojson", what = "sp")
        data_map2013_nuts2 = geojsonio::geojson_read("./data/map1:1/NUTS_RG_01M_2013_4326_LEVL_2.geojson", what = "sp")
        data_map2016_nuts2 = geojsonio::geojson_read("./data/map1:1/NUTS_RG_01M_2016_4326_LEVL_2.geojson", what = "sp")
        # DONNEES - CARTE NUTS1
        data_map2003_nuts1 = geojsonio::geojson_read("./data/map1:1/NUTS_RG_01M_2003_4326_LEVL_1.geojson", what = "sp")
        data_map2006_nuts1 = geojsonio::geojson_read("./data/map1:1/NUTS_RG_01M_2006_4326_LEVL_1.geojson", what = "sp")
        data_map2010_nuts1 = geojsonio::geojson_read("./data/map1:1/NUTS_RG_01M_2010_4326_LEVL_1.geojson", what = "sp")
        data_map2013_nuts1 = geojsonio::geojson_read("./data/map1:1/NUTS_RG_01M_2013_4326_LEVL_1.geojson", what = "sp")
        data_map2016_nuts1 = geojsonio::geojson_read("./data/map1:1/NUTS_RG_01M_2016_4326_LEVL_1.geojson", what = "sp")
        # DONNEES - CARTE NUTS0
        data_map2003_nuts0 = geojsonio::geojson_read("./data/map1:1/NUTS_RG_01M_2003_4326_LEVL_0.geojson", what = "sp")
        data_map2006_nuts0 = geojsonio::geojson_read("./data/map1:1/NUTS_RG_01M_2006_4326_LEVL_0.geojson", what = "sp")
        data_map2010_nuts0 = geojsonio::geojson_read("./data/map1:1/NUTS_RG_01M_2010_4326_LEVL_0.geojson", what = "sp")
        data_map2013_nuts0 = geojsonio::geojson_read("./data/map1:1/NUTS_RG_01M_2013_4326_LEVL_0.geojson", what = "sp")
        data_map2016_nuts0 = geojsonio::geojson_read("./data/map1:1/NUTS_RG_01M_2016_4326_LEVL_0.geojson", what = "sp")
    }
    cat(green("[...] Terminé !\n"))
}


###################################################################################################
# Importations des données enquêtes puis traitement
###################################################################################################

df_final_menage = data.frame()
df_final_personne = data.frame()

zozo = foreach (annee_enquete = c(date_premiere_enquete:date_derniere_enquete)) %dopar% {
    
    df_annee_menage = data.frame()
    df_annee_personne = data.frame()
    
    # Liste des fichiers de données (les fichiers zip)
    liste_nom_fichier = list.files("./data/enquete/")
    liste_nom_fichier = liste_nom_fichier[grep(annee_enquete, liste_nom_fichier)]
    liste_nom_fichier = substr(liste_nom_fichier, 1, nchar(liste_nom_fichier)-4)
    
    
    type_fichier = c("h", "d", "p", "r")
    # type_fichier = c("h", "d")
    
    df_h = data.frame()
    df_d = data.frame()
    df_p = data.frame()
    df_r = data.frame()
    
    # Logique d'importation : importer les 4 fichiers csv de chaque fichier zip.
    for (fichier in liste_nom_fichier) {
        # cat(blue("Importation de :", fichier, "\n"))
        dir_zip = paste0("./data/enquete/", fichier, ".zip", sep = "")
        for (type in type_fichier) {
            # cat(blue("    * Importation du fichier du type :", type, "\n"))
            dir_csv = paste0(substr(fichier, 1, 7), type, substr(fichier, 8, nchar(fichier)), ".csv", sep = "")
            provisoire = read.csv(con <- unz(dir_zip, dir_csv),
                                  header = T,
                                  sep = ",",
                                  stringsAsFactors = F)
                                  # colClasses = c("character"))
            if (type == "h"){
                df_h = bind_rows(df_h, provisoire)
            } else if (type == "d") {
                df_d = bind_rows(df_d, provisoire)
            } else if (type == "p") {
                if ("PL050" %in% colnames(provisoire)){
                    provisoire = provisoire %>% 
                        select(-PL050)
                }
                if ("PE040" %in% colnames(provisoire)){
                    provisoire = provisoire %>% 
                        select(-PE040)
                }
                if ("PL051" %in% colnames(provisoire)){
                    provisoire = provisoire %>% 
                        select(-PL051)
                }
                if ("PB040" %in% colnames(provisoire)){
                    provisoire = provisoire %>% 
                        select(-PB040)
                }
                if ("PY010G" %in% colnames(provisoire)){
                    provisoire = provisoire %>% 
                        select(-PY010G)
                }
                if ("PY050G" %in% colnames(provisoire)){
                    provisoire = provisoire %>% 
                        select(-PY050G)
                }
                df_p = bind_rows(df_p, provisoire)
            } else if (type == "r") {
                df_r = bind_rows(df_r, provisoire)
            }
        }
    }
    
    
    ###################################################################################################
    # Jointure
    ###################################################################################################
    # Fusion table H avec table D à partir des identifiants
    df_menage_t = df_h %>% 
        inner_join(df_d, by = c("HB030" = "DB030", "HB020" = "DB020", "HB010" = "DB010")) %>% 
        mutate(HB010 = as.character(HB010),
               HB020 = as.character(HB020),
               HB030 = as.character(HB030))
    
    df_personne_t = df_r %>% 
        inner_join(df_p, by = c("RB020" = "PB020", "RB030" = "PB030", "RB010" = "PB010"))
    
    for (nuts in c(0:2)) {
        # cat(green("Traitement pour l'année", annee_enquete, "pour le NUTS", nuts, "\n"))
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
        
        df_menage_t_copie = df_menage_t %>% 
            rename(REGION = DB040)
        
        df_personne_t_copie = df_personne_t %>% 
            rename(REGION = RB020)
        
        ###################################################################################################
        # Gestion des cas sans region (DE, SI, NL)
        ###################################################################################################
        
        if (nuts == 0){
            # cat(blue("Traitement des régions sans nom pour le cas de NUTS0 [...]\n"))
            moy_sans_region = df_menage_t_copie %>%
                filter(REGION == "")
            
            df_menage_t_copie = df_menage_t_copie %>% 
                bind_rows(moy_sans_region)
            # cat(green("[...] Terminé !\n"))
            
            
        }
        ### Recodage des regions pour etre conforme a la norme en vigueur #################################
        if (nuts == 2){
            if (annee_carte >= 2010){
                # cat(blue("Recodage des régions pour le cas des NUTS2 après 2010 de la Croatie [...]\n"))
                df_menage_t_copie$REGION = recode(df_menage_t_copie$REGION, !!!dico_enquete_croatie_apres_2010)
                # cat(green("[...] Terminé !\n"))
            }
            if (annee_carte >= 2013){
                # cat(blue("Recodage des régions pour le cas NUTS2 après 2013 du Royaume-Uni [...]\n"))
                df_menage_t_copie$REGION = recode(df_menage_t_copie$REGION, !!!dico_enquete_uk_apres_2013)
                # cat(green("[...] Terminé !\n"))
            }
        }
        
        # Selection de variables a representer (essais)
        liste_var_selection_menage = intersect(colnames(df_menage_t_copie), dico_variable)
        liste_var_selection_personne = intersect(colnames(df_personne_t_copie), dico_variable)
        
        data2_menage = df_menage_t_copie %>% 
            select(REGION, liste_var_selection_menage)
        
        data2_personne = df_personne_t_copie %>% 
            select(REGION, liste_var_selection_personne)
        
        # Recodage YES = 1 / NO = 0 pour donner un sens a la moyenne (proportion)
        # Transformation en variable binaire si necessaire
        ####################################################################################################### A FAIRE ########################
        # data2 = data2 %>% 
        #     mutate(warm = if_else(warm == 2, 0, 1),
        #            # arrears = if_else(arrears == 3, 0, 1),
        #            leaking = if_else(leaking == 2, 0, 1))
        
        # Calcul des moyennes par region
        if (nuts == 2){
            # cat(blue("Calcul des moyennes par région [...]\n"))
            moy_region_menage = data2_menage %>% # moy_region
                group_by(REGION) %>%
                group_by(NB_OBS = n(), add = T) %>% 
                summarise_all(list(moy = ~mean(., na.rm = T), na = ~sum(is.na(.)))) %>%
                ungroup() %>% 
                filter(REGION != "")
            cat(green("[...] Terminé !\n"))
        } else if (nuts <= 1){
            if (annee_carte < 2010){
                # x = moy_region
                # cat(blue("Recodage des régions pour le cas NUTS0 et NUTS1 avant 2010 [...]\n"))
                data3_menage = data2_menage %>% #moy_region
                    mutate(REGION = recode(REGION, !!!dico_enquete_avant_2010))
                
                data3_personne = data2_personne %>% 
                    mutate(REGION = recode(REGION, !!!dico_enquete_avant_2010))
                
                # cat(green("[...] Terminé !\n"))
                # y = moy_region
            } else if (annee_carte >= 2010 & annee_carte < 2013){
                # cat(blue("Recodage des régions pour le cas NUTS0 et NUTS1 entre 2010 et 2013 [...]\n"))
                data3_menage = data2_menage %>% #moy_region
                    mutate(REGION = recode(REGION, !!!dico_enquete_apres_2010))
                data3_personne = data2_personne
                # cat(green("[...] Terminé !\n"))
            } else {
                data3_menage = data2_menage
                data3_personne = data2_personne
            }
            # cat(blue("Calcul des moyennes par région [...]\n"))
            moy_region_menage = data3_menage %>% 
                mutate(REGION = substr(REGION, 1, nuts + 2)) %>%
                group_by(REGION) %>% 
                group_by(NB_OBS = n(), add = T) %>% 
                summarise_all(list(moy = ~mean(., na.rm = T), na = ~sum(is.na(.)))) %>%
                ungroup() %>% 
                filter(REGION != "")
            
            moy_region_personne = data3_personne %>%
                group_by(REGION) %>% 
                group_by(NB_OBS = n(), add = T) %>% 
                summarise_all(list(moy = ~mean(., na.rm = T), na = ~sum(is.na(.)))) %>%
                ungroup() %>% 
                filter(REGION != "")
            # cat(green("[...] Terminé !\n"))
        }
        
        ###################################################################################################
        # Gestion des erreurs des données enquête
        ###################################################################################################
        
        if (nuts == 2){
            if (annee_carte >= 2010 & annee_carte < 2013){
                moy_region_menage$REGION = recode(moy_region_menage$REGION, !!!dico_enquete_apres_2010)
            } else if (annee_carte < 2010){
                moy_region_menage$REGION = recode(moy_region_menage$REGION, !!!dico_enquete_avant_2010)
            }
        } else if (nuts == 0){
            if (annee_carte < 2010){
                moy_region_menage = moy_region_menage %>% 
                    mutate(REGION = recode(REGION, !!!dico_enquete_avant_2010))
                
                moy_region_personne = moy_region_personne %>% 
                    mutate(REGION = recode(REGION, !!!dico_enquete_avant_2010))
            }
        }
        
        ###################################################################################################
        # Récupération des régions de la carte
        ###################################################################################################
        
        # liste des identifiants nuts2 de la carte
        # cat(blue("Jointure entre la liste des régions de la carte et notre liste de valeurs [...]\n"))
        choix_carte = paste0("data_map", annee_carte, "_nuts", nuts, sep = "")
        liste_ids = data.frame("REGION" = get(choix_carte)$NUTS_ID)
        
        # conversion en char pour merger
        liste_ids[, "REGION"] = as.character(liste_ids[, "REGION"])
        
        # jointure : l'idee est d'associer une valeur existante pour chaque region, sinon un NA
        moyenne_region_menage = liste_ids %>%
            left_join(moy_region_menage, by = "REGION")
        
        moyenne_region_personne = liste_ids %>%
            left_join(moy_region_personne, by = "REGION")
        # cat(green("[...] Terminé !\n"))
        
        ###################################################################################################
        # Gestion du cas de Londres en 2013 (2 valeurs pour 5 régions)
        ###################################################################################################
        
        if (nuts == 2 & annee_carte >= 2010){
            liste_ids_londres = liste_ids %>% 
                data.frame %>% 
                rownames_to_column() %>% 
                filter(substr(REGION, 1, 3) == "UKI")
            
            nb_region_londres = liste_ids_londres %>% nrow
            
            moyenne_londres = data2_menage %>%
                group_by(REGION) %>%
                group_by(NB_OBS = n(), add = T) %>% 
                summarise_all(list(moy = ~mean(., na.rm = T), na = ~sum(is.na(.)))) %>%
                ungroup() %>% 
                filter(REGION == "UKIX")
            
            if (nrow(moyenne_londres) != 0){ 
                moyenne_londres = moyenne_londres %>% 
                    slice(rep(1, each = nb_region_londres)) %>%
                    mutate(REGION = liste_ids_londres$REGION) %>% 
                    left_join(liste_ids_londres, by = c("REGION"))
            }
            
            moyenne_region_menage = moyenne_region_menage %>%
                rownames_to_column() %>%
                anti_join(moyenne_londres, by = c("REGION")) %>%
                bind_rows(moyenne_londres) %>%
                mutate(rowname = as.integer(rowname)) %>%
                arrange(rowname) %>% 
                select(-rowname)
        }
        
        moyenne_region_menage = moyenne_region_menage %>% 
            mutate(NUTS = paste0("NUTS ", nuts),
                   ANNEE = annee_enquete,
                   PAYS = substr(REGION, 1, 2))
        
        moyenne_region_personne = moyenne_region_personne %>% 
            mutate(NUTS = paste0("NUTS ", nuts),
                   ANNEE = annee_enquete,
                   PAYS = substr(REGION, 1, 2))
        
        df_annee_menage <<- df_annee_menage %>% 
            bind_rows(moyenne_region_menage)
        
        df_annee_personne <<- df_annee_personne %>% 
            bind_rows(moyenne_region_personne)
    }
    
    # liste_df_annee = list(df_annee_menage, df_annee_personne)
    # return(liste_df_annee)
}

for (i in c(1:nombre_enquete)){
    df_final_menage = df_final_menage %>% 
        bind_rows(zozo[[i]][[1]])
}



for (i in c(1:nombre_enquete)){
    df_final_personne = df_final_personne %>% 
        bind_rows(zozo[[i]][[2]])
}

        # Mise à jour de la table finale
        # cat(blue("Mise à jour de la table finale [...]\n"))
        # df_final = df_final %>% 
        #     rbind(moyenne_region)
        # cat(green("[...] Terminé !\n"))



###################################################################################################
# Exportation tableau final
###################################################################################################

cat(blue("Préparation de la table finale avant exportation [...]\n"))
df_final2_menage = df_final_menage %>% 
    select(-NUTS, -ANNEE, -PAYS, -REGION) %>% 
    round(4) %>% 
    cbind(df_final_menage %>% 
              select(NUTS, ANNEE, PAYS, REGION)) %>% 
    select(PAYS, REGION, NUTS, ANNEE, everything()) %>% 
    mutate_at(vars(contains("_na")), funs(round(./NB_OBS, 4)))
df_final2_personne = df_final_personne %>% 
    select(-NUTS, -ANNEE, -PAYS, -REGION) %>% 
    round(4) %>% 
    cbind(df_final_personne %>% 
              select(NUTS, ANNEE, PAYS, REGION)) %>% 
    select(PAYS, REGION, NUTS, ANNEE, everything()) %>% 
    mutate_at(vars(contains("_na")), funs(round(./NB_OBS, 4)))
cat(green("[...] Terminé !\n"))


# bac à sable

liste_periode = list(c(2004:2005),
                     c(2006:2009),
                     c(2010:2012),
                     c(2013:2015))

df_periode = data.frame()

for (i in c(1:length(liste_periode))){
    df_moy_periode = df_final2 %>%
        mutate_at(vars(contains("_moy")), funs(. * NB_OBS)) %>% 
        filter(ANNEE %in% liste_periode[[i]]) %>% 
        group_by(REGION) %>% 
        summarise_at(vars(contains("_moy")), funs(sum(.)/sum(NB_OBS))) %>%
        mutate(PERIODE = paste(liste_periode[[i]][1], "-", liste_periode[[i]][length(liste_periode[[i]])], sep = "")) %>% 
        select(REGION, PERIODE, contains("_moy"))
    
    df_presente_periode = df_final2 %>% 
        filter(ANNEE %in% liste_periode[[i]]) %>% 
        filter(!is.na(NB_OBS)) %>%
        group_by(REGION) %>% 
        mutate(ANNEES_PRESENTES = paste(unlist(unique(ANNEE)), collapse = ", ")) %>% 
        select(PAYS, REGION, NUTS, ANNEES_PRESENTES) %>% 
        distinct() %>% 
        select(REGION, ANNEES_PRESENTES)
    
    df_ordre_periode = df_final2 %>% 
        filter(ANNEE == liste_periode[[i]][1]) %>% 
        select(PAYS, REGION, NUTS, NB_OBS, contains("_na"))
    
    df_tot = df_ordre_periode %>% 
        left_join(df_moy_periode, by = c("REGION")) %>% 
        left_join(df_presente_periode, by = c("REGION"))
    
    df_periode = df_periode %>% 
        bind_rows(df_tot)
}


df_final3 = df_final2 %>% 
    bind_rows(df_periode)


cat(blue("Exportation de la table finale [...]\n"))
write.csv(df_final3, file = "./data/finaux/donnees.csv",
          row.names = F)
cat(green("[...] Terminé !\n"))

date_fin = Sys.time()
diff = date_fin - date_debut
print(diff)
