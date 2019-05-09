###### PACKAGES ################################################################
library(rjson)
library(leaflet)
# library(geojsonio)
library(tidyverse)

###### DONNEES #################################################################


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

# 
# # DONNEES - ENQUETE
# liste_nom_fichier = list.files("./data/enquete/")
# # liste_nom_fichier = liste_nom_fichier[grep(annee_enquete, liste_nom_fichier)]
# liste_nom_fichier = substr(liste_nom_fichier, 1, nchar(liste_nom_fichier)-4)
# 
# # type_fichier = c("h", "d", "p", "r")
# type_fichier = c("h", "d")
# 
# df_h = data.frame()
# df_d = data.frame()
# df_p = data.frame()
# df_r = data.frame()
# 
# # Logique d'importation : importer les 4 fichiers csv de chaque fichier zip.
# for (fichier in liste_nom_fichier){
#     # print(paste0("./data/enquete/", fichier, ".zip", sep = ""))
#     print(fichier)
#     dir_zip = paste0("./data/enquete/", fichier, ".zip", sep = "")
#     for (type in type_fichier){
#         print(type)
#         # print(paste0(substr(fichier, 1, 7), type, substr(fichier, 8, nchar(fichier)), ".csv", sep = ""))
#         dir_csv = paste0(substr(fichier, 1, 7), type, substr(fichier, 8, nchar(fichier)), ".csv", sep = "")
#         provisoire = read.csv(con <- unz(dir_zip, dir_csv),
#                               header = T,
#                               sep = ",",
#                               stringsAsFactors = F,
#                               colClasses = c("character"))
#         if (type == "h"){
#             df_h = bind_rows(df_h, provisoire)
#         } else if (type == "d") {
#             df_d = bind_rows(df_d, provisoire)
#         } else if (type == "p") {
#             df_p = bind_rows(df_p, provisoire)
#         } else if (type == "r") {
#             df_r = bind_rows(df_r, provisoire)
#         }
#     }
# }
# 
# 
# # DONNEES - DICTIONNAIRE
# 
# dico_enquete_avant_2010 = read.csv(file = "./data/dictionnaire_codage_avant_2010.csv",
#                         sep = ",",
#                         header = T,
#                         stringsAsFactors = F)
# 
# dico_enquete_avant_2010 = setNames(dico_enquete_avant_2010$code_carte, 
#                                    dico_enquete_avant_2010$code_enquete)
# 
# 
# dico_enquete_apres_2010 = read.csv(file = "./data/dictionnaire_codage_apres_2010.csv",
#                         sep = ",",
#                         header = T,
#                         stringsAsFactors = F)
# 
# dico_enquete_apres_2010 = setNames(dico_enquete_apres_2010$code_carte, 
#                                    dico_enquete_apres_2010$code_enquete)
# 
# 
# dico_enquete_croatie_apres_2010 = read.csv(file = "./data/dictionnaire_codage_croatie_apres_2010.csv",
#                         sep = ",",
#                         header = T,
#                         stringsAsFactors = F)
# 
# dico_enquete_croatie_apres_2010 = setNames(dico_enquete_croatie_apres_2010$code_carte, 
#                                            dico_enquete_croatie_apres_2010$code_enquete)
# 
# 
# dico_enquete_uk_apres_2013 = read.csv(file = "./data/dictionnaire_codage_uk_apres_2013.csv",
#                                       sep = ",",
#                                       header = T,
#                                       stringsAsFactors = F)
# 
# dico_enquete_uk_apres_2013 = setNames(dico_enquete_uk_apres_2013$code_carte, 
#                                       dico_enquete_uk_apres_2013$code_enquete)

