# ===============================================================================
# Composition de l'application par modules : ====================================
# Chaque onglet a son fichier R dédié, il s'agira alors de sourcer l'ensemble ===
# des fichiers qui se trouvent dans le répertoire ./tab/ ========================
# ===============================================================================
fichiers_source = list.files("./tab")                        # 1. Obtention de la liste des fichiers ...
fichiers_source = paste("./tab/", fichiers_source, sep = '') # 2. Construction des chemins ...
sapply(fichiers_source, source)                              # 3. Sourcing de chacun de ces fichiers.

#source("./tab/tab_carto.R", encoding = "UTF-8")
#source("./tab/tab_stats_onglet1.R", encoding = "UTF-8")
#source("./tab/tab_stats_onglet2.R", encoding = "UTF-8")
#source("./tab/tab_stats_onglet3.R", encoding = "UTF-8")


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
                                         
                                         conditionalPanel("input.choix_nuts_onglet2 == 'NUTS 1' | input.choix_nuts_onglet2 == 'NUTS 2'",
                                                          selectInput(
                                                              inputId = "choix_pays_onglet2",
                                                              label = "COUNTRY",
                                                              choices = c("Choose a country" = "XXXX", liste_nuts0_stat),
                                                              width = "410px"
                                                          )
                                         ),
                                         
                                         selectInput(
                                             inputId = "choix_var_onglet2",
                                             label = "VARIABLE",
                                             choices = c("Choose a variable" = "XXXX", liste_deroulante_map),
                                             width = "410px"
                                         )
                        ),
                        
                        # ==============================================================================
                        # Ensemble des inputs utilisateurs pour l'onglet Scatter plot ==================
                        # ==============================================================================
                        conditionalPanel("input.sidebar == 'subtab_onglet3'",
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
