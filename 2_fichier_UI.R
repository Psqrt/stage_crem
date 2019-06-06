# ===============================================================================
# Composition de l'application par modules : ====================================
# Chaque onglet a son fichier R dédié, il s'agira alors de sourcer l'ensemble ===
# des fichiers qui se trouvent dans le répertoire ./tab/ ========================
# ===============================================================================
fichiers_source = list.files("./tab")                        # 1. Obtention de la liste des fichiers ...
fichiers_source = paste("./tab/", fichiers_source, sep = '') # 2. Construction des chemins ...
# sapply(fichiers_source, source)                              # 3. Sourcing de chacun de ces fichiers.

source("./tab/tab_carto.R", encoding = "UTF-8")
source("./tab/tab_stats_onglet1.R", encoding = "UTF-8")
source("./tab/tab_stats_onglet2.R", encoding = "UTF-8")
source("./tab/tab_stats_onglet3.R", encoding = "UTF-8")


contenu_UI <- shinyUI(
    dashboardPagePlus(
        dashboardHeaderPlus(
            title = tagList(
                span(class = "logo-lg", "Fuel Poverty"),
                icon("fas fa-home"))
        ),
        
        
        
        # ==============================================================================
        # Barre de navigation latérale =================================================
        # ==============================================================================
        dashboardSidebar(
            sidebarMenu(id = "sidebar",
                        menuItem("MAP", 
                                 tabName = "tab_carto", 
                                 icon = icon("globe-americas")
                        ),
                        menuItem(text = "STATISTICS", 
                                 tabName = "tab_stats",
                                 icon = icon("chart-bar"),
                                 menuSubItem(text = "Time series",
                                             tabName = "subtab_onglet2"
                                 ),
                                 menuSubItem(text = "Scatter plot",
                                             tabName = "subtab_onglet3"
                                 ),
                                 menuSubItem(text = "(Extra)",
                                             tabName = "subtab_onglet1")
                        ),
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        # ==============================================================================
                        # Ensemble des inputs utilisateurs pour l'onglet cartographie ==================
                        # ==============================================================================
                        conditionalPanel("input.sidebar == 'tab_carto'",
                                         
                                         
                                         # = INPUT : Choix du niveau NUTS =========================
                                         radioGroupButtons(
                                             inputId = "choix_nuts",
                                             label = "LEVEL",
                                             choices = c("0" = "NUTS 0",
                                                         "1" = "NUTS 1",
                                                         "2" = "NUTS 2"),
                                             selected = "NUTS 0",
                                             checkIcon = list(
                                                 yes = tags$i(class = "fa fa-circle", 
                                                              style = "color: steelblue"),
                                                 no = tags$i(class = "fa fa-circle-o", 
                                                             style = "color: steelblue"))
                                         ),
                                         
                                         tags$div(id = "legend_switch_var2_map",
                                                  # = INPUT : Choix 2nde variable ====
                                                  materialSwitch(
                                                      inputId = "switch_var2_map",
                                                      label = "VARIABLE 2", 
                                                      value = FALSE,
                                                      right = TRUE,
                                                      status = "success"
                                                  )
                                         ),
                                         
                                         tags$div(id = "legend_switch_2_periode_map",
                                                  # = INPUT : Choix du mode : ANNEE ou PERIODE ====
                                                  materialSwitch(
                                                      inputId = "switch_periode_map",
                                                      label = "PERIOD", 
                                                      value = FALSE,
                                                      right = TRUE,
                                                      status = "success"
                                                  )
                                         ),
                                         
                                         tags$div(id = "div_choix_variable_1_map",
                                                  class = "div_cvm",
                                                  # = INPUT : Choix de la variable à représenter ======================
                                                  selectInput(
                                                      inputId = "choix_variable_1_map",
                                                      label = "VARIABLE 1 (COLOR)", 
                                                      width = "430px",
                                                      choices = c("Select a variable" = "XXXX", liste_deroulante_map),
                                                      selected = "XXXX"
                                                  )
                                         ),
                                         
                                         
                                         conditionalPanel("input.switch_var2_map == 1", # Si variable 2 est active ===
                                                          tags$div(id = "div_choix_variable_2_map",
                                                                   class = "div_cvm",
                                                                   # = INPUT : Choix de la variable à représenter ======================
                                                                   selectInput(
                                                                       inputId = "choix_variable_2_map",
                                                                       label = "VARIABLE 2 (CIRCLE)", 
                                                                       width = "430px",
                                                                       choices = c("Choose a variable" = "XXXX", liste_deroulante_map),
                                                                       selected = "XXXX"
                                                                   )
                                                          )
                                         ),
                                         
                                         
                                         
                                         conditionalPanel("input.switch_periode_map == 0", # Si le mode ANNEE est actif ===
                                                          tags$div(id = "div_choix_annee",
                                                                   class = "div_ca",
                                                                   # = INPUT : Choix de l'année à représenter =========
                                                                   sliderTextInput(
                                                                       inputId = "choix_annee",
                                                                       width = "430px",
                                                                       label = "YEAR", 
                                                                       choices = c(2004:2013) # NOTE : coder ce vecteur plus proprement.
                                                                   )
                                                          )
                                         ),
                                         
                                         conditionalPanel("input.switch_periode_map == 1", # Si le mode PERIODE est actif =
                                                          # = INPUT : Choix de la période à représenter ===============
                                                          selectInput(
                                                              inputId = "choix_periode",
                                                              label = "PERIOD",
                                                              width = "430px",
                                                              choices = c("2004-2005",
                                                                          "2006-2009",
                                                                          "2010-2012",
                                                                          "2013-2015")
                                                          )
                                         )
                                         
                                         
                                         
                        ),
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        # ==============================================================================
                        # Ensemble des inputs utilisateurs pour l'onglet Time series ===================
                        # ==============================================================================
                        conditionalPanel("input.sidebar == 'subtab_onglet2'",
                                         radioGroupButtons(
                                             inputId = "choix_nuts_onglet2",
                                             label = "NUTS LEVEL",
                                             choices = c("0" = "NUTS 0",
                                                         "1" = "NUTS 1",
                                                         "2" = "NUTS 2"),
                                             selected = "NUTS 0",
                                             checkIcon = list(
                                                 yes = tags$i(class = "fa fa-circle",
                                                              style = "color: steelblue"),
                                                 no = tags$i(class = "fa fa-circle-o",
                                                             style = "color: steelblue"))
                                         ),
                                         
                                         # conditionalPanel("input.choix_nuts_onglet2 == 'NUTS 1' | input.choix_nuts_onglet2 == 'NUTS 2'",
                                         #                  selectInput(
                                         #                      inputId = "choix_pays_onglet2",
                                         #                      label = "COUNTRY",
                                         #                      choices = c("Choose a country" = "XXXX", liste_nuts0_stat),
                                         #                      width = "410px"
                                         #                  )
                                         # ),
                                         
                                         selectInput(
                                             inputId = "choix_var_onglet2",
                                             label = "VARIABLE",
                                             choices = c("Choose a variable" = "XXXX", liste_deroulante_map),
                                             width = "410px"
                                         ),
                                         
                                         
                                         pickerInput(
                                             inputId = "choix_pays_onglet2",
                                             label = "COUNTRIES",
                                             choices = liste_dico_pays_stats,
                                             selected = NA,
                                             multiple = TRUE,
                                             options = list(
                                                 'actions-box' = TRUE)
                                         )
                        ),
                        
                        # ==============================================================================
                        # Ensemble des inputs utilisateurs pour l'onglet Scatter plot ==================
                        # ==============================================================================
                        conditionalPanel("input.sidebar == 'subtab_onglet3'",
                                         
                                         
                                         
                                         radioGroupButtons(
                                             inputId = "choix_nuts_onglet3",
                                             label = "NUTS LEVEL",
                                             choices = c("0" = "NUTS 0",
                                                         "1" = "NUTS 1",
                                                         "2" = "NUTS 2"),
                                             selected = "NUTS 0",
                                             checkIcon = list(
                                                 yes = tags$i(class = "fa fa-circle",
                                                              style = "color: steelblue"),
                                                 no = tags$i(class = "fa fa-circle-o",
                                                             style = "color: steelblue"))
                                         ),
                                         
                                         selectInput(
                                             inputId = "choix_var1_onglet3",
                                             label = "VARIABLE 1",
                                             choices = c("Choose a variable" = "XXXX", liste_deroulante_map),
                                             selected = "XXXX",
                                             width = "410px"),
                                         
                                         selectInput(
                                             inputId = "choix_var2_onglet3",
                                             label = "VARIABLE 2",
                                             choices = c("Choose a variable" = "XXXX", liste_deroulante_map),
                                             selected = "XXXX",
                                             width = "410px"),
                                         
                                         
                                         pickerInput(
                                             inputId = "choix_annee_scatterplot",
                                             label = "YEARS",
                                             choices= unique(na.omit(moyenne_region$ANNEE)),
                                             selected = NA,
                                             multiple = TRUE,
                                             options = list(
                                                 'actions-box' = TRUE)
                                         ),
                                         
                                         materialSwitch(
                                             inputId = "switch_3d_onglet3",
                                             label = "3D CHART", 
                                             value = FALSE,
                                             right = TRUE,
                                             status = "success"
                                         )
                        )
            )
        ),
        
        
        # ==============================================================================
        # Contenu des onglets ==========================================================
        # ==============================================================================
        dashboardBody(
            useShinyjs(), # Extensions pour shiny
            includeCSS("./extra/styles.css", encoding = "UTF-8"), # Feuille CSS
            tabItems(
                tabItem(
                    tabName = "tab_carto",
                    tab_carto), # ./tab/tab_carto.R
                tabItem(
                    tabName = "subtab_onglet1",
                    subtab_onglet1), # ./tab/tab_stats_onglet1.R
                tabItem(
                    tabName = "subtab_onglet2",
                    subtab_onglet2), # ./tab/tab_stats_onglet2.R
                tabItem(
                    tabName = "subtab_onglet3",
                    subtab_onglet3) # ./tab/tab_stats_onglet3.R
            )
        )
    )
)
