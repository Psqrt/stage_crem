###### PACKAGES ################################################################
### Shiny ###
library(shiny)
library(shinyWidgets)
library(shinyBS) # Pour le modalBS (pop-up fiche joueurs)
library(shinybusy) # https://github.com/dreamRs/shinybusy remotes::install_github("dreamRs/shinybusy")
library(shinythemes) # Pour le theme de l'application
library(htmltools)
library(htmlwidgets)

### Data manipulation ###
library(tidyr)
library(dplyr)
library(lubridate) # dates data
library(tibble)
library(DT)
library(stringr) # str data
library(data.table)
library(sp) # spatial data
library(png) # image data


### Visualisation
library(grid)
library(ggplot2)
library(plotly)
library(lattice)
library(leaflet)
library(geosphere)
library(leaflet.extras)
library(visNetwork)
library(RColorBrewer)
library(colourpicker)
library(scales) 
library(directlabels)    

###### DONNEES #################################################################
donnees_joueurs      = fread(file = "./data/fifa19net.csv",
                             header = T,
                             stringsAsFactors = F,
                             encoding = "UTF-8")

donnees_clubs        = fread(file = "./data/data_clubs.csv",
                             header = T,
                             stringsAsFactors = F,
                             encoding = "UTF-8")

clubs_trans          = fread("./data/data_clubs_geonet.csv",
                             sep = ",",
                             header = T,
                             stringsAsFactors = F,
                             encoding = "UTF-8")

donnees_trans        = fread("./data/tab_trans.csv",
                             sep = ";",
                             header = T,
                             stringsAsFactors = F,
                             encoding = "UTF-8")

tab_conversion_clubs = fread("./data/clubs_trans_net.csv",
                             sep = ",",
                             encoding="UTF-8")

coord_Pays           = fread("./data/coord_Pays.csv",
                             sep = ";",
                             encoding="UTF-8")

postes_coordonnees   = fread(file = "./data/positions.csv",
                             header = T,
                             sep = ",",
                             stringsAsFactors = F,
                             encoding = "UTF-8")

df_avec_logos        = fread(file = "./data/df_avec_logos.csv",
                             sep = ";",
                             encoding = "UTF-8",
                             stringsAsFactors = FALSE)

bg_terrain           = readRDS("./data/bg_terrain.rds")

seasons = sort(unique(donnees_trans$Season))
etoile = '<img src="https://www.freeiconspng.com/uploads/star-icon-32.png" height="16"></img>'

###### TAB JOUEURS ###############################################################
liste_positions_ordre_terrain = c(        "LS",  "ST",  "RS",                 #   1:3
                                          "LF",  "CF",  "RF",                 #   4:6
                                          "LW", "LAM", "CAM", "RAM", "RW",    #  7:11
                                          "LM", "LCM",  "CM", "RCM", "RM",    # 12:16
                                          "LWB", "LDM", "CDM", "RDM", "RWB",  # 17:21
                                          "LB", "LCB",  "CB", "RCB",  "RB",   # 22:26
                                          "GK")                               #    27

# Transforme les "" en "UNKNOWN" pour les positions de joueurs pour mieux présenter
donnees_joueurs$Position[donnees_joueurs$Position == ""] = "UNKNOWN"
# Rendre les images exploitables en html
donnees_joueurs$Photo0 = paste0('<img src="', donnees_joueurs$Photo, '" height="156"></img>')
donnees_joueurs$Photo0 = str_replace(donnees_joueurs$Photo0, "/players/4/", "/players/10/")
donnees_joueurs$Flag0 = paste0('<img src="', donnees_joueurs$Flag, '" height="26"></img>')
donnees_joueurs$Club.Logo1 = donnees_joueurs$Club.Logo
donnees_joueurs$Club.Logo0 = paste0('<img src="', donnees_joueurs$Club.Logo, '" height="26"></img>')
donnees_joueurs$Photo1 = paste0('<img src="', donnees_joueurs$Photo, '" height="26"></img>')
donnees_joueurs$Photo = paste0('<img src="', donnees_joueurs$Photo, '" height="52"></img>')
donnees_joueurs$Flag = paste0('<img src="', donnees_joueurs$Flag, '" height="26" style="float:right"></img>')
donnees_joueurs$Club.Logo = paste0('<img src="', donnees_joueurs$Club.Logo, '" height="26" style="float:right"></img>')

# Séparation GK et !GK
donnees_joueurs_field = donnees_joueurs %>% 
    filter(Position != "GK") %>%
    mutate(Choix = paste0(Name, " (", Club, ")", sep = ""))

donnees_joueurs_gk = donnees_joueurs %>% 
    filter(Position == "GK") %>%
    mutate(Choix = paste0(Name, " (", Club, ")", sep = ""))