# Packages
library(stringr)
library(dplyr)

# Pour résoudre des problèmes d'encodage ...
if (Sys.info()[1] == "Windows"){
    Sys.setlocale("LC_ALL","English")
}

# Importations dictionnaires pour recodage

dico_enquete_avant_2010 = read.csv(file = "./data/dictionnaire_codage_avant_2010.csv",
                                   sep = ",",
                                   header = T,
                                   stringsAsFactors = F,
                                   fileEncoding = "UTF-8")

dico_enquete_avant_2010 = setNames(dico_enquete_avant_2010$code_carte, 
                                   dico_enquete_avant_2010$code_enquete)


dico_enquete_entre_2010_2013 = read.csv(file = "./data/dictionnaire_codage_entre_2010_2013.csv",
                                        sep = ",",
                                        header = T,
                                        stringsAsFactors = F,
                                        fileEncoding = "UTF-8")

dico_enquete_entre_2010_2013 = setNames(dico_enquete_entre_2010_2013$code_carte, 
                                        dico_enquete_entre_2010_2013$code_enquete)

# CODEBOOK-REFERENCE03 : importer les nouveaux dictionnaires et faire un setNames comme montré plus haut ici

donnees_finale = read.csv(file =  "./data/finaux/donnees.csv",
                          sep = ",",
                          header = T,
                          stringsAsFactors = F,
                          fileEncoding = "UTF-8")

centre_poly = read.csv(file =  "./data/finaux/centre_poly.csv",
                          sep = ",",
                          header = T,
                          stringsAsFactors = F,
                          fileEncoding = "UTF-8")

dico_nom_pays = read.csv(file =  "./data/dico_pays_stats.csv",
                          sep = ",",
                          header = T,
                          stringsAsFactors = F,
                          fileEncoding = "UTF-8")

# =================================================================================================================

# VARIABLES RETENUES DANS LES BASES DE DONNEES EUROSTAT ===========================================================

# POPULATION AU 1ER JANVIER PAR REGION (demo_r_d2jan)
# https://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing?file=data/demo_r_d2jan.tsv.gz
# 	- DONNEES ANNUELLES (1990-2018)
# 	- REGIONALES (NUTS 2 1 0 -1)
# 	- UNIT : NOMBRE (NR)
# 
# DENSITE DE LA POPULATION PAR REGION (demo_r_d3dens)
# https://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing?file=data/demo_r_d3dens.tsv.gz
# 	- DONNEES ANNUELLES (1990-2017)
# 	- REGIONALES (NUTS 2 1 0 -1)
# 	- UNIT : HABITANTS PAR KM2 (HAB_KM2)
# 
# PIB AUX PRIX COURANTS DU MARCHÉ PAR RÉGION (nama_10r_2gdp)
# https://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing?file=data/nama_10r_2gdp.tsv.gz
# 	- DONNEES ANNUELLES (2000-2017)
# 	- REGIONALES (NUTS 2 1 0 -1)
# 	- UNIT : - MILLIONS D'EUROS (MIO_EUR)
# 		 - EUROS PAR HABITANTS (EUR_HAB)
# 		 - MILLIONS D'UNITÉS DE MONNAIE NATIONALE (MIO_NAC)
# 		 - MILLIONS DE STANDARDS DE POUVOIR D'ACHAT SPA (MIO_PPS)
# 		 - STANDARD DE POUVOIR D'ACHAT (SPA) PAR HABITANT (PPS_HAB)
# 
# JEUNES AYANT QUITTÉ PRÉMATURÉMENT L'ÉDUCATION ET LA FORMATION PAR REGION (edat_lfse_16)
# https://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing?file=data/edat_lfse_16.tsv.gz
# 	- DONNEES ANNUELLES (2000-2018)
# 	- REGIONALES (NUTS 2 1 0 -1)
# 	- UNIT : POURCENTAGE (PC)
# 
# PERSONNES EN RISQUE DE PAUVRETÉ OU D'EXCLUSION SOCIALE PAR RAGION (ilc_peps11)
# https://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing?file=data/ilc_peps11.tsv.gz
# 	- DONNEES ANNUELLES (2003-2018)
# 	- REGIONALES (NUTS 2 1 0)
# 	- UNIT : POURCENTAGE (PC)
# 
# TAUX DE RISQUE DE PAUVRETÉ PAR RÉGION (ilc_li41)
# https://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing?file=data/ilc_li41.tsv.gz
# 	- DONNEES ANNUELLES (2003-2018)
# 	- REGIONALES (NUTS 2 1 0)
# 	- UNIT : POURCENTAGE (PC)
# 
# TAUX DE CHOMAGE PAR RÉGION (lfst_r_lfu3rt)
# https://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing?file=data/lfst_r_lfu3rt.tsv.gz
# 	- DONNEES ANNUELLES (1990-2018)
# 	- REGIONALES (NUTS 2 1 0 -1)
# 	- UNIT : POURCENTAGE (PC)
# 
# DEGRÉS-JOURS DE CHAUFFAGE ET DE REFROIDISSEMENT PAR RÉGION (nrg_chddr2_a)
# https://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing?file=data/nrg_chddr2_a.tsv.gz
# 	- DONNEES ANNUELLES (1975-2018)
# 	- REGIONALES (NUTS 2 1 0 -1)
# 	- UNIT : NOMBRE (NR)
# 		- DEGRÉS-JOURS DE CHAUFFAGE (HDD)
# 		- DEGRÉS-JOURS DE REFROIDISSEMENT (CDD)
# 




