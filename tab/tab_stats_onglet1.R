# LEXIQUE :
#    - INPUT : Élément de l'interface attendant un choix de l'utilisateur
#      OUTPUT : Élément de l'interface renvoyé par le côté serveur selon les inputs
#      PANEL : Élément de l'interface accueillant les inputs ou les outputs.

subtab_onglet1 = tabPanel("", # Chaine vide pour éviter un pop-up inutile lorsque le curseur est dans le body.
                          fluidPage(
                              
                              tags$div(id = "premier_fluidrow_stat",
                                       fluidRow(
                                           # PANEL : Fenêtre accueillant le graphique time series ======
                                           box(
                                               width = 7,
                                               title = "TIME SERIES",
                                               solidHeader = TRUE,
                                               status = "primary",
                                               # OUTPUT : Graphique time series ========================
                                               amChartsOutput(outputId = "amchart_ts",
                                                              width = "100%")
                                           ),
                                           
                                           # PANEL : Fenêtre accueillant les inputs utilisateur ========
                                           box(
                                               width = 5,
                                               title = "PARAMETERS",
                                               solidHeader = TRUE,
                                               status = "primary",
                                               height = "460px",
                                               
                                               tags$div(id = "parametre_ts_stat",
                                                        fluidRow(
                                                            column(width = 3,
                                                                   # INPUT : Représenter ou non une 2nde variable
                                                                   materialSwitch(
                                                                       inputId = "switch_variable_stat",
                                                                       label = "Variable 2", 
                                                                       value = FALSE,
                                                                       right = TRUE,
                                                                       status = "success"
                                                                   )
                                                            ),
                                                            column(width = 3,
                                                                   
                                                                   # INPUT : Représenter ou non une 2nde région
                                                                   materialSwitch(
                                                                       inputId = "switch_region_stat",
                                                                       label = "Region 2", 
                                                                       value = FALSE,
                                                                       right = TRUE,
                                                                       status = "success"
                                                                   )
                                                            ),
                                                            
                                                            column(width = 3,
                                                                   
                                                                   
                                                                   tags$div(
                                                                       id = "panel_pdf1_onglet1", 
                                                                       
                                                                       # PANEL : Afficher la documentation VAR1 si VAR1 choisie
                                                                       conditionalPanel("input.choix_var_ts1 != 'XXXX'",
                                                                                        
                                                                                        # OUTPUT : Documentation PDF variable 1
                                                                                        dropdownButton(
                                                                                            htmlOutput('pdf1_onglet1'),
                                                                                            circle = FALSE,
                                                                                            status = 'danger',
                                                                                            label = "Variable 1",
                                                                                            size = "sm",
                                                                                            icon = icon("file-pdf"),
                                                                                            width = "795px",
                                                                                            margin = "0px",
                                                                                            up = F,
                                                                                            right = T
                                                                                        )
                                                                       )
                                                                   )
                                                            ),
                                                            
                                                            column(width = 3,
                                                                   
                                                                   
                                                                   tags$div(
                                                                       id = "panel_pdf2_onglet1",
                                                                       
                                                                       # PANEL : Afficher la documentation VAR2 si VAR2 choisie
                                                                       conditionalPanel("input.choix_var_ts2 != 'XXXX' & input.switch_variable_stat == 1",
                                                                                        
                                                                                        # OUTPUT : Documentation PDF variable 2
                                                                                        dropdownButton(
                                                                                            htmlOutput('pdf2_onglet1'),
                                                                                            circle = FALSE,
                                                                                            status = 'danger',
                                                                                            label = "Variable 2",
                                                                                            size = "sm",
                                                                                            icon = icon("file-pdf"),
                                                                                            width = "795px",
                                                                                            margin = "0px",
                                                                                            up = F,
                                                                                            right = T
                                                                                        )
                                                                       )
                                                                   )
                                                            )
                                                            
                                                        ),
                                                        
                                                        
                                                        # INPUT : Choix de la variable 1 ===============
                                                        selectInput(
                                                            inputId = "choix_var_ts1",
                                                            label = "VARIABLE 1",
                                                            choices = c("Choose a variable" = "XXXX", liste_deroulante_map),
                                                            selected = "XXXX",
                                                            width = "635px"
                                                        ),
                                                        
                                                        conditionalPanel("input.switch_variable_stat == 1",
                                                                         
                                                                         # INPUT : Choix de la variable 2
                                                                         selectInput(
                                                                             inputId = "choix_var_ts2",
                                                                             label = "VARIABLE 2",
                                                                             choices = c("Choose a variable" = "XXXX", liste_deroulante_map),
                                                                             selected = "XXXX",
                                                                             width = "635px"
                                                                         )
                                                        ),
                                                        
                                                        
                                                        
                                                        
                                                        
                                                        
                                                        
                                                        
                                                        tags$div(id = "legend_fluidrow_ts",
                                                                 fluidRow(
                                                                     column(width = 4,
                                                                            
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
                                                                            )
                                                                     ),
                                                                     
                                                                     column(width = 8,
                                                                            conditionalPanel("input.choix_nuts_ts1 == 'NUTS 0'",
                                                                                             
                                                                                             # INPUT : Choix de la région NUTS 0 (1ere region)
                                                                                             selectInput(
                                                                                                 inputId = "choix_region_ts1a",
                                                                                                 label = "REGION 1",
                                                                                                 choices = c("Choose a country" = "XXXX", liste_nuts0_stat),
                                                                                                 width = "410px"
                                                                                             )
                                                                            ),
                                                                            conditionalPanel("input.choix_nuts_ts1 == 'NUTS 1'",
                                                                                             
                                                                                             # INPUT : Choix de la région NUTS 1 (1ere region)
                                                                                             selectInput(
                                                                                                 inputId = "choix_region_ts1b",
                                                                                                 label = "REGION 1",
                                                                                                 choices = c("Choose a region" = "XXXX", liste_nuts1_stat),
                                                                                                 width = "410px"
                                                                                             )
                                                                            ),
                                                                            conditionalPanel("input.choix_nuts_ts1 == 'NUTS 2'",
                                                                                             
                                                                                             # INPUT : Choix de la région NUTS 2 (1ere region)
                                                                                             selectInput(
                                                                                                 inputId = "choix_region_ts1c",
                                                                                                 label = "REGION 1",
                                                                                                 choices = c("Choose a region" = "XXXX", liste_nuts2_stat),
                                                                                                 width = "410px"
                                                                                             )
                                                                            )
                                                                     )
                                                                 ),
                                                                 
                                                                 
                                                                 
                                                                 
                                                                 
                                                                 conditionalPanel("input.switch_region_stat == 1",
                                                                                  fluidRow(
                                                                                      column(width = 4,
                                                                                             
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
                                                                                             )
                                                                                      ),
                                                                                      
                                                                                      column(width = 8,
                                                                                             conditionalPanel("input.choix_nuts_ts2 == 'NUTS 0'",
                                                                                                              
                                                                                                              # INPUT : Choix de la région NUTS 0 (2nde région)
                                                                                                              selectInput(
                                                                                                                  inputId = "choix_region_ts2a",
                                                                                                                  label = "REGION 2",
                                                                                                                  choices = c("Choose a country" = "XXXX", liste_nuts0_stat),
                                                                                                                  width = "410px"
                                                                                                              )
                                                                                             ),
                                                                                             conditionalPanel("input.choix_nuts_ts2 == 'NUTS 1'",
                                                                                                              
                                                                                                              # INPUT : Choix de la région NUTS 1 (2nde région)
                                                                                                              selectInput(
                                                                                                                  inputId = "choix_region_ts2b",
                                                                                                                  label = "REGION 2",
                                                                                                                  choices = c("Choose a region" = "XXXX", liste_nuts1_stat),
                                                                                                                  width = "410px"
                                                                                                              )
                                                                                             ),
                                                                                             conditionalPanel("input.choix_nuts_ts2 == 'NUTS 2'",
                                                                                                              
                                                                                                              # INPUT : Choix de la région NUTS 2 (2nde région)
                                                                                                              selectInput(
                                                                                                                  inputId = "choix_region_ts2c",
                                                                                                                  label = "REGION 2",
                                                                                                                  choices = c("Choose a region" = "XXXX", liste_nuts2_stat),
                                                                                                                  width = "410px"
                                                                                                              )
                                                                                             )
                                                                                      )
                                                                                  )
                                                                 )
                                                        )
                                               )
                                           )
                                       )
                              ),
                              
                              tags$div(id = "deuxieme_fluidrow_stat",
                                       fluidRow(
                                           # PANEL : Fenêtre accueilant le graphique bar plot ==========
                                           box(
                                               width = 7,
                                               title = "BAR PLOT",
                                               solidHeader = TRUE,
                                               status = "primary",
                                               
                                               # OUTPUT : Graphique bar plot ===========================
                                               amChartsOutput(outputId = "barplot",
                                                              width = "100%")
                                           ),
                                           
                                           # PANEL : Fenêtre accueillant le tableau des données ========
                                           box(
                                               width = 5,
                                               title = "DATA",
                                               solidHeader = TRUE,
                                               status = "primary",
                                               
                                               # OUTPUT : Tableau des données ==========================
                                               DT::dataTableOutput("df_tableau_central")
                                           )
                                       )
                              )
                          )
)