options(encoding = "UTF-8")


library(shiny)
library(shinydashboard)
library(rjson)
library(leaflet)
library(shinyWidgets)
# library(geojsonio)
library(tidyverse)

source('3_importations.R')
source('2_fichier_UI.R', local = TRUE)
source('2_fichier_server.R')

shinyApp(
    ui = contenu_UI,
    server = contenu_server
)