# FONCTION : Fonction qui permet de :
# (i) : télécharger et importer la base de données
# (ii) : traiter les données afin d'avoir un format adéquat
# (iii) : renvoyer la base bien formatée
creation_colonne = function(lien, parametre_filtrage, variable_nom){
    
    
    # Récupération des données directement sur le site d'eurostat =====================================================
    # connexion
    
    # lien = "https://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing?file=data/demo_r_d2jan.tsv.gz"
    con = gzcon(url(lien))
    
    # lecture
    contenu = readLines(con)
    
    # nettoyage (les données présentent des flags ayant un sens particulier, on supprime ces indications mais on conserve les données)
    contenu_clean = str_remove_all(contenu, "[ bcdefnprsuz]")
    
    # transformation en dataframe
    df = read.delim(file = textConnection(contenu_clean),
                    sep = "\t",
                    header = T,
                    na.strings = c(":"),
                    stringsAsFactors = F,
                    fileEncoding = "UTF-8")
    
    # deconnexion
    close(con)
    
    # traitement
    # parametre_filtrage = "NR,T,TOTAL"
    
    df2 = df %>% 
        rename("REGION" = names(df)[1]) %>% # (1)
        filter(str_detect(REGION, parametre_filtrage) == TRUE) %>% # (2) 
        mutate(REGION = substr(REGION, nchar(parametre_filtrage)+2, 100)) %>% # (3)
        gather(key = "ANNEE", value = VARIABLE, -REGION) %>% # (4)
        mutate(ANNEE = as.numeric(str_remove(ANNEE, "X")), # (5)
               NUTS = paste("NUTS", nchar(REGION) - 2)) # (6)
    
    names(df2)[3] = get("variable_nom")
    
    # (1) : Renommage de la première colonne pour préparer à recevoir les régions
    # (2) : Filtrage pour récupérer les lignes souhaitées (population qui nous intéresse)
    # (3) : À l'origine, la région se situe en fin de chaine de caractère dans la première colonne, on extrait uniquement la région
    # (4) : On ramène les colonnes (années) en lignes pour n'avoir qu'une seule colonne de valeurs (en plus des colonnes d'identification)
    # (5) : On construit la variable ANNEE (nécessaire pour identifier et joindre plus tard)
    # (6) : On construit la variable NUTS (nécessaire pour identifier et joindre plus tard)
    return(df2)
}





## Création des listes à itérer afin d'automatiser les bases de données ===============================================================
liste_liens = c("https://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing?file=data/demo_r_d2jan.tsv.gz", # (1)
                "https://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing?file=data/demo_r_d3dens.tsv.gz", # (2)
                "https://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing?file=data/nama_10r_2gdp.tsv.gz", # (3)
                "https://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing?file=data/edat_lfse_16.tsv.gz", # (4)
                "https://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing?file=data/ilc_peps11.tsv.gz", # (5)
                "https://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing?file=data/ilc_li41.tsv.gz", # (6)
                "https://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing?file=data/lfst_r_lfu3rt.tsv.gz", # (7)
                "https://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing?file=data/nrg_chddr2_a.tsv.gz", # (8)
                "https://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing?file=data/nrg_chddr2_a.tsv.gz") # (9)

