# ===============================================================================
# Composition de l'application par modules : ====================================
# Chaque onglet a son fichier R dédié, il s'agira alors de sourcer l'ensemble ===
# des fichiers qui se trouvent dans le répertoire ./tab/ ========================
# ===============================================================================
# fonction qui sert à source avec l'encoding UTF-8
source_utf8 = function(fichier){
    source(fichier, encoding = "UTF-8")
}

fichiers_source = list.files("./tab")                        # 1. Obtention de la liste des fichiers ...
fichiers_source = paste("./tab/", fichiers_source, sep = '') # 2. Construction des chemins ...
sapply(fichiers_source, source_utf8)                         # 3. Sourcing de chacun de ces fichiers.


contenu_UI <- shinyUI(
    dashboardPagePlus(
        dashboardHeaderPlus(
            title = tagList(
                span(class = "logo-lg", "Fuel Poverty"),
                icon("fas fa-home"))
        ),
        
#         tags$script("
# $(document).on('shiny:conditional', function(event) {
#   if (event.name === 'map') {
#     // on récupère l'élément
# var elmt = document.getElementById('body');
# // on modifie son style
# elmt.style.overFlow = 'none';
#   }
# "),
        
        # ==============================================================================
        # Barre de navigation latérale =================================================
        # ==============================================================================
        dashboardSidebar(
            sidebarMenu(id = "sidebar",
                        menuItem("PRESENTATION",
                                 tabName = "tab_presentation",
                                 icon = icon("user-friends")
                        ),
                        menuItem("HOME PAGE",
                                 tabName = "tab_homepage",
                                 icon = icon("home")
                        ),
                        menuItem("MAP", 
                                 tabName = "tab_carto", 
                                 icon = icon("globe-americas")
                        ),
                        menuItem(text = "STATISTICS", 
                                 tabName = "tab_stats",
                                 icon = icon("chart-bar"),
                                 menuSubItem(text = "Time series",
                                             tabName = "subtab_stats_time_series"
                                 ),
                                 menuSubItem(text = "Scatter plot",
                                             tabName = "subtab_stats_scatter_plot"
                                 ),
                                 menuSubItem(text = "Comparison",
                                             tabName = "subtab_stats_comparison")
                        ),
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        # ==============================================================================
                        # Ensemble des inputs utilisateurs pour l'onglet cartographie ==================
                        # ==============================================================================
                        conditionalPanel("input.sidebar == 'tab_carto'",
                                         
                                         
                                         # = INPUT : Choix du niveau NUTS =========================
                                         radioGroupButtons(
                                             inputId = "choix_nuts",
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
                                                                       choices = c("Select a variable" = "XXXX", liste_deroulante_map),
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
                                         ),
                                         
                                         # INPUT : Bouton donnant les instructions à l'utilisateur pour la carte
                                         actionBttn(
                                             inputId = "instructions_map",
                                             label = "Information", 
                                             style = "bordered",
                                             color = "primary",
                                             icon = icon("info-circle"),
                                             size = "sm",
                                             block = T
                                         )
                                         
                                         
                                         
                        ),
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        # ==============================================================================
                        # Ensemble des inputs utilisateurs pour l'onglet Time series ===================
                        # ==============================================================================
                        conditionalPanel("input.sidebar == 'subtab_stats_time_series'",
                                         radioGroupButtons(
                                             inputId = "choix_nuts_stats_time_series",
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
                                             inputId = "choix_var_stats_time_series",
                                             label = "VARIABLE",
                                             choices = c("Select a variable" = "XXXX", liste_deroulante_map),
                                             width = "410px"
                                         ),
                                         
                                         
                                         conditionalPanel("input.choix_nuts_stats_time_series == 'NUTS 0'",
                                                          pickerInput(
                                                              inputId = "choix_pays_stats_time_series_nuts_0",
                                                              label = "COUNTRIES",
                                                              choices = liste_dico_pays_stats,
                                                              selected = NA,
                                                              multiple = TRUE,
                                                              options = list(
                                                                  'actions-box' = TRUE)
                                                          )
                                         ),
                                         
                                         conditionalPanel("input.choix_nuts_stats_time_series != 'NUTS 0'",
                                                          
                                                          selectInput(
                                                              inputId = "choix_pays_stats_time_series_nuts_1_2",
                                                              label = "COUNTRY",
                                                              choices = c("Select a country" = "XXXX", liste_dico_pays_stats),
                                                              selected = "XXXX",
                                                              width = "410px"
                                                              
                                                          ),
                                                          
                                                          conditionalPanel("input.choix_pays_stats_time_series_nuts_1_2 != 'XXXX'",
                                                                           pickerInput(
                                                                               inputId = "choix_region_stats_time_series",
                                                                               label = "REGIONS",
                                                                               choices = c(""),
                                                                               selected = NA,
                                                                               multiple = TRUE,
                                                                               options = list(
                                                                                   'actions-box' = TRUE)
                                                                           )
                                                          )
                                         )
                        ),
                        
                        # ==============================================================================
                        # Ensemble des inputs utilisateurs pour l'onglet Scatter plot ==================
                        # ==============================================================================
                        conditionalPanel("input.sidebar == 'subtab_stats_scatter_plot'",
                                         
                                         
                                         
                                         radioGroupButtons(
                                             inputId = "choix_nuts_stats_scatter_plot",
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
                                             inputId = "choix_var1_stats_scatter_plot",
                                             label = "VARIABLE 1",
                                             choices = c("Select a variable" = "XXXX", liste_deroulante_map),
                                             selected = "XXXX",
                                             width = "410px"),
                                         
                                         selectInput(
                                             inputId = "choix_var2_stats_scatter_plot",
                                             label = "VARIABLE 2",
                                             choices = c("Select a variable" = "XXXX", liste_deroulante_map),
                                             selected = "XXXX",
                                             width = "410px"),
                                         
                                         conditionalPanel("input.animation_frame_stats_scatter_plot != 1",
                                                          pickerInput(
                                                              inputId = "choix_annee_scatter_plot",
                                                              label = "YEARS",
                                                              choices= unique(na.omit(moyenne_region$ANNEE)),
                                                              selected = unique(na.omit(moyenne_region$ANNEE)),
                                                              multiple = TRUE,
                                                              options = list(
                                                                  'actions-box' = TRUE)
                                                          )
                                         ),
                                         
                                         materialSwitch(
                                             inputId = "switch_3d_stats_scatter_plot",
                                             label = "3D CHART", 
                                             value = FALSE,
                                             right = TRUE,
                                             status = "success"
                                         ),
                                         
                                         materialSwitch(
                                             inputId = "animation_frame_stats_scatter_plot",
                                             label = "TIMELAPSE", 
                                             value = TRUE,
                                             right = TRUE,
                                             status = "success"
                                         )
                        ),
                        
                        
                        # ==============================================================================
                        # Ensemble des inputs utilisateurs pour l'onglet Comparison ====================
                        # ==============================================================================
                        conditionalPanel("input.sidebar == 'subtab_stats_comparison'",
                                         
                                         fluidRow(
                                             column(width = 6,
                                                    # INPUT : Représenter ou non une 2nde variable
                                                    materialSwitch(
                                                        inputId = "switch_variable_stats_comparison",
                                                        label = "Variable 2",
                                                        value = FALSE,
                                                        right = TRUE,
                                                        status = "success"
                                                    )
                                             ),
                                             column(width = 6,
                                                    
                                                    # INPUT : Représenter ou non une 2nde région
                                                    materialSwitch(
                                                        inputId = "switch_region_stats_comparison",
                                                        label = "Region 2",
                                                        value = FALSE,
                                                        right = TRUE,
                                                        status = "success"
                                                    )
                                             )
                                         ),
                                         
                                         
                                         # INPUT : Choix de la variable 1 ===============
                                         selectInput(
                                             inputId = "choix_var_ts1",
                                             label = "VARIABLE 1",
                                             choices = c("Select a variable" = "XXXX", liste_deroulante_map),
                                             selected = "XXXX",
                                             width = "635px"
                                         ),
                                         
                                         conditionalPanel("input.switch_variable_stats_comparison == 1",
                                                          
                                                          # INPUT : Choix de la variable 2
                                                          selectInput(
                                                              inputId = "choix_var_ts2",
                                                              label = "VARIABLE 2",
                                                              choices = c("Select a variable" = "XXXX", liste_deroulante_map),
                                                              selected = "XXXX",
                                                              width = "635px"
                                                          )
                                         ),
                                         
                                         
                                         
                                         
                                         
                                         
                                         
                                         tags$div(id = "params_comp_region1",
                                                  
                                                  # INPUT : Choix du niveau NUTS pour la 1ere région
                                                  radioGroupButtons(
                                                      inputId = "choix_nuts_ts1",
                                                      label = "NUTS LEVEL",
                                                      choices = c('0' = "NUTS 0",
                                                                  '1' = "NUTS 1",
                                                                  '2' = "NUTS 2"),
                                                      selected = "NUTS 0",
                                                      checkIcon = list(
                                                          yes = tags$i(class = "fa fa-circle",
                                                                       style = "color: steelblue"),
                                                          no = tags$i(class = "fa fa-circle-o",
                                                                      style = "color: steelblue"))
                                                  ),
                                                  
                                                  conditionalPanel("input.choix_nuts_ts1 == 'NUTS 0'",
                                                                   
                                                                   # INPUT : Choix de la région NUTS 0 (1ere region)
                                                                   selectInput(
                                                                       inputId = "choix_region_ts1a",
                                                                       label = "REGION 1",
                                                                       choices = c("Select a country" = "XXXX", liste_nuts0_stat),
                                                                       width = "410px"
                                                                   )
                                                  ),
                                                  conditionalPanel("input.choix_nuts_ts1 == 'NUTS 1'",
                                                                   
                                                                   # INPUT : Choix de la région NUTS 1 (1ere region)
                                                                   selectInput(
                                                                       inputId = "choix_region_ts1b",
                                                                       label = "REGION 1",
                                                                       choices = c("Select a region" = "XXXX", liste_nuts1_stat),
                                                                       width = "410px"
                                                                   )
                                                  ),
                                                  conditionalPanel("input.choix_nuts_ts1 == 'NUTS 2'",
                                                                   
                                                                   # INPUT : Choix de la région NUTS 2 (1ere region)
                                                                   selectInput(
                                                                       inputId = "choix_region_ts1c",
                                                                       label = "REGION 1",
                                                                       choices = c("Select a region" = "XXXX", liste_nuts2_stat),
                                                                       width = "410px"
                                                                   )
                                                  )
                                         ),
                                         
                                         
                                         
                                         
                                         conditionalPanel("input.switch_region_stats_comparison == 1",
                                                          
                                                          tags$div(id = "params_comp_region2",
                                                                   
                                                                   # INPUT : Choix du niveau NUTS pour la 2nde région
                                                                   radioGroupButtons(
                                                                       inputId = "choix_nuts_ts2",
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
                                                                   
                                                                   conditionalPanel("input.choix_nuts_ts2 == 'NUTS 0'",
                                                                                    
                                                                                    # INPUT : Choix de la région NUTS 0 (2nde région)
                                                                                    selectInput(
                                                                                        inputId = "choix_region_ts2a",
                                                                                        label = "REGION 2",
                                                                                        choices = c("Select a country" = "XXXX", liste_nuts0_stat),
                                                                                        width = "410px"
                                                                                    )
                                                                   ),
                                                                   conditionalPanel("input.choix_nuts_ts2 == 'NUTS 1'",
                                                                                    
                                                                                    # INPUT : Choix de la région NUTS 1 (2nde région)
                                                                                    selectInput(
                                                                                        inputId = "choix_region_ts2b",
                                                                                        label = "REGION 2",
                                                                                        choices = c("Select a region" = "XXXX", liste_nuts1_stat),
                                                                                        width = "410px"
                                                                                    )
                                                                   ),
                                                                   conditionalPanel("input.choix_nuts_ts2 == 'NUTS 2'",
                                                                                    
                                                                                    # INPUT : Choix de la région NUTS 2 (2nde région)
                                                                                    selectInput(
                                                                                        inputId = "choix_region_ts2c",
                                                                                        label = "REGION 2",
                                                                                        choices = c("Select a region" = "XXXX", liste_nuts2_stat),
                                                                                        width = "410px"
                                                                                    )
                                                                   )
                                                          )
                                         )
                        )    
            )
        ),
        
        
        
        
        # ==============================================================================
        # Contenu des onglets ==========================================================
        # ==============================================================================
        dashboardBody(
            useShinyjs(), # Extensions pour shiny
            
            tags$style(HTML(".css_carto {overflow: hidden;}")),
            tags$style(HTML(".css_autre {overflow: auto}")),
            
            includeCSS("./extra/styles.css", encoding = "UTF-8"), # Feuille CSS
            tabItems(
                tabItem(
                    tabName = "tab_presentation",
                    tab_presentation), # ./tab/tab_presentation.R
                tabItem(
                    tabName = "tab_homepage",
                    tab_homepage), # ./tab/tab_homepage.R
                tabItem(
                    tabName = "tab_carto",
                    tab_carto), # ./tab/tab_carto.R
                tabItem(
                    tabName = "subtab_stats_comparison",
                    subtab_stats_comparison), # ./tab/tab_stats_stats_comparison.R
                tabItem(
                    tabName = "subtab_stats_time_series",
                    subtab_stats_time_series), # ./tab/tab_stats_stats_time_series.R
                tabItem(
                    tabName = "subtab_stats_scatter_plot",
                    subtab_stats_scatter_plot) # ./tab/tab_stats_stats_scatter_plot.R
            )
        )
    )
)
