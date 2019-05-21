###################################################################################################
# Packages
###################################################################################################
# library(rjson)
# library(leaflet)
# library(geojsonio)
library(tidyverse)
library(crayon)
library(ade4)
# library(doMC)
# registerDoMC(3)

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

dico_variable_import = read.csv(file = "./data/liste_variable.csv",
                                sep = ",",
                                header = T,
                                stringsAsFactors = F)

dico_variable = setNames(dico_variable_import$code,
                         dico_variable_import$label)

dico_variable_moy = setNames(paste(dico_variable_import$code, "_moy", sep = ""),
                             dico_variable_import$label)


liste_variable_binaire = read.csv(file = "./data/liste_variable_binaire.csv",
                                sep = ",",
                                header = T,
                                stringsAsFactors = F) %>% unlist(use.names = F)


liste_variable_quali = read.csv(file = "./data/liste_variable_quali.csv",
                                sep = ",",
                                header = T,
                                stringsAsFactors = F) %>% unlist(use.names = F)
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
        # # FRONTIERES
        # data_map2003_nuts0_front = geojsonio::geojson_read("./data/map1:60/NUTS_BN_20M_2003_4326_LEVL_0.geojson", what = "sp")
        # data_map2006_nuts0_front = geojsonio::geojson_read("./data/map1:60/NUTS_BN_60M_2006_4326_LEVL_0.geojson", what = "sp")
        # data_map2010_nuts0_front = geojsonio::geojson_read("./data/map1:60/NUTS_BN_60M_2010_4326_LEVL_0.geojson", what = "sp")
        # data_map2013_nuts0_front = geojsonio::geojson_read("./data/map1:60/NUTS_BN_60M_2013_4326_LEVL_0.geojson", what = "sp")
        # data_map2016_nuts0_front = geojsonio::geojson_read("./data/map1:60/NUTS_BN_60M_2016_4326_LEVL_0.geojson", what = "sp")
        # # NOMS PAYS
        # data_map2003_nuts0_noms = geojsonio::geojson_read("./data/map1:60/NUTS_LB_2003_4326_LEVL_0.geojson", what = "sp")
        # data_map2006_nuts0_noms = geojsonio::geojson_read("./data/map1:60/NUTS_LB_2006_4326_LEVL_0.geojson", what = "sp")
        # data_map2010_nuts0_noms = geojsonio::geojson_read("./data/map1:60/NUTS_LB_2010_4326_LEVL_0.geojson", what = "sp")
        # data_map2013_nuts0_noms = geojsonio::geojson_read("./data/map1:60/NUTS_LB_2013_4326_LEVL_0.geojson", what = "sp")
        # data_map2016_nuts0_noms = geojsonio::geojson_read("./data/map1:60/NUTS_LB_2016_4326_LEVL_0.geojson", what = "sp")
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

df_annee_menage = data.frame()
df_annee_personne = data.frame()

