# Placez dans le répetoire ./data/enquete_test/ les fichiers csv type D à tester
# Copiez le nom d'un des fichiers csv à tester et assignez le dans la variable nom_fichier

# Entrer le nom du fichier csv à importer
# nom_fichier = "EL_2009d_EUSILC.csv" # (si ce sont des données publiques par exemple)
nom_fichier = "UDB_cES13D.csv"

# importation des cartes NUTS 2
if (1 == 1){ # mettre une condition impossible pour ne pas importer les cartes
        # DONNEES - CARTE NUTS2
        data_map2003_nuts2 = geojsonio::geojson_read("./data/map1_60/NUTS_RG_20M_2003_4326_LEVL_2.geojson", what = "sp")
        data_map2006_nuts2 = geojsonio::geojson_read("./data/map1_60/NUTS_RG_60M_2006_4326_LEVL_2.geojson", what = "sp")
        data_map2010_nuts2 = geojsonio::geojson_read("./data/map1_60/NUTS_RG_60M_2010_4326_LEVL_2.geojson", what = "sp")
        data_map2013_nuts2 = geojsonio::geojson_read("./data/map1_60/NUTS_RG_60M_2013_4326_LEVL_2.geojson", what = "sp")
        data_map2016_nuts2 = geojsonio::geojson_read("./data/map1_60/NUTS_RG_60M_2016_4326_LEVL_2.geojson", what = "sp")
}  


dir_fichier = paste("./data/enquete_test/", nom_fichier, sep = "")
# Imporation du fichier que l'on veut étudier
fichier_enquete = read.csv(file = dir_fichier,
                           sep = ",",
                           header = T,
                           stringsAsFactors = F,
                           fileEncoding = "UTF-8")

annee_fichier = 2000 + as.numeric(substr(nom_fichier, 8, 9)) # UDB_cES10D.csv => 10 => 2010

# on sélectionne l'année de la carte correspondant à l'année de l'enquête
if(annee_fichier >= 2003 & annee_fichier < 2006){
    annee_carte = 2003
} else if (annee_fichier >= 2006 & annee_fichier < 2010){
    annee_carte = 2006
} else if (annee_fichier >= 2010 & annee_fichier < 2013){
    annee_carte = 2010
} else if (annee_fichier >= 2013 & annee_fichier < 2016){
    annee_carte = 2013
}

fichier_carte = paste0("data_map", annee_carte, "_nuts2", sep = "")

# on extrait les nuts de la carte et de l'enquete dans 2 listes distinctes
niveau_nuts_carte = levels(get(fichier_carte)@data[["NUTS_ID"]])
niveau_nuts_enquete = levels(as.factor(fichier_enquete$DB040))

# on trouve les nuts en commun entre les 2 listes enquête/carte
nuts_commun = intersect(niveau_nuts_enquete, niveau_nuts_carte)

# on retire les nuts en commun de la liste des nuts de l'enquête pour n'avoir que les différences
niveau_nuts_enquete = setdiff(niveau_nuts_enquete, nuts_commun)

# résultat
print(niveau_nuts_enquete)

# Si ça affiche character(0), c'est qu'il ne semble pas y avoir de problème.

# les valeurs qui en sortent indiquent les régions qui n'ont pas été identifiées par la carte,
# il faut alors traiter une à une chaque région (probablement codée selon une norme différente)
# pour trouver le bon code.