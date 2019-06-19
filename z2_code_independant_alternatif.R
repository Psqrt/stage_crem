########################################################################################################
# z2_code_independant.R -- Docstring (documentation)
########################################################################################################
#           Ce fichier permet de construire la base de données contenant les informations centrales
#           (moyennes, effectifs, régions, etc.) pour être repris par les fichiers z suivants (z3, z4)
#           afin d'alimenter l'application Shiny à partir d'une base de données agregées.
#          
#           À la fin du processus, les données de grande taille sont supprimées afin d'alléger
#           la mémoire vive pour la suite du processus de traitement des données.
########################################################################################################

########################################################################################################
# Packages
########################################################################################################
library(tidyverse) # traitements en tout genre
library(crayon) # affichage coloré dans la console
library(ade4) # tableau disjonctif complet

########################################################################################################
# Setup global
########################################################################################################

# Pour résoudre des problèmes d'encodage sur Windows ...
if (Sys.info()[1] == "Windows"){
    Sys.setlocale("LC_ALL","English")
}

# Si on ne lance pas depuis le fichier pilote, executer ceci :
if (!exists("execution_pilote")){
    importer_carte = 0 # choix : 0 ou 1
    precision = 60 # choix : 1 ou 60 # /!\ L'option precision = 1 n'est plus disponible
    chemin_repertoire_donnees = "./data/enquete2/" # en chemin relatif vers les données de l'enquête
    date_premiere_enquete = 2012
    date_derniere_enquete = 2012
    nombre_enquete = date_derniere_enquete - date_premiere_enquete + 1 # ne pas toucher
    
    # une période ne doit pas chevaucher une modification de la norme NUTS
    liste_periode = list(c(2004:2005),
                         c(2006:2009),
                         c(2010:2012),
                         c(2013:2015))
}

date_debut_code_indep = Sys.time()