# zozo = foreach (annee_enquete = c(date_premiere_enquete:date_derniere_enquete)) %dopar% {
for (annee_enquete in c(date_premiere_enquete:date_derniere_enquete)) {
    
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
        cat(blue("Importation de :", fichier, "\n"))
        dir_zip = paste0("./data/enquete/", fichier, ".zip", sep = "")
        for (type in type_fichier) {
            cat(blue("    * Importation du fichier du type :", type, "\n"))
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
    
    print("SORTIE IMPORTATIONS")
    ###################################################################################################
    # Jointure 
    ###################################################################################################
    # Listing des variables binaires et quali pour chaque type de fichier (HD et RP)
    liste_variable_binaire_hd = liste_variable_binaire[substr(liste_variable_binaire, 1, 1) %in% c("H", "D")]
    liste_variable_binaire_rp = liste_variable_binaire[substr(liste_variable_binaire, 1, 1) %in% c("R", "P")]
    
    liste_variable_quali_hd = liste_variable_quali[substr(liste_variable_quali, 1, 1) %in% c("H", "D")]
    liste_variable_quali_rp = liste_variable_quali[substr(liste_variable_quali, 1, 1) %in% c("R", "P")]
    
    
    print("SORTIE CREATION LISTE")
    # Fusion table H avec table D à partir des identifiants
    df_menage_t = df_h %>% 
        inner_join(df_d, by = c("HB030" = "DB030", "HB020" = "DB020", "HB010" = "DB010"))
    print("SORTIE INNER JOIN H ET D")
    # FILTRAGE VARIABLES PRESENTES DANS L'ENQUETE EN COURS EN FONCTION DE CELLES RETENUES (DICTIONNAIRE)
    liste_variable_binaire_hd_presente = intersect(colnames(df_menage_t), liste_variable_binaire_hd)
    liste_variable_quali_hd_presente = intersect(colnames(df_menage_t), liste_variable_quali_hd)
    print("SORTIE INTERSECT")
    # SUPPRESSION DES VALEURS PARASITES PUIS RECODAGE DES MODALITES
    df_menage_t = df_menage_t %>% 
        mutate_at(vars(liste_variable_binaire_hd_presente), list(~if_else(. == "2", "0", if_else(. == "1", "1", as.character(NA))))) %>% 
        mutate_at(vars(liste_variable_quali_hd_presente), list(~if_else(. %in% c("", "0", "0-1", "0 - 1", "NAs"), as.character(NA), .)))
        # mutate(HB010 = as.character(HB010),
        #        HB020 = as.character(HB020),
        #        HB030 = as.character(HB030))
    print("SORTIE RECODAGE")
    # CREATION ET RAJOUT DU TABLEAU DISJONCTIF DANS LA BASE INITIALE EN SUPPRIMANT LES VARIABLES QUALITATIVES CORRESPONDANTES AVANT DISJONCTIF
    df_menage_t = df_menage_t %>% 
        select(-liste_variable_quali_hd_presente) %>% 
        cbind(df_menage_t %>% 
                  select(liste_variable_quali_hd_presente) %>% 
                  acm.disjonctif())
    
    
    print("X1")
    # Fusion table R avec table P à partir des identifiants
    df_personne_t = df_r %>% 
        inner_join(df_p, by = c("RB020" = "PB020", "RB030" = "PB030", "RB010" = "PB010"))
    print("X2")
    # FILTRAGE VARIABLES PRESENTES DANS L'ENQUETE EN COURS EN FONCTION DE CELLES RETENUES (DICTIONNAIRE)
    liste_variable_binaire_rp_presente = intersect(colnames(df_personne_t), liste_variable_binaire_rp)
    liste_variable_quali_rp_presente = intersect(colnames(df_personne_t), liste_variable_quali_rp)
    # SUPPRESSION DES VALEURS PARASITES PUIS RECODAGE DES MODALITES
    print("X3")
    df_personne_t = df_personne_t %>% 
        mutate(PE040 = as.character(as.numeric(PE040) + 1)) %>% 
        mutate_at(vars(liste_variable_binaire_rp_presente), list(~if_else(. == "2", "0", if_else(. == "1", "1", as.character(NA))))) %>% 
        mutate_at(vars(liste_variable_quali_rp_presente), list(~if_else(. %in% c("", "0", "0-1", "0 - 1", "NAs"), as.character(NA), .))) %>% 
        mutate(PE040 = as.character(as.numeric(PE040) - 1))
    print("X4")
    # CREATION ET RAJOUT DU TABLEAU DISJONCTIF DANS LA BASE INITIALE EN SUPPRIMANT LES VARIABLES QUALITATIVES CORRESPONDANTES AVANT DISJONCTIF
    df_personne_t = df_personne_t %>% 
        select(-liste_variable_quali_rp_presente) %>% 
        cbind(df_personne_t %>% 
                  select(liste_variable_quali_rp_presente) %>% 
                  acm.disjonctif())
    
    
    
    
    for (nuts in c(0:2)) {
        cat(green("Traitement pour l'année", annee_enquete, "pour le NUTS", nuts, "\n"))
        # identification de la carte en fonction de l'enquete
        # pourquoi ? de manière à respecter la norme en vigueur pour l'enquete etudiee
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
        
        # copie des bases importées pour être traitées ensuite
        # pourquoi ? pour éviter de réimporter pour chaque nuts
        # les calculs modifient la base, donc on sauvegarde la base
        df_menage_t_copie = df_menage_t %>% 
            rename(REGION = DB040)
        
        df_personne_t_copie = df_personne_t %>% 
            rename(REGION = RB020)
        
        ###################################################################################################
        # Gestion des cas sans region (DE, SI, NL)
        ###################################################################################################
        
        if (nuts == 0){
            cat(blue("Traitement des régions sans nom pour le cas de NUTS0 [...]\n"))
            moy_sans_region = df_menage_t_copie %>%
                filter(REGION == "")
            
            df_menage_t_copie = df_menage_t_copie %>% 
                bind_rows(moy_sans_region)
            cat(green("[...] Terminé !\n"))
            
            
        }
        ### Recodage des regions pour etre conforme a la norme en vigueur #################################
        if (nuts == 2){
            if (annee_carte >= 2010){
                cat(blue("Recodage des régions pour le cas des NUTS2 après 2010 de la Croatie [...]\n"))
                df_menage_t_copie$REGION = recode(df_menage_t_copie$REGION, !!!dico_enquete_croatie_apres_2010)
                cat(green("[...] Terminé !\n"))
            }
            if (annee_carte >= 2013){
                cat(blue("Recodage des régions pour le cas NUTS2 après 2013 du Royaume-Uni [...]\n"))
                df_menage_t_copie$REGION = recode(df_menage_t_copie$REGION, !!!dico_enquete_uk_apres_2013)
                cat(green("[...] Terminé !\n"))
            }
        }
        
        # Selection de variables a representer ###############
        # on restreint la liste à ce qu'on veut ET ce qu'on a à pour une enquete a l'annee T
        # pour eviter de selectionner une variable qui n'existe pas a ce moment (erreur R)
        liste_var_selection_menage = intersect(colnames(df_menage_t_copie), dico_variable)
        liste_var_selection_personne = intersect(colnames(df_personne_t_copie), dico_variable)
        
        data2_menage = df_menage_t_copie %>% 
            select(REGION, liste_var_selection_menage, contains("."))
        
        data2_personne = df_personne_t_copie %>% 
            select(REGION, liste_var_selection_personne, contains("."))


        # Calcul des moyennes par region
        if (nuts == 2){
            cat(blue("Calcul des moyennes par région [...]\n"))
            moy_region_menage = data2_menage %>% # moy_region
                mutate_at(vars(-REGION), as.numeric) %>% 
                group_by(REGION) %>%
                group_by(NB_OBS = n(), add = T) %>% 
                summarise_all(list(moy = ~mean(., na.rm = T), na = ~sum(is.na(.)))) %>%
                ungroup() %>% 
                filter(REGION != "")
            cat(green("[...] Terminé !\n"))
        } else if (nuts <= 1){
            if (annee_carte < 2010){
                cat(blue("Recodage des régions pour le cas NUTS0 et NUTS1 avant 2010 [...]\n"))
                data3_menage = data2_menage %>%
                    mutate(REGION = recode(REGION, !!!dico_enquete_avant_2010))
                
                data3_personne = data2_personne %>% 
                    mutate(REGION = recode(REGION, !!!dico_enquete_avant_2010))
                
                cat(green("[...] Terminé !\n"))
            } else if (annee_carte >= 2010 & annee_carte < 2013){
                cat(blue("Recodage des régions pour le cas NUTS0 et NUTS1 entre 2010 et 2013 [...]\n"))
                data3_menage = data2_menage %>%
                    mutate(REGION = recode(REGION, !!!dico_enquete_apres_2010))
                data3_personne = data2_personne
                cat(green("[...] Terminé !\n"))
            } else {
                data3_menage = data2_menage
                data3_personne = data2_personne
            }
            cat(blue("Calcul des moyennes par région [...]\n"))
            moy_region_menage = data3_menage %>% 
                mutate_at(vars(-REGION), as.numeric) %>% 
                mutate(REGION = substr(REGION, 1, nuts + 2)) %>%
                group_by(REGION) %>% 
                group_by(NB_OBS = n(), add = T) %>% 
                summarise_all(list(moy = ~mean(., na.rm = T), na = ~sum(is.na(.)))) %>%
                ungroup() %>% 
                filter(REGION != "")
            
            moy_region_personne = data3_personne %>%
                mutate_at(vars(-REGION), as.numeric) %>% 
                group_by(REGION) %>% 
                group_by(NB_OBS = n(), add = T) %>% 
                summarise_all(list(moy = ~mean(., na.rm = T), na = ~sum(is.na(.)))) %>%
                ungroup() %>% 
                filter(REGION != "")
            cat(green("[...] Terminé !\n"))
        }
        
        
        ###################################################################################################
        # Gestion des erreurs des données enquête
        # On règle les incohérences des noms de régions entre cartes et enquetes
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
        # Création du socle ordonné pour recevoir les données
        ###################################################################################################
        
        # liste des identifiants nuts2 de la carte
        cat(blue("Jointure entre la liste des régions de la carte et notre liste de valeurs [...]\n"))
        choix_carte = paste0("data_map", annee_carte, "_nuts", nuts, sep = "")
        liste_ids = data.frame("REGION" = get(choix_carte)$NUTS_ID,
                               "NOM_REGION" = get(choix_carte)$NUTS_NAME)
        
        # conversion en char pour merger
        liste_ids[, "REGION"] = as.character(liste_ids[, "REGION"])
        liste_ids[, "NOM_REGION"] = as.character(liste_ids[, "NOM_REGION"])
        
        # jointure : l'idee est d'associer une valeur existante pour chaque region, sinon un NA
        moyenne_region_menage = liste_ids %>%
            left_join(moy_region_menage, by = "REGION")
        
        moyenne_region_personne = liste_ids %>%
            left_join(moy_region_personne, by = "REGION")
        cat(green("[...] Terminé !\n"))
        
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
                mutate_at(vars(-REGION), as.numeric) %>% 
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
        
        # On cree les variables qui indiquent le niveau NUTS, l'annee en cours et le pays traite a partir de la region
        
        moyenne_region_menage = moyenne_region_menage %>% 
            mutate(NUTS = paste0("NUTS ", nuts),
                   ANNEE = annee_enquete,
                   PAYS = substr(REGION, 1, 2))
        
        moyenne_region_personne = moyenne_region_personne %>% 
            mutate(NUTS = paste0("NUTS ", nuts),
                   ANNEE = annee_enquete,
                   PAYS = substr(REGION, 1, 2))
        
        # mise a jour de la base finale
        df_annee_menage <<- df_annee_menage %>% 
            bind_rows(moyenne_region_menage)
        
        df_annee_personne <<- df_annee_personne %>% 
            bind_rows(moyenne_region_personne)
    }
}


###################################################################################################
# Exportation tableau final
###################################################################################################


# réordonner les colonnes pour avoir les variables d'identification au début et calcul des pourcentages de NA
cat(blue("Préparation de la table finale avant exportation [...]\n"))
df_final2_menage = df_annee_menage %>% 
    select(-NUTS, -ANNEE, -PAYS, -REGION, -NOM_REGION) %>% 
    round(4) %>% 
    cbind(df_annee_menage %>% 
              select(NUTS, ANNEE, PAYS, REGION, NOM_REGION)) %>% 
    select(PAYS, REGION, NOM_REGION, NUTS, ANNEE, everything()) %>% 
    mutate_at(vars(contains("_na")), funs(round(./NB_OBS, 4)))
df_final2_personne = df_annee_personne %>% 
    select(-NUTS, -ANNEE, -PAYS, -REGION, -NOM_REGION) %>% 
    round(4) %>% 
    cbind(df_annee_personne %>% 
              select(NUTS, ANNEE, PAYS, REGION, NOM_REGION)) %>% 
    select(PAYS, REGION, NOM_REGION, NUTS, ANNEE, everything()) %>% 
    mutate_at(vars(contains("_na")), funs(round(./NB_OBS, 4)))
cat(green("[...] Terminé !\n"))

########## PARTIE TRAITEMENT PAR PERIODES ################################

liste_periode = list(c(2004:2005),
                     c(2006:2009),
                     c(2010:2012),
                     c(2013:2015))

# préparation des bases finales
df_periode_menage = data.frame()
df_periode_personne = data.frame()

# calcul des moyennes ponderees pour chaque periode
for (i in c(1:length(liste_periode))){
    df_moy_periode_menage = df_final2_menage %>%
        mutate_at(vars(contains("_moy")), funs(. * NB_OBS)) %>% 
        filter(ANNEE %in% liste_periode[[i]]) %>% 
        group_by(REGION) %>% 
        summarise_at(vars(contains("_moy")), funs(sum(.)/sum(NB_OBS))) %>%
        mutate(PERIODE = paste(liste_periode[[i]][1], "-", liste_periode[[i]][length(liste_periode[[i]])], sep = "")) %>% 
        select(REGION, PERIODE, contains("_moy"))
    
    df_presente_periode_menage = df_final2_menage %>% 
        filter(ANNEE %in% liste_periode[[i]]) %>% 
        filter(!is.na(NB_OBS)) %>%
        group_by(REGION) %>% 
        mutate(ANNEES_PRESENTES = paste(unlist(unique(ANNEE)), collapse = ", ")) %>% 
        select(PAYS, REGION, NUTS, ANNEES_PRESENTES) %>% 
        distinct() %>% 
        select(REGION, ANNEES_PRESENTES)
    
    df_ordre_periode_menage = df_final2_menage %>% 
        filter(ANNEE == liste_periode[[i]][1]) %>% 
        select(PAYS, REGION, NOM_REGION, NUTS, NB_OBS, contains("_na"))
    
    df_tot_menage = df_ordre_periode_menage %>% 
        left_join(df_moy_periode_menage, by = c("REGION")) %>% 
        left_join(df_presente_periode_menage, by = c("REGION"))
    
    df_periode_menage = df_periode_menage %>% 
        bind_rows(df_tot_menage)
    
    
    
    
    
    df_moy_periode_personne = df_final2_personne %>%
        mutate_at(vars(contains("_moy")), funs(. * NB_OBS)) %>% 
        filter(ANNEE %in% liste_periode[[i]]) %>% 
        group_by(REGION) %>% 
        summarise_at(vars(contains("_moy")), funs(sum(.)/sum(NB_OBS))) %>%
        mutate(PERIODE = paste(liste_periode[[i]][1], "-", liste_periode[[i]][length(liste_periode[[i]])], sep = "")) %>% 
        select(REGION, PERIODE, contains("_moy"))
    
    df_presente_periode_personne = df_final2_personne %>% 
        filter(ANNEE %in% liste_periode[[i]]) %>% 
        filter(!is.na(NB_OBS)) %>%
        group_by(REGION) %>% 
        mutate(ANNEES_PRESENTES = paste(unlist(unique(ANNEE)), collapse = ", ")) %>% 
        select(PAYS, REGION, NUTS, ANNEES_PRESENTES) %>% 
        distinct() %>% 
        select(REGION, ANNEES_PRESENTES)
    
    df_ordre_periode_personne = df_final2_personne %>% 
        filter(ANNEE == liste_periode[[i]][1]) %>% 
        select(PAYS, REGION, NOM_REGION, NUTS, NB_OBS, contains("_na"))
    
    df_tot_personne = df_ordre_periode_personne %>% 
        left_join(df_moy_periode_personne, by = c("REGION")) %>% 
        left_join(df_presente_periode_personne, by = c("REGION"))
    
    df_periode_personne = df_periode_personne %>% 
        bind_rows(df_tot_personne)
}

# on recolle les donnees par annee avec les donnees par periode
df_final3_menage = df_final2_menage %>% 
    bind_rows(df_periode_menage)

df_final3_personne = df_final2_personne %>% 
    bind_rows(df_periode_personne)

# regroupement de la partie MENAGE avec la partie PERSONNE
df_final3_tot = df_final3_menage %>% 
    rownames_to_column() %>% 
    inner_join(df_final3_personne %>% 
                   rownames_to_column() %>% 
                   select(-PAYS, -REGION, -NOM_REGION, -ANNEE, -NUTS, -PERIODE, -ANNEES_PRESENTES) %>% 
                   rename(NB_PERSONNE = NB_OBS), by = c("rowname")) %>% 
    select(-rowname) %>% 
    select(PAYS, REGION, NOM_REGION, NUTS, ANNEE, PERIODE, ANNEES_PRESENTES, NB_MENAGE = NB_OBS, NB_PERSONNE, everything())


# Exportation de la table finale qui servira de base de départ sur shiny
cat(blue("Exportation de la table finale [...]\n"))
write.csv(df_final3_tot, 
          file = "./data/finaux/donnees.csv",
          row.names = F)
cat(green("[...] Terminé !\n"))

# Exportation de la liste finale des variables à représenter
liste_variable_moy_final = df_final3_tot %>% 
    colnames %>% 
    data.frame(var = .) %>% 
    filter(grepl("_moy", var))
write.csv(liste_variable_moy_final,
          file = "./data/finaux/liste_variable_moy_final.csv",
          row.names = F)



# toto = df_final3_tot %>% 
#     select(REGION, NOM_REGION, ANNEE) %>% 
#     filter(!is.na(ANNEE)) %>% 
#     mutate(REGION = recode(REGION, !!!dico_enquete_avant_2010),
#            REGION = recode(REGION, !!!dico_enquete_apres_2010))




# df_final3_tot = moyenne_region

# bac à sable

mise_a_jour_stats = read.csv(file = "./data/mise_a_jour_stats.csv",
                             header = T,
                             sep = ",",
                             stringsAsFactors = F)

mise_a_jour_stats = setNames(mise_a_jour_stats$nouveau,
                             mise_a_jour_stats$ancien)



df_final3_tot_stat = df_final3_tot %>% 
    filter(!is.na(ANNEE)) %>% 
    mutate(REGION = recode(REGION, !!!mise_a_jour_stats))

write.csv(df_final3_tot_stat,
          file = "./data/finaux/donnees_stats.csv",
          row.names = F)


liste_nuts0_stat = df_final3_tot_stat %>% 
    filter(NUTS == "NUTS 0") %>% 
    select(REGION, NOM_REGION) %>%
    group_by(REGION) %>% 
    summarise(NOM_REGION = first(NOM_REGION)) %>% 
    mutate(NOM_REGION = paste("[", substr(REGION, 1, 2), "] ", NOM_REGION, sep = "")) %>% 
    arrange(NOM_REGION)

liste_nuts1_stat = df_final3_tot_stat %>% 
    filter(NUTS == "NUTS 1") %>% 
    group_by(REGION) %>% 
    summarise(NOM_REGION = first(NOM_REGION)) %>% 
    mutate(NOM_REGION = paste("[", substr(REGION, 1, 2), "] ", NOM_REGION, sep = "")) %>% 
    arrange(NOM_REGION)

liste_nuts2_stat = df_final3_tot_stat %>% 
    filter(NUTS == "NUTS 2") %>% 
    group_by(REGION) %>% 
    summarise(NOM_REGION = first(NOM_REGION)) %>% 
    mutate(NOM_REGION = paste("[", substr(REGION, 1, 2), "] ", NOM_REGION, sep = "")) %>% 
    arrange(NOM_REGION)

write.csv(liste_nuts0_stat,
          file = "./data/finaux/liste_nuts0_stat.csv",
          row.names = F)

write.csv(liste_nuts1_stat,
          file = "./data/finaux/liste_nuts1_stat.csv",
          row.names = F)

write.csv(liste_nuts2_stat,
          file = "./data/finaux/liste_nuts2_stat.csv",
          row.names = F)











date_fin = Sys.time()
diff = date_fin - date_debut
print(diff)