liste_params = c("NR,T,TOTAL", # (1)
                 "HAB_KM2", # (2)
                 "EUR_HAB", # (3)
                 "PC,T,Y18-24", # (4)
                 "PC", # (5)
                 "PC", # (6)
                 "PC,Y15-74,T", # (7)
                 "NR,CDD", # (8)
                 "NR,HDD") # (9)

liste_noms = c("POPULATION", # (1)
               "DENSITE", # (2)
               "PIBH", # (3)
               "EDUC_JEUNE", # (4)
               "RISQUE_PAUVR_NB", # (5)
               "RISQUE_PAUVR_TX", # (6)
               "CHOMAGE_TX", # (7)
               "DEGRES_JOUR_COLD", # (8)
               "DEGRES_JOUR_HOT") # (9)


# Préparation de la base finale (elle est mise à jour au fur des itérations)
df_final = data.frame()

for (i in c(1:length(liste_liens))){
    # création de la table contenant la i-ème variable
    df_temporaire = creation_colonne(liste_liens[i], liste_params[i], liste_noms[i])
    
    # jointure
    if (i == 1){
        df_final = df_temporaire
    } else {
        df_final = df_final %>% 
            left_join(df_temporaire,
                      by = c("REGION" = "REGION",
                             "ANNEE" = "ANNEE",
                             "NUTS" = "NUTS"))
    }
}


# réordonnage des colonnes (identifiants avant puis variable après)
df_final = df_final %>% 
    select(REGION, ANNEE, NUTS, everything())

# recodage des régions avant 2010
df_final_av2010 = df_final %>% 
    filter(ANNEE < 2010) %>% 
    mutate(REGION = recode(REGION, !!!dico_enquete_avant_2010))

# recodage des régions entre 2010 et 2013
df_final_entre_2010_2013 = df_final %>% 
    filter(ANNEE >= 2010 & ANNEE < 2013) %>% 
    mutate(REGION = recode(REGION, !!!dico_enquete_entre_2010_2013))

# récupération des lignes après 2013 et avant 2016 pour la concaténation
df_final_2013_2016 = df_final %>% 
    filter(ANNEE >= 2013 & ANNEE < 2016) 

# CODEBOOK-REFERENCE01 : refaire le df juste en haut pour 2016-...

# concaténation
df_final_corrige = df_final_av2010 %>% 
    bind_rows(df_final_entre_2010_2013) %>% 
    bind_rows(df_final_2013_2016) # CODEBOOK-REFERENCE01 : ajouter les nouveaux df (ex : df_final_2016_2020)


# jointure avec la base totale des moyennes
df_final2 = donnees_finale %>% 
    left_join(df_final_corrige,
              by = c("REGION" = "REGION",
                     "ANNEE" = "ANNEE",
                     "NUTS" = "NUTS"))

df_final2 = df_final2 %>% 
    left_join(centre_poly,
              by = c("REGION" = "REGION",
                     "ANNEE" = "ANNEE",
                     "NUTS" = "NUTS",
                     "PERIODE" = "PERIODE")) %>% 
    left_join(dico_nom_pays, # On rajoute une variable qui donne le nom du pays (au lieu d'un simple code)
              by = c("PAYS" = "code")) %>% 
    mutate(label = if_else(PAYS == "GR", "Greece", label)) %>% # cas particulier de la grêce qui peut être EL ou GR
    rename(NOM_PAYS = label) %>% 
    select(PAYS, NOM_PAYS, REGION, NOM_REGION, NUTS, ANNEE, PERIODE, ANNEES_PRESENTES, NB_MENAGE, NB_PERSONNE, everything())

# exportation (ce fichier alimentera l'application shiny, côté cartographie)
write.csv(df_final2, 
          file = "./data/finaux/donnees_carte_2.csv",
          row.names = F,
          fileEncoding = "UTF-8")


# récupération des données pour l'europe des 28
df_europe = df_final_corrige %>% 
    filter(REGION == "EU28")

# exportation
write.csv(df_europe, 
          file = "./data/finaux/donnees_carte_eu28.csv",
          row.names = F,
          fileEncoding = "UTF-8")