options(encoding = "UTF-8")

# Ne pas lancer ce fichier, utiliser le fichier 1_fichier_lanceur.R
# Celui-ci sert uniquement pour shinyapps.io
library(shiny)
library(shinydashboard)
library(rjson)
library(leaflet)
library(shinyWidgets)
library(tidyverse)

source('3_importations.R')
source('2_fichier_UI.R', local = TRUE)
source('2_fichier_server.R')

shinyApp(
    ui = contenu_UI,
    server = contenu_server
)