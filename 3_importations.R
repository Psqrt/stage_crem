###### PACKAGES ################################################################
library(rjson)
library(leaflet)
# library(geojsonio)
library(tidyverse)
library(shiny)
library(shinydashboard)
library(shinyWidgets)
# library(geojsonio)

###### DONNEES #################################################################

moyenne_region = read.csv(file = "./data/finaux/donnees.csv",
                          sep = ",",
                          header = T,
                          stringsAsFactors = F)

dico_variable_import = read.csv(file = "./data/liste_variable.csv",
                                sep = ",",
                                header = T,
                                stringsAsFactors = F)

dico_variable_import$code_moy = paste(dico_variable_import$code, "_moy", sep = "")

dico_variable_moy = setNames(dico_variable_import$code_moy,
                             dico_variable_import$label)

df_variable_moy = data.frame(var = intersect(colnames(moyenne_region), dico_variable_moy),
                             stringsAsFactors = F)

df_variable_moy = df_variable_moy %>% 
    inner_join(dico_variable_import,
               by = c("var" = "code_moy"))

liste_variable_label = setNames(df_variable_moy$var,
                                df_variable_moy$label)

dico_variable_import[!(dico_variable_import$code %in% df_variable_moy$code),]

dico_liste_variable_page_import = read.csv(file = "./data/liste_variable_page.csv",
                                           sep = ",",
                                           header = T,
                                           stringsAsFactors = F)

dico_liste_variable_page = setNames(dico_liste_variable_page_import$page,
                                    dico_liste_variable_page_import$code)

source("./liste_deroulante_map.R")$values


### Cartes ###


if (1 == 0){
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
    # NOMS PAYS
    # data_map2003_nuts0_noms = geojsonio::geojson_read("./data/map1:60/NUTS_LB_2003_4326_LEVL_0.geojson", what = "sp")
    # data_map2006_nuts0_noms = geojsonio::geojson_read("./data/map1:60/NUTS_LB_2006_4326_LEVL_0.geojson", what = "sp")
    # data_map2010_nuts0_noms = geojsonio::geojson_read("./data/map1:60/NUTS_LB_2010_4326_LEVL_0.geojson", what = "sp")
    # data_map2013_nuts0_noms = geojsonio::geojson_read("./data/map1:60/NUTS_LB_2013_4326_LEVL_0.geojson", what = "sp")
    # data_map2016_nuts0_noms = geojsonio::geojson_read("./data/map1:60/NUTS_LB_2016_4326_LEVL_0.geojson", what = "sp")
}