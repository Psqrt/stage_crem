###### PACKAGES ################################################################
library(rjson)
library(leaflet)
# library(geojsonio)
library(tidyverse)

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