cat(green("######################################################################################
Paramètres d'importation :
    * Importer les fichiers geojson des cartes : ", as.logical(importer_carte), "
    * Précision des tracés des frontières      : 1:", precision, "
    * Année de la première enquête à importer  : ", date_premiere_enquete, "
    * Année de la dernière enquête à importer  : ", date_derniere_enquete, "
######################################################################################\n"),
    sep = "")



########################################################################################################
# Importations
########################################################################################################

# DONNEES - DICTIONNAIRES ==============================================================================

# Importation du dictionnaire - codage avant 2010
# permet de corriger (harmoniser) le code des pays suivants sur les cartes de 2003 et 2006 :
# Grêce, Italie, Bulgarie, Roumanie, Finlande
cat(blue("Importation des dictionnaires de recodage [...]\n"))
dico_enquete_avant_2010 = read.csv(file = "./data/dictionnaire_codage_avant_2010.csv",
                                   sep = ",",
                                   header = T,
                                   stringsAsFactors = F,
                                   fileEncoding = "UTF-8")

# conversion en vecteur nommé (classe d'objet la plus proche d'un objet dictionnaire en python)
# les vecteurs nommés sont adaptés pour la fonction recode de dplyr 
dico_enquete_avant_2010 = setNames(dico_enquete_avant_2010$code_carte, 
                                   dico_enquete_avant_2010$code_enquete)

# Importation du dictionnaire - codage entre 2010 et 2013
# permet de corriger (harmoniser) le code des pays suivants sur les cartes de 2010 (2010, 2011, 2012) :
# Grêce
dico_enquete_entre_2010_2013 = read.csv(file = "./data/dictionnaire_codage_entre_2010_2013.csv",
                                        sep = ",",
                                        header = T,
                                        stringsAsFactors = F,
                                        fileEncoding = "UTF-8")

# REMARQUE IMPORTANTE : N'AYANT PAS LES DONNÉES DE 2016 ET PLUS, LE TRAITEMENT DES INCOHÉRENCES DE CODAGE
# DES REGIONS N'A PAS ÉTÉ FAITE POUR LE MOMENT.

# conversion en vecteur nommé (classe d'objet la plus proche d'un objet dictionnaire en python)
# les vecteurs nommés sont adaptés pour la fonction recode de dplyr 
dico_enquete_entre_2010_2013 = setNames(dico_enquete_entre_2010_2013$code_carte, 
                                        dico_enquete_entre_2010_2013$code_enquete)

# CODEBOOK-REFERENCE03 : importer les nouveaux dictionnaires et faire un setNames comme montré plus haut ici

# Importation du dictionnaire - codage Croatie après 2010
# permet de corriger le cas de la Croatie
dico_enquete_croatie_apres_2010 = read.csv(file = "./data/dictionnaire_codage_croatie_apres_2010.csv",
                                           sep = ",",
                                           header = T,
                                           stringsAsFactors = F,
                                           fileEncoding = "UTF-8")

# conversion en vecteur nommé (classe d'objet la plus proche d'un objet dictionnaire en python)
# les vecteurs nommés sont adaptés pour la fonction recode de dplyr 
dico_enquete_croatie_apres_2010 = setNames(dico_enquete_croatie_apres_2010$code_carte, 
                                           dico_enquete_croatie_apres_2010$code_enquete)


# Importation du dictionnaire - codage Royaume Uni après 2013
# permet de corriger le cas du Royaume-Uni (Londres plus précisement) 
dico_enquete_uk_apres_2013 = read.csv(file = "./data/dictionnaire_codage_uk_apres_2013.csv",
                                      sep = ",",
                                      header = T,
                                      stringsAsFactors = F,
                                      fileEncoding = "UTF-8")

# conversion en vecteur nommé (classe d'objet la plus proche d'un objet dictionnaire en python)
# les vecteurs nommés sont adaptés pour la fonction recode de dplyr 
dico_enquete_uk_apres_2013 = setNames(dico_enquete_uk_apres_2013$code_carte, 
                                      dico_enquete_uk_apres_2013$code_enquete)

# Création du dictionnaire d'association "code<>label" de la liste des variables enquêtes
# EX : HH050 | Ability to keep adequately warm
dico_variable_import = read.csv(file = "./data/liste_variable.csv",
                                sep = ",",
                                header = T,
                                stringsAsFactors = F,
                                fileEncoding = "UTF-8")

# conversion en vecteur nommé (classe d'objet la plus proche d'un objet dictionnaire en python)
dico_variable = setNames(dico_variable_import$code,
                         dico_variable_import$label)

# création de la liste avec ajout du suffixe "_moy"
dico_variable_moy = setNames(paste(dico_variable_import$code, "_moy", sep = ""),
                             dico_variable_import$label)

# liste des variables binaires (codes uniquement, servant à lister facilement les variables dans le traitement)
liste_variable_binaire = read.csv(file = "./data/liste_variable_binaire.csv",
                                  sep = ",",
                                  header = T,
                                  stringsAsFactors = F,
                                  fileEncoding = "UTF-8") %>% unlist(use.names = F)

# liste des variables qualitatives (codes uniquement, servant à lister facilement les variables dans le traitement)
liste_variable_quali = read.csv(file = "./data/liste_variable_quali.csv",
                                sep = ",",
                                header = T,
                                stringsAsFactors = F,
                                fileEncoding = "UTF-8") %>% unlist(use.names = F)

# liste des pays (code et nom complet)
dico_nom_pays = read.csv(file =  "./data/dico_pays_stats.csv",
                         sep = ",",
                         header = T,
                         stringsAsFactors = F,
                         fileEncoding = "UTF-8")
cat(green("[...] Terminé !\n"))

# DONNEES - CARTES =====================================================================================

if (importer_carte == 1){
    cat(blue("Importation des cartes [...]\n"))
    if (precision == 60){
        # DONNEES - CARTE NUTS2
        data_map2003_nuts2 = geojsonio::geojson_read("./data/map1_60/NUTS_RG_20M_2003_4326_LEVL_2.geojson", what = "sp")
        data_map2006_nuts2 = geojsonio::geojson_read("./data/map1_60/NUTS_RG_60M_2006_4326_LEVL_2.geojson", what = "sp")
        data_map2010_nuts2 = geojsonio::geojson_read("./data/map1_60/NUTS_RG_60M_2010_4326_LEVL_2.geojson", what = "sp")
        data_map2013_nuts2 = geojsonio::geojson_read("./data/map1_60/NUTS_RG_60M_2013_4326_LEVL_2.geojson", what = "sp")
        data_map2016_nuts2 = geojsonio::geojson_read("./data/map1_60/NUTS_RG_60M_2016_4326_LEVL_2.geojson", what = "sp")
        # CODEBOOK-REFERENCE02 : ajouter le fichier des polygones (RG) en NUTS 2 pour la nouvelle norme
        # DONNEES - CARTE NUTS1
        data_map2003_nuts1 = geojsonio::geojson_read("./data/map1_60/NUTS_RG_20M_2003_4326_LEVL_1.geojson", what = "sp")
        data_map2006_nuts1 = geojsonio::geojson_read("./data/map1_60/NUTS_RG_60M_2006_4326_LEVL_1.geojson", what = "sp")
        data_map2010_nuts1 = geojsonio::geojson_read("./data/map1_60/NUTS_RG_60M_2010_4326_LEVL_1.geojson", what = "sp")
        data_map2013_nuts1 = geojsonio::geojson_read("./data/map1_60/NUTS_RG_60M_2013_4326_LEVL_1.geojson", what = "sp")
        data_map2016_nuts1 = geojsonio::geojson_read("./data/map1_60/NUTS_RG_60M_2016_4326_LEVL_1.geojson", what = "sp")
        # CODEBOOK-REFERENCE02 : ajouter le fichier des polygones (RG) en NUTS 1 pour la nouvelle norme
        # DONNEES - CARTE NUTS0
        data_map2003_nuts0 = geojsonio::geojson_read("./data/map1_60/NUTS_RG_20M_2003_4326_LEVL_0.geojson", what = "sp")
        data_map2006_nuts0 = geojsonio::geojson_read("./data/map1_60/NUTS_RG_60M_2006_4326_LEVL_0.geojson", what = "sp")
        data_map2010_nuts0 = geojsonio::geojson_read("./data/map1_60/NUTS_RG_60M_2010_4326_LEVL_0.geojson", what = "sp")
        data_map2013_nuts0 = geojsonio::geojson_read("./data/map1_60/NUTS_RG_60M_2013_4326_LEVL_0.geojson", what = "sp")
        data_map2016_nuts0 = geojsonio::geojson_read("./data/map1_60/NUTS_RG_60M_2016_4326_LEVL_0.geojson", what = "sp")
        # CODEBOOK-REFERENCE02 : ajouter le fichier des polygones (RG) en NUTS 0 pour la nouvelle norme
        
        
        
        
        
        liste_carte = ls()[grep("data_map", ls())]
        
        recodage_cartes = function(carte){
            # Docstring : cette fonction permet de réencoder correctement les caratères en UTF-8
            if (is.factor(carte@data[["NUTS_NAME"]])) {
                char <- as.character(carte@data[["NUTS_NAME"]])
                Encoding(char) <- 'UTF-8'
                carte@data[["NUTS_NAME"]] <- as.factor(char)
                return(carte)
            }
        }
        
        data_map2003_nuts0 = recodage_cartes(data_map2003_nuts0)
        data_map2003_nuts1 = recodage_cartes(data_map2003_nuts1)
        data_map2003_nuts2 = recodage_cartes(data_map2003_nuts2)
        
        data_map2006_nuts0 = recodage_cartes(data_map2006_nuts0)
        data_map2006_nuts1 = recodage_cartes(data_map2006_nuts1)
        data_map2006_nuts2 = recodage_cartes(data_map2006_nuts2)
        
        data_map2010_nuts0 = recodage_cartes(data_map2010_nuts0)
        data_map2010_nuts1 = recodage_cartes(data_map2010_nuts1)
        data_map2010_nuts2 = recodage_cartes(data_map2010_nuts2)
        
        data_map2013_nuts0 = recodage_cartes(data_map2013_nuts0)
        data_map2013_nuts1 = recodage_cartes(data_map2013_nuts1)
        data_map2013_nuts2 = recodage_cartes(data_map2013_nuts2)
        
        data_map2016_nuts0 = recodage_cartes(data_map2016_nuts0)
        data_map2016_nuts1 = recodage_cartes(data_map2016_nuts1)
        data_map2016_nuts2 = recodage_cartes(data_map2016_nuts2)
        
        # CODEBOOK-REFERENCE02 : appliquer le bloc des 3 lignes pour la nouvelle norme
        
        
        # FRONTIERES (remarque : les frontires sont inutiles pour ce fichier, mais au moins on évite d'importer manuellement depuis shiny)
        data_map2003_nuts0_front = geojsonio::geojson_read("./data/map1_60/NUTS_BN_20M_2003_4326_LEVL_0.geojson", what = "sp")
        data_map2006_nuts0_front = geojsonio::geojson_read("./data/map1_60/NUTS_BN_60M_2006_4326_LEVL_0.geojson", what = "sp")
        data_map2010_nuts0_front = geojsonio::geojson_read("./data/map1_60/NUTS_BN_60M_2010_4326_LEVL_0.geojson", what = "sp")
        data_map2013_nuts0_front = geojsonio::geojson_read("./data/map1_60/NUTS_BN_60M_2013_4326_LEVL_0.geojson", what = "sp")
        data_map2016_nuts0_front = geojsonio::geojson_read("./data/map1_60/NUTS_BN_60M_2016_4326_LEVL_0.geojson", what = "sp")
        # CODEBOOK-REFERENCE02 : ajouter le fichier des frontières (BN) pour la nouvelle norme
    } else if (precision == 1){ # /!\ Fonctionnalité non maintenue car inutile (la précision 60 est largement correcte)
        # # DONNEES - CARTE NUTS2
        # data_map2003_nuts2 = geojsonio::geojson_read("./data/map1_1/NUTS_RG_01M_2003_4326_LEVL_2.geojson", what = "sp")
        # data_map2006_nuts2 = geojsonio::geojson_read("./data/map1_1/NUTS_RG_01M_2006_4326_LEVL_2.geojson", what = "sp")
        # data_map2010_nuts2 = geojsonio::geojson_read("./data/map1_1/NUTS_RG_01M_2010_4326_LEVL_2.geojson", what = "sp")
        # data_map2013_nuts2 = geojsonio::geojson_read("./data/map1_1/NUTS_RG_01M_2013_4326_LEVL_2.geojson", what = "sp")
        # data_map2016_nuts2 = geojsonio::geojson_read("./data/map1_1/NUTS_RG_01M_2016_4326_LEVL_2.geojson", what = "sp")
        # # DONNEES - CARTE NUTS1
        # data_map2003_nuts1 = geojsonio::geojson_read("./data/map1_1/NUTS_RG_01M_2003_4326_LEVL_1.geojson", what = "sp")
        # data_map2006_nuts1 = geojsonio::geojson_read("./data/map1_1/NUTS_RG_01M_2006_4326_LEVL_1.geojson", what = "sp")
        # data_map2010_nuts1 = geojsonio::geojson_read("./data/map1_1/NUTS_RG_01M_2010_4326_LEVL_1.geojson", what = "sp")
        # data_map2013_nuts1 = geojsonio::geojson_read("./data/map1_1/NUTS_RG_01M_2013_4326_LEVL_1.geojson", what = "sp")
        # data_map2016_nuts1 = geojsonio::geojson_read("./data/map1_1/NUTS_RG_01M_2016_4326_LEVL_1.geojson", what = "sp")
        # # DONNEES - CARTE NUTS0
        # data_map2003_nuts0 = geojsonio::geojson_read("./data/map1_1/NUTS_RG_01M_2003_4326_LEVL_0.geojson", what = "sp")
        # data_map2006_nuts0 = geojsonio::geojson_read("./data/map1_1/NUTS_RG_01M_2006_4326_LEVL_0.geojson", what = "sp")
        # data_map2010_nuts0 = geojsonio::geojson_read("./data/map1_1/NUTS_RG_01M_2010_4326_LEVL_0.geojson", what = "sp")
        # data_map2013_nuts0 = geojsonio::geojson_read("./data/map1_1/NUTS_RG_01M_2013_4326_LEVL_0.geojson", what = "sp")
        # data_map2016_nuts0 = geojsonio::geojson_read("./data/map1_1/NUTS_RG_01M_2016_4326_LEVL_0.geojson", what = "sp")
    }
    cat(green("[...] Terminé !\n"))
} else {
    cat(blue("Pas d'importation des données cartographiques comme demandé !\n"))
}



########################################################################################################
# Importations des données enquêtes puis traitement
########################################################################################################

# Création des dataframes vides pour accueillir les résultats finaux (mise à jour par itération (boucles))
df_final_menage = data.frame()
df_final_personne = data.frame()

df_annee_menage = data.frame()
df_annee_personne = data.frame()

# Types des bases à importer
type_fichier = c("D", "H", "P", "R")
# fichier H : household data
# fichier D : household register
# fichier P : personal data
# fichier R : personal register


# 1. Première boucle for : l'idée est de faire un traitement individuel pour chaque année
for (annee_enquete in c(date_premiere_enquete:date_derniere_enquete)) {
    
    # On récupère la liste des pays disponibles (peu importe l'année)
    fichier_pays = list.files(chemin_repertoire_donnees)
    
    
    # Création des dataframes vide pour accueillir les importations (concaténation au fur et à mesure des itérations)
    df_h = data.frame()
    df_d = data.frame()
    df_p = data.frame()
    df_r = data.frame()
    
    for (pays in fichier_pays){
        # Pour chaque pays, on rentre dans l'année en cours
        direction = paste(chemin_repertoire_donnees, pays, "/", annee_enquete,
                          sep = "")
        
        # Puis on importe les 4 types de fichiers
        for (type in type_fichier){
            # direction contient le début du chemin : ./data/enquete/FR/2012
            # on rentre dans le répertoire pour chercher les 4 fichiers csv (UDB_cXXYYT.csv)
                # avec XX le pays
                # YY l'année
                # T le type de fichier (H, D, P, R)
            direction_csv = paste(direction, "/", "UDB_c", pays, annee_enquete-2000, type, ".csv",
                                  sep = "")
            
            # lecture du fichier .csv, qu'on place dans une variable provisoire avant d'en déduire son appartenance pour ensuite
            # le concaténer avec le bon fichier type (df_h, df_d, ...)
            provisoire = read.csv(file = direction_csv,
                                  header = T,
                                  sep = ",",
                                  stringsAsFactors = F,
                                  colClasses = c("character"),
                                  fileEncoding = "UTF-8")
            
            # Concaténation verticale (les colonnes ne trouvant pas d'association renvoient des NA dans les lignes correspondantes)
            if (type == "H"){
                df_h = bind_rows(df_h, provisoire)
            } else if (type == "D") {
                df_d = bind_rows(df_d, provisoire)
            } else if (type == "P") {
                df_p = bind_rows(df_p, provisoire)
            } else if (type == "R") {
                df_r = bind_rows(df_r, provisoire)
            }
        }
        cat(white("***************************************************************************\n"))
    }
    cat(blue("L'importation des données enquête est terminée !\n"))
    
    
    ####################################################################################################
    # Jointures préliminaires 
    ####################################################################################################
    cat(blue("Jointure entre couples de fichiers (registre avec réponses enquête) [...]\n"))
    
    # TRAITEMENTS PRÉLIMINAIRES POUR LE CÔTÉ MENAGES ===================================================
    # Fusion table H avec table D à partir des identifiants
    # HB030 : HouseholdID / Fichier H <---> DB030 : HouseholdID / Fichier D
    # HB020 : Country / Fichier H <---> DB020 : Country / Fichier D
    # HB010 : Year of the survey / Fichier H <---> DB010 : Year of the survey / Fichier D
    df_menage_t = df_h %>% 
        inner_join(df_d, 
                   by = c("HB030" = "DB030", 
                          "HB020" = "DB020", 
                          "HB010" = "DB010"))
    
    cat(green("[...] Terminé !\n"))
    
    
    # FILTRAGE VARIABLES PRESENTES DANS L'ENQUETE EN COURS, EN FONCTION DE CELLES RETENUES (DICTIONNAIRE)
    # FICHIER H ET D
    # on utilise que les variables présentes dans l'enquête importée (boucle)
    # exemple : certaines variables, ajoutées en 2010, n'existe pas encore en 2003.
    # ainsi, on les filtre par l'intermédiaire de ces 2 listes. Il faut que les variables soient à la fois :
    #     - voulues (liste_variable)
    #     - existantes (noms des colonnes du dataframe des données importées).
    # Donc l'intersect de ces deux listes.
    
    
    # Listing des variables binaires pour chaque type de fichier (H+D)
    # liste des variables binaires contenues dans les fichiers H et D
    # l'appartenance se fait grâce à la première lettre du code variable
    liste_variable_binaire_hd = liste_variable_binaire[substr(liste_variable_binaire, 1, 1) %in% c("H", "D")] 
    
    # liste des variables qualitatives contenues dans les fichiers H et D
    liste_variable_quali_hd = liste_variable_quali[substr(liste_variable_quali, 1, 1) %in% c("H", "D")]
    
    liste_variable_binaire_hd_presente = intersect(colnames(df_menage_t), liste_variable_binaire_hd)
    liste_variable_quali_hd_presente = intersect(colnames(df_menage_t), liste_variable_quali_hd)
    
    
    
    # SUPPRESSION DES VALEURS PARASITES PUIS RECODAGE DES MODALITES
    cat(blue("Nettoyage de la base restreinte (valeurs parasites sans signification) [...]\n"))
    df_menage_t = df_menage_t %>% 
        # Remarque : sera appelée variable binaire, une variable issue d'une question amenant à répondre OUI ou NON uniquement.
        #            Ainsi, la variable Sexe sera considérée comme qualitative, bien qu'elle ne prenne que deux modalités.
        # Les variables binaires sont codées dans les enquêtes de la manière suivante
        #     - 2 pour No
        #     - 1 pour Yes
        # ainsi, pour se conformer à la pratique, nous remplaçons les 2 par 0 pour plus de lisibilité
        mutate_at(vars(liste_variable_binaire_hd_presente), 
                  list(~if_else(. == "2", "0", if_else(. == "1", "1", as.character(NA))))) %>% 
        # Pour certaines variables, nous observons des valeurs parasites, on les transforme en NA
        mutate_at(vars(liste_variable_quali_hd_presente), 
                  list(~if_else(. %in% c("", "0", "0-1", "0 - 1", "NAs"), as.character(NA), .))) # (1)
    # (1) : Remarque : on distingue bien variable binaire et variable qualitative (d'où l'existence de deux listes distinctes).
    #                  Par conséquent, les 0 apparus dans la transformation juste en haut ne sont pas concernés ici.
    #                  Le 0 n'a pas de sens pour les variables qualitatives (les modalités commençent à partir de 1).
    cat(green("[...] Terminé !\n"))

    
    # bac à sable
    for (variable in liste_variable_quali_hd_presente){
        if (sum(is.na(df_menage_t[, variable])) == nrow(df_menage_t)){
            liste_variable_quali_hd_presente = liste_variable_quali_hd_presente[liste_variable_quali_hd_presente != variable]
        }
    }
    
    for (variable in liste_variable_binaire_hd_presente){
        if (sum(is.na(df_menage_t[, variable])) == nrow(df_menage_t)){
            liste_variable_binaire_hd_presente = liste_variable_binaire_hd_presente[liste_variable_binaire_hd_presente != variable]
        }
    }
    # fin bac à sable
    
    cat(blue("Tableau disjonctif complet [...]\n"))
    # CREATION ET RAJOUT DU TABLEAU DISJONCTIF DANS LA BASE INITIALE (en [2]) 
    # EN SUPPRIMANT LES VARIABLES QUALITATIVES CORRESPONDANTES AVANT DISJONCTION (en [1])
    df_menage_t = df_menage_t %>% 
        select(-liste_variable_quali_hd_presente) %>% # [1]
        cbind(df_menage_t %>% # [2]
                  select(liste_variable_quali_hd_presente) %>% 
                  acm.disjonctif())
    cat(green("[...] Terminé !\n"))
    
    
    # TRAITEMENTS PRÉLIMINAIRES POUR LE CÔTÉ INDIVIDUS =================================================
    # Fusion table R avec table P à partir des identifiants
    # RB020 : Country / Fichier R  <---> PB020 : Country / Fichier P
    # RB020 : Personal ID / Fichier R  <---> PB030 : Personal ID / Fichier P
    # RB010 : Year of the survey / Fichier R  <---> PB010 : Year of the survey / Fichier P
    cat(blue("Jointure entre couples de fichiers (registre avec réponses enquête) [...]\n"))
    df_personne_t = df_r %>% 
        inner_join(df_p, 
                   by = c("RB020" = "PB020", 
                          "RB030" = "PB030", 
                          "RB010" = "PB010"))
    cat(green("[...] Terminé !\n"))
    
    # La logique du traitement est exactement la même que pour les ménages .............................
    # FILTRAGE VARIABLES PRESENTES DANS L'ENQUETE EN COURS EN FONCTION DE CELLES RETENUES (DICTIONNAIRE)
    # FICHIER R ET P
    
    # liste des variables binaires contenues dans les fichiers R et P
    liste_variable_binaire_rp = liste_variable_binaire[substr(liste_variable_binaire, 1, 1) %in% c("R", "P")] 
    # liste des variables qualitatives contenues dans les fichiers R et P
    liste_variable_quali_rp = liste_variable_quali[substr(liste_variable_quali, 1, 1) %in% c("R", "P")]
    
    liste_variable_binaire_rp_presente = intersect(colnames(df_personne_t), liste_variable_binaire_rp)
    liste_variable_quali_rp_presente = intersect(colnames(df_personne_t), liste_variable_quali_rp)
    
    cat(blue("Nettoyage de la base restrainte (valeurs parasites sans signification) [...]\n"))
    # SUPPRESSION DES VALEURS PARASITES PUIS RECODAGE DES MODALITES
    df_personne_t = df_personne_t %>% 
        # exception avec la variable qualitative PE040 qui contient des 0 (et ce 0 a un sens pour cette variable).
        # PE040 :  Highest ISCED level attained
        # modalité 0 : pre-primary education (information importante)
        # afin de concerver cette modalité, on a choisi de "sauvegarder" l'information en faisant +1 avant modification
        # puis -1 après modification.
        mutate(PE040 = as.character(as.numeric(PE040) + 1)) %>% 
        mutate_at(vars(liste_variable_binaire_rp_presente), list(~if_else(. == "2", "0", if_else(. == "1", "1", as.character(NA))))) %>% 
        mutate_at(vars(liste_variable_quali_rp_presente), list(~if_else(. %in% c("", "0", "0-1", "0 - 1", "NAs"), as.character(NA), .))) %>% 
        # on revient aux valeurs initiales de PE040
        mutate(PE040 = as.character(as.numeric(PE040) - 1))
    cat(green("[...] Terminé !\n"))
    
    
    # bac à sable
    for (variable in liste_variable_quali_rp_presente){
        if (sum(is.na(df_personne_t[, variable])) == nrow(df_personne_t)){
            liste_variable_quali_rp_presente = liste_variable_quali_rp_presente[liste_variable_quali_rp_presente != variable]
        }
    }
    
    for (variable in liste_variable_binaire_rp_presente){
        if (sum(is.na(df_personne_t[, variable])) == nrow(df_personne_t)){
            liste_variable_binaire_rp_presente = liste_variable_binaire_rp_presente[liste_variable_binaire_rp_presente != variable]
        }
    }
    # fin bac à sable
    
    
    
    cat(blue("Tableau disjonctif complet [...]\n"))
    # CREATION ET RAJOUT DU TABLEAU DISJONCTIF DANS LA BASE INITIALE EN SUPPRIMANT LES VARIABLES QUALITATIVES CORRESPONDANTES AVANT DISJONCTION
    df_personne_t = df_personne_t %>% 
        select(-liste_variable_quali_rp_presente) %>% 
        cbind(df_personne_t %>% 
                  select(liste_variable_quali_rp_presente) %>% 
                  acm.disjonctif())
    cat(green("[...] Terminé !\n"))
    
    
    # Le traitement préliminaire est terminé.
    # On parcourt tous les nuts et en fonction de l'année en cours (on est toujours dans la boucle sur les années) 
    # pour choisir la carte adéquate.
    # choix nécessaire pour la construction de la base de données alimentant la cartographie et les statistiques descriptives.
    for (nuts in c(0:2)) {
        cat(green("Traitement pour l'année", annee_enquete, "pour le NUTS", nuts, "\n"))
        # identification de la carte de référence en fonction de l'enquete :
        # pourquoi ? de manière à respecter la norme en vigueur pour l'enquête étudiée
        if (annee_enquete < 2006){
            annee_carte = 2003
        } else if (annee_enquete >= 2006 & annee_enquete < 2010){
            annee_carte = 2006
        } else if (annee_enquete >= 2010 & annee_enquete < 2013){
            annee_carte = 2010
        } else if (annee_enquete >= 2013 & annee_enquete < 2016){
            annee_carte = 2013
        } else { # CODEBOOK-REFERENCE01 : transformer le else en else if pour les nouvelles normes
            annee_carte = 2016
        }
        
        
        # copies des bases importées pour être traitées ensuite
        # pourquoi ? pour éviter de réimporter pour chaque nuts
        # les calculs modifient la base, donc on sauvegarde la base.
        # En effet, des modifications en 2009 ne seront plus correctes en 2011 par exemple.
        df_menage_t_copie = df_menage_t %>% # SAUVEGARDE
            rename(REGION = DB040) # pour plus de lisibilité
        
        df_personne_t_copie = df_personne_t %>% # SAUVEGARDE 
            rename(REGION = RB020) # (1)
        # (1) : Il n'existe pas de variable sur la région pour la base des individus, donc on ne peut
        #       que utiliser la variable RB020 (COUNTRY) pour indiquer la région de l'individu enquêté.
        
        ###################################################################################################
        # GESTION DES PROBLÈMES DE CODAGE DES REGIONS (DIFFERENCES ENQUETE<>CARTE)
        ###################################################################################################
        
        # Gestion des cas sans region (DE, SI, NL) : chaîne vide dans la variable REGION ==================
        if (nuts == 0){
            cat(blue("Traitement des régions sans nom pour le cas de NUTS0 [...]\n"))
            # Tout ce qu'on peut faire c'est repêcher l'information pour les NUTS 0.
            # Lorsqu'on est en NUTS 0, REGION doit avoir la valeur du pays (HB020).
            df_menage_t_copie = df_menage_t_copie %>% 
                mutate(REGION = if_else(REGION == "", HB020, REGION))
            cat(green("[...] Terminé !\n"))
        }
        
        # Recodage des regions pour etre conforme a la norme en vigueur ===================================
        # Cas spécial où il ne s'agit pas simplement d'un problème de code, mais plutôt un nombre
        # différent entre l'enquête et les données de la carte. Ce problème ne concerne que (actuellement)
        # la Croatie et le Royaume-Uni (deux régions dans les enquêtes alors que la carte n'en a qu'une). 
        if (nuts == 2){
            if (annee_carte >= 2010 & annee_carte < 2016){ #NUTS 2 CROATIE
                # CODEBOOK-REFERENCE01 : vérifier si ce correctif doit s'appliquer avec la norme de 2016, et les suivantes
                cat(blue("Recodage des régions pour le cas des NUTS2 après 2010 et avant 2016 de la Croatie [...]\n"))
                df_menage_t_copie$REGION = recode(df_menage_t_copie$REGION, !!!dico_enquete_croatie_apres_2010)
                cat(green("[...] Terminé !\n"))
            }
            if (annee_carte >= 2013 & annee_carte < 2016){ #NUTS 2 ROYAUME UNI
                # CODEBOOK-REFERENCE01 : vérifier si ce correctif doit s'appliquer avec la norme de 2016, et les suivantes
                cat(blue("Recodage des régions pour le cas NUTS2 après 2013 du Royaume-Uni [...]\n"))
                df_menage_t_copie$REGION = recode(df_menage_t_copie$REGION, !!!dico_enquete_uk_apres_2013)
                cat(green("[...] Terminé !\n"))
            }
        }
        
        # Recodage des regions pour etre conforme a la norme en vigueur ===================================
        # Cas où il s'agit de recoder une région pour corriger le problème.
        if (annee_carte < 2010){
            cat(blue("Recodage des régions pour avant 2010 [...]\n"))
            df_menage_t_copie = df_menage_t_copie %>%
                mutate(REGION = recode(REGION, !!!dico_enquete_avant_2010))
            
            df_personne_t_copie = df_personne_t_copie %>% 
                mutate(REGION = recode(REGION, !!!dico_enquete_avant_2010))
            
            cat(green("[...] Terminé !\n"))
        } else if (annee_carte >= 2010 & annee_carte < 2013){
            cat(blue("Recodage des régions entre 2010 et 2013 [...]\n"))
            df_menage_t_copie = df_menage_t_copie %>%
                mutate(REGION = recode(REGION, !!!dico_enquete_entre_2010_2013))
            df_personne_t_copie = df_personne_t_copie %>%
                mutate(REGION = recode(REGION, !!!dico_enquete_entre_2010_2013))
            cat(green("[...] Terminé !\n"))
        } else { # CODEBOOK-REFERENCE01 : transformer le else en else if pour les nouvelles normes
            # peut-être du nouveau pour 2016
        }
        
        
        ###################################################################################################
        # CALCUL DES MOYENNES/EFFECTIFS
        ###################################################################################################
        
        # Selection des variables a representer ====================================================
        # on restreint la liste à ce qu'on veut ET ce qu'on a à pour une enquete a l'annee T
        # pour éviter de sélectionner une variable qui n'existe pas à ce moment (erreur R)
        # sélection des variables disponibles à l'année en cours (itération en cours)
        liste_var_selection_menage = intersect(colnames(df_menage_t_copie), dico_variable)
        liste_var_selection_personne = intersect(colnames(df_personne_t_copie), dico_variable)
        
        # MENAGES (H ET D) : sélection des variables
        # la première liste contient les variables quanti/binaires
        # la seconde contient les variables quali,
        # caractérisées par la présence d'un "." dans le nom car la création d'un tableau disjonctif
        # crée des variables de la forme "NOMVAR.MODALITE"
        df_menage_t_copie = df_menage_t_copie %>% 
            select(REGION, liste_var_selection_menage, contains("."))
        
        # INDIVIDUS (P ET R) : sélection des variables (idem)
        df_personne_t_copie = df_personne_t_copie %>% 
            select(REGION, liste_var_selection_personne, contains("."))
        
        # Calcul des moyennes ==========================================================================
        cat(blue("Calcul des moyennes par région [...]\n"))
        moy_region_menage = df_menage_t_copie %>% 
            filter(REGION != "") %>% # on enlève les individus qui n'ont pas de région renseignée
            mutate_at(vars(-REGION), as.numeric) %>% # conversion de toutes les variables en numérique sauf REGION
            mutate(REGION = substr(REGION, 1, nuts + 2)) %>% # construction de la variable REGION selon le NUTS
            group_by(REGION) %>% # regroupement par REGION
            group_by(NB_OBS = n(), add = T) %>% # Astuce pour obtenir le nombre d'observations par groupe (par REGION) sans summarize
            summarise_all(list(moy = ~mean(., na.rm = T), na = ~sum(is.na(.)))) %>% # Calcul de la moyenne et du nombre de NA
            ungroup()
        
        # de même côté individus
        moy_region_personne = df_personne_t_copie %>%
            filter(REGION != "") %>% 
            mutate_at(vars(-REGION), as.numeric) %>% 
            group_by(REGION) %>% 
            group_by(NB_OBS = n(), add = T) %>% 
            summarise_all(list(moy = ~mean(., na.rm = T), na = ~sum(is.na(.)))) %>%
            ungroup()
        cat(green("[...] Terminé !\n"))
        
        
        ###################################################################################################
        # Récupération des régions de la carte ============================================================
        # Création du socle ordonné pour recevoir les données =============================================
        ###################################################################################################
        
        cat(blue("Jointure entre la liste des régions de la carte et notre liste de valeurs [...]\n"))
        # Identification de la carte en cours
        # on retrouve le nom de la carte utilisée grâce à sa norme d'écriture
        choix_carte = paste0("data_map", annee_carte, "_nuts", nuts, sep = "")
        # dans le but de retrouver l'ordre de la liste des régions (polygones de la carte)
        # afin d'otenir un dataframe avec le même ordre de région (que celui de la carte)
        liste_ids = data.frame("REGION" = get(choix_carte)$NUTS_ID,
                               "NOM_REGION" = get(choix_carte)$NUTS_NAME)
        
        # conversion en character pour fusionner
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
        
        cat(blue("Gestion du cas particulier de Londres après 2010 [...]\n"))
        # CODEBOOK-REFERENCE01 : vérifier si ce correctif doit s'appliquer avec la norme de 2016, et les suivantes
        if (nuts == 2 & annee_carte >= 2010 & annee_carte < 2016){ # le cas de Londres n'arrive qu'après 2010
            liste_ids_londres = liste_ids %>% 
                data.frame %>% 
                rownames_to_column() %>% # (1)
                filter(substr(REGION, 1, 3) == "UKI") # (2)
            # (1) : On note de côté les numéros de lignes pour les polygones de Londres
            #       L'idée est de calculer les moyennes pour Londres puis de les placer dans la
            #       base des moyennes centrale, au bon emplacement, grâce à l'ordre des lignes.
            # (2) : Londres est idéntifié par un début de code NUTS2 de type "UKI..."
            
            nb_region_londres = liste_ids_londres %>% nrow # nombre de polygones pour Londres
            
            # calcul des moyennes et effectifs pour Londres
            moyenne_londres = df_menage_t_copie %>%
                filter(REGION == "UKIX") %>% # (1)
                mutate_at(vars(-REGION), as.numeric) %>% 
                group_by(REGION) %>%
                group_by(NB_OBS = n(), add = T) %>% 
                summarise_all(list(moy = ~mean(., na.rm = T), na = ~sum(is.na(.)))) %>%
                ungroup() 
            # (1) : grâce au dictionnaire d'encodage, on n'a pas deux valeurs pour Londres mais qu'une seule
            #       par conséquent, il s'agit d'injecter cette unique ligne aux 5 régions constituant Londres
            
            # on duplique la liste des moyennes autant de fois qu'il y a de régions (polygones) pour Londres
            if (nrow(moyenne_londres) != 0){ 
                moyenne_londres = moyenne_londres %>% 
                    slice(rep(1, each = nb_region_londres)) %>%
                    mutate(REGION = liste_ids_londres$REGION) %>% 
                    left_join(liste_ids_londres, by = c("REGION"))
            }
            
            # puis on peut alors les placer dans la base centrale.
            moyenne_region_menage = moyenne_region_menage %>%
                rownames_to_column() %>%
                anti_join(moyenne_londres, by = c("REGION")) %>% # (1)
                bind_rows(moyenne_londres) %>% # (3)
                mutate(rowname = as.integer(rowname)) %>%
                arrange(rowname) %>% # (2)
                select(-rowname)
            # (1) : Un anti-join pour retirer les anciennes lignes correspondant à Londres (ne contenant que des NA
            #       puisque le matching enquete-carte n'a pas abouti pour Londres.
            # (2) : On place alors les nouvelles valeurs dans la base (placement incorrect pour l'instant).
            # (3) : On utilise le numéro des lignes pour positionner Londres (respectivement à l'ordre sur les cartes)
        }
        cat(green("[...] Terminé !\n"))
        
        
        ###################################################################################################
        # Traitements finaux
        ###################################################################################################
        
        cat(blue("Création des variables NUTS, ANNEE, PAYS [...]\n"))
        # On construit 3 nouvelles variables :
        #    - NUTS : qui contient l'information sur le niveau NUTS de la ligne d'observation. On rappelle
        #             qu'on est toujours dans une boucle qui itère sur les NUTS (0, 1, 2).
        #    - ANNEE : qui contient l'année pour la ligne d'observation. On rappelle également qu'on est
        #              toujours dans une boucle qui itère sur les années.
        #    - PAYS : qui contient le code pays (NUTS 0), déduit du code REGION (deux premiers caractères).
        moyenne_region_menage = moyenne_region_menage %>% 
            mutate(NUTS = paste0("NUTS ", nuts),
                   ANNEE = annee_enquete,
                   PAYS = substr(REGION, 1, 2))
        
        moyenne_region_personne = moyenne_region_personne %>% 
            mutate(NUTS = paste0("NUTS ", nuts),
                   ANNEE = annee_enquete,
                   PAYS = substr(REGION, 1, 2))
        cat(green("[...] Terminé !\n"))
        
        # mise a jour de la base finale par simple concaténation verticale.
        df_annee_menage <- df_annee_menage %>% 
            bind_rows(moyenne_region_menage)
        cat(green("La base centrale des ménages (annee) a été correctement mise à jour !\n"))
        
        df_annee_personne <- df_annee_personne %>% 
            bind_rows(moyenne_region_personne)
        cat(green("La base centrale des individus (annee) a été correctement mise à jour !\n"))
    } # puis on passe au prochain NUTS, sinon [...]
} # [...] on passe à la prochaine année !


###################################################################################################
# Création des variables comptant le nombre de NA par variable pour chaque ligne (region spatio-temporelle)
###################################################################################################

# réordonner les colonnes pour avoir les variables d'identification au début et calcul des pourcentages de NA
cat(blue("Création des variables comptabilisant les NA [...]\n"))
df_final2_menage = df_annee_menage %>% 
    select(-NUTS, -ANNEE, -PAYS, -REGION, -NOM_REGION) %>% # suppression des variables type character
    round(4) %>% # arrondi des moyennes à 4 décimales
    cbind(df_annee_menage %>% 
              select(NUTS, ANNEE, PAYS, REGION, NOM_REGION)) %>% # réinsertion des variables retirées juste avant
    select(PAYS, REGION, NOM_REGION, NUTS, ANNEE, everything()) %>% # reordonnage des variables (identification avant)
    mutate_at(vars(contains("_na")), funs(round(./NB_OBS, 4))) # calcul de la proportion de NA pour chaque variable

# idem pour la base des individus
df_final2_personne = df_annee_personne %>% 
    select(-NUTS, -ANNEE, -PAYS, -REGION, -NOM_REGION) %>%
    round(4) %>%
    cbind(df_annee_personne %>% 
              select(NUTS, ANNEE, PAYS, REGION, NOM_REGION)) %>% 
    select(PAYS, REGION, NOM_REGION, NUTS, ANNEE, everything()) %>%
    mutate_at(vars(contains("_na")), funs(round(./NB_OBS, 4)))
cat(green("[...] Terminé !\n"))


###################################################################################################
# Partie sur le traitement par périodes
###################################################################################################

cat(green("Début du traitement par période [...]\n"))
# création des bases finales
df_periode_menage = data.frame()
df_periode_personne = data.frame()

# calcul des moyennes ponderees pour chaque periode
for (i in c(1:length(liste_periode))){
    cat(blue("Période", paste(liste_periode[[i]][1], "-", liste_periode[[i]][length(liste_periode[[i]])], sep = "") , "[...]\n"))
    # on commence par les ménages ...
    df_moy_periode_menage = df_final2_menage %>%
        filter(ANNEE %in% liste_periode[[i]]) %>% 
        mutate_at(vars(contains("_moy")), funs(. * NB_OBS)) %>% # étape intermédiaire : moyenne * nb_obs pour une année donnée
        group_by(REGION) %>%
        # moyennes pondérées, qui seront identifiables par la suffixe "_moy"
        summarise_at(vars(contains("_moy")), funs(sum(.)/sum(NB_OBS))) %>% # (moy*nb_obs)/(somme sur annees des nb_obs)
        # création d'une nouvelle variable : PERIODE qui indique la période dans laquelle la région se trouve
        mutate(PERIODE = paste(liste_periode[[i]][1], "-", liste_periode[[i]][length(liste_periode[[i]])], sep = "")) %>% 
        select(REGION, PERIODE, contains("_moy")) # reordonnage des colonnes (en supprimant les colonnes intermédiaires) ...
    
    # il est intéressant d'avoir une information sur les années considérées dans la moyenne pondérée calculée en haut.
    # en effet, il se peut qu'une région dans la période 2003-2005 ait une moyenne calculée uniquement sur 2005.
    df_presente_periode_menage = df_final2_menage %>% 
        filter(ANNEE %in% liste_periode[[i]]) %>% 
        filter(!is.na(NB_OBS)) %>% # on ne considère que les années présentes (enquête ayant eu lieu pour la région)
        group_by(REGION) %>%
        mutate(ANNEES_PRESENTES = paste(unlist(unique(ANNEE)), collapse = ", ")) %>% # (1)
        select(PAYS, REGION, NUTS, ANNEES_PRESENTES) %>% # on ne prend que ces 4 variables parce qu'on fera une jointure ensuite
        distinct() %>% # les lignes sont répétées au sein d'une même période, on n'en a besoin qu'une par période et par région
        select(REGION, ANNEES_PRESENTES) %>% # REGION servira de clé de jointure pour rajouter la nouvelle colonne dans la table centrale
        ungroup
    # (1) : à l'intérieur d'un group_by, on liste l'ensemble des années qui restent après les deux filtres passés.
    
    
    # On a besoin d'une année de référence par période pour obtenir la liste ordonnée des régions (selon la carte en vigueur)
    # On détecte une année qui est présente dans la période :
    annee_presente = df_presente_periode_menage %>%
        select(ANNEES_PRESENTES) %>% 
        slice(1) %>%
        unlist() %>% 
        substr(1, 4) %>% 
        as.numeric
    
    # ordonnage des lignes (selon la liste carte) et des colonnes ...
    # On filtre sur l'année de référence pour retrouver l'ordre des lignes correspondant à la carte
    df_ordre_periode_menage = df_final2_menage %>% 
        filter(ANNEE == annee_presente) %>% # On prend l'année de référence pour obtenir la liste ordonnée
        select(PAYS, REGION, NOM_REGION, NUTS, NB_OBS, contains("_na"))
    
    # jointures pour avoir toutes les colonnes souhaites : identifiants|moyennes|annees_presentes
    df_tot_menage = df_ordre_periode_menage %>% 
        left_join(df_moy_periode_menage, by = c("REGION")) %>% 
        left_join(df_presente_periode_menage, by = c("REGION"))
    
    # mise à jour de la table retraçant l'ensemble des périodes (table finale pour la partie période)
    df_periode_menage = df_periode_menage %>% 
        bind_rows(df_tot_menage)
    cat(green("La base centrale des ménages (période) a été correctement mise à jour !\n"))
    
    
    
    # et on fait exactement pareil pour la base individus ...
    
    df_moy_periode_personne = df_final2_personne %>%
        filter(ANNEE %in% liste_periode[[i]]) %>% 
        mutate_at(vars(contains("_moy")), funs(. * NB_OBS)) %>% 
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
        filter(ANNEE == annee_presente) %>% # On prend l'année de référence pour obtenir la liste ordonnée
        select(PAYS, REGION, NOM_REGION, NUTS, NB_OBS, contains("_na"))
    
    df_tot_personne = df_ordre_periode_personne %>% 
        left_join(df_moy_periode_personne, by = c("REGION")) %>% 
        left_join(df_presente_periode_personne, by = c("REGION"))
    
    df_periode_personne = df_periode_personne %>% 
        bind_rows(df_tot_personne)
    cat(green("La base centrale des individus (période) a été correctement mise à jour !\n"))
}



###################################################################################################
# Préparations finales avant exportation de la base finale pour shiny
###################################################################################################

cat(green("Rassemblement des 4 bouts de base [...]\n"))
# on concatène verticalement les données par année avec les données par période
df_final3_menage = df_final2_menage %>% 
    bind_rows(df_periode_menage)

df_final3_personne = df_final2_personne %>% 
    bind_rows(df_periode_personne)

# on joint horizontalement les données ménages avec les données individus
df_final3_tot = df_final3_menage %>% 
    rownames_to_column() %>% # (1)
    inner_join(df_final3_personne %>% 
                   rownames_to_column() %>% # (1)
                   select(-PAYS, -REGION, -NOM_REGION, -ANNEE, -NUTS, -PERIODE, -ANNEES_PRESENTES) %>% # (2)
                   rename(NB_PERSONNE = NB_OBS), # on distinguera nombre de ménages et nombre d'individus
               by = c("rowname")) %>% # (1)
    select(-rowname) %>% 
    select(PAYS, REGION, NOM_REGION, NUTS, ANNEE, PERIODE, ANNEES_PRESENTES, NB_MENAGE = NB_OBS, NB_PERSONNE, everything())
# (1) ; puisque la base des ménages et la base des individus sont construites de la même façon, la
#       jointure est en fait une concaténation horizontale (jointure sur le numéro de ligne)
# (2) : on retire les colonnes d'identification pour éviter la redondance après jointure.
cat(green("[...] Terminé !\n"))


# on retire les variables qui ne présentent que des NA comme moyenne # BAC À SABLE

disparu = df_final3_tot %>%
    select_if(function(col) sum(is.na(col)) == nrow(df_final3_tot))

# BAC À SABLE : nouvelle condition : s'il y a une colonne qui présente que des NA, on l'a supprime
#                                    sinon on ne fait rien
if (ncol(disparu) != 0){
    disparu = paste(str_remove_all(names(disparu), "_moy"), "_na", sep = "")
    
    df_final3_tot = df_final3_tot %>%
        select_if(function(col) sum(is.na(col)) != nrow(df_final3_tot)) %>% 
        select(-!!disparu)
}


###################################################################################################
# Exportation table finale
###################################################################################################

# Au final, la table finale est construite à partir de 4 tables centrales :

#           |-------------------------------------------------------------------|
#           |                        |           MOYENNES, COMPTEURS            |
#           |------------------------|--------------------|---------------------|
#           |                        |     VALEURS DES    |    VALEURS DES      |
#           |      IDENTIFIANTS      |       MENAGES      |     INDIVIDUS       |
#           |                        |     SELON ANNEE    |    SELON ANNEE      |
#           |------------------------|--------------------|---------------------|
#           |                        |     VALEURS DES    |    VALEURS DES      |
#           |      IDENTIFIANTS      |       MENAGES      |     INDIVIDUS       |
#           |                        |    SELON PERIODE   |   SELON PERIODE     |
#           |-------------------------------------------------------------------|


# Exportation de la table finale qui servira de base de départ sur shiny
cat(blue("Exportation de la table finale [...]\n"))
write.csv(df_final3_tot, 
          file = "./data/finaux/donnees.csv",
          row.names = F,
          fileEncoding = "UTF-8")
cat(green("[...] Terminé !\n"))

# Exporations complémentaires (utilitaires) ============================================================

cat(blue("Exportations complémentaires [...]\n"))
# Exportation de la liste finale des variables à représenter
liste_variable_moy_final = df_final3_tot %>% 
    colnames %>% 
    data.frame(var = .) %>% 
    filter(grepl("_moy", var))
write.csv(liste_variable_moy_final,
          file = "./data/finaux/liste_variable_moy_final.csv",
          row.names = F,
          fileEncoding = "UTF-8")

# La partie statistiques de l'application nécessite des corrections supplémentaires sur les régions.
# Jusqu'à présent, on a considéré les régions indépendamment de la dimension temporelle, c'est-à-dire
# que la région FR11 en 2004 et la région FR11 en 2011 sont deux entités sans lien lors de la
# représentation sur une carte. Or, pour des statistiques descriptives considérant la dimension temporelle
# comme les séries chronologiques, il est important de retracer tout l'historique d'une région. Par conséquent,
# si une région a eu deux codes officiels différents, mais à différentes années, il faut également retracer
# les modifications de codage pour pouvoir retracer l'historique des valeurs à représenter.
# C'est ce que le fichier mise_a_jour_stats.csv fait. Il associe les anciens codes au dernier code connu.

mise_a_jour_stats = read.csv(file = "./data/mise_a_jour_stats.csv",
                             header = T,
                             sep = ",",
                             stringsAsFactors = F,
                             fileEncoding = "UTF-8")

# mise en forme de "dictionnaire" pour le recodage ensuite.
mise_a_jour_stats = setNames(mise_a_jour_stats$nouveau,
                             mise_a_jour_stats$ancien)


# recodage
df_final3_tot_stat = df_final3_tot %>% 
    filter(!is.na(ANNEE)) %>% 
    mutate(REGION = recode(REGION, !!!mise_a_jour_stats),
           PAYS = substr(REGION, 1, 2)) %>% 
    left_join(dico_nom_pays, # On rajoute une variable qui donne le nom du pays (au lieu d'un simple code)
              by = c("PAYS" = "code")) %>% 
    mutate(label = if_else(PAYS == "GR", "Greece", label)) %>% # cas particulier de la grêce qui peut être EL ou GR
    rename(NOM_PAYS = label) %>% 
    select(PAYS, NOM_PAYS, REGION, NOM_REGION, NUTS, ANNEE, PERIODE, ANNEES_PRESENTES, NB_MENAGE, NB_PERSONNE, everything())


# les régions sont harmonisées en fonction du temps maintenant, la base est opérationnelle pour shiny.
write.csv(df_final3_tot_stat,
          file = "./data/finaux/donnees_stats.csv",
          row.names = F,
          fileEncoding = "UTF-8")


# On récupère la liste des régions afin d'alimenter les listes déroulantes de l'UI de l'application.
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

# exportation des 3 listes créées
write.csv(liste_nuts0_stat,
          file = "./data/finaux/liste_nuts0_stat.csv",
          row.names = F,
          fileEncoding = "UTF-8")

write.csv(liste_nuts1_stat,
          file = "./data/finaux/liste_nuts1_stat.csv",
          row.names = F,
          fileEncoding = "UTF-8")

write.csv(liste_nuts2_stat,
          file = "./data/finaux/liste_nuts2_stat.csv",
          row.names = F,
          fileEncoding = "UTF-8")


cat(green("[...] Terminé !\n"))



# suppression des grands dataframes (taille supérieure à 20 Mo)
rm(df_personne_t,
   df_personne_t_copie,
   df_p,
   df_h,
   df_menage_t,
   df_menage_t_copie,
   df_r,
   df_d)

cat(green("Fin du programme !\n"))

# fin du programme
date_fin_code_indep = Sys.time()
diff = date_fin_code_indep - date_debut_code_indep
print(diff)