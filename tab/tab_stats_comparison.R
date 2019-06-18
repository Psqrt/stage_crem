# LEXIQUE :
#    - INPUT : Élément de l'interface attendant un choix de l'utilisateur
#      OUTPUT : Élément de l'interface renvoyé par le coté serveur selon les inputs
#      PANEL : Élément de l'interface accueillant les inputs ou les outputs.

subtab_stats_comparison = tabPanel("", # Chaine vide pour éviter un pop-up inutile lorsque le curseur est dans le body.
                                   fluidPage(
                                       
                                       tags$div(id = "premier_fluidrow_stat",
                                                fluidRow(
                                                    # PANEL : Fenêtre accueillant le graphique time series ======
                                                    box(
                                                        width = 12,
                                                        title = "TIME SERIES",
                                                        solidHeader = TRUE,
                                                        status = "primary",
                                                        
                                                        fluidRow(
                                                            tags$div(
                                                                id = "panel_pdf1_stats_comparison",
                                                                
                                                                # PANEL : Afficher la documentation VAR1 si VAR1 choisie
                                                                conditionalPanel("input.choix_var_ts1 != 'XXXX'",
                                                                                 
                                                                                 # OUTPUT : Documentation PDF variable 1
                                                                                 dropdownButton(
                                                                                     htmlOutput('pdf1_stats_comparison'),
                                                                                     circle = FALSE,
                                                                                     status = 'danger',
                                                                                     label = "Variable 1",
                                                                                     size = "sm",
                                                                                     icon = icon("file-pdf"),
                                                                                     width = "795px",
                                                                                     margin = "0px",
                                                                                     up = F,
                                                                                     right = F
                                                                                 )
                                                                )
                                                            ),
                                                            
                                                            tags$div(
                                                                id = "panel_pdf2_stats_comparison",
                                                                
                                                                # PANEL : Afficher la documentation VAR2 si VAR2 choisie
                                                                conditionalPanel("input.choix_var_ts2 != 'XXXX' & input.switch_variable_stats_comparison == 1",
                                                                                 
                                                                                 # OUTPUT : Documentation PDF variable 2
                                                                                 dropdownButton(
                                                                                     htmlOutput('pdf2_stats_comparison'),
                                                                                     circle = FALSE,
                                                                                     status = 'danger',
                                                                                     label = "Variable 2",
                                                                                     size = "sm",
                                                                                     icon = icon("file-pdf"),
                                                                                     width = "795px",
                                                                                     margin = "0px",
                                                                                     up = F,
                                                                                     right = F
                                                                                 )
                                                                )
                                                            )
                                                        ),
                                                        
                                                        
                                                        # OUTPUT : Graphique time series ========================
                                                        amChartsOutput(outputId = "amchart_ts",
                                                                       width = "100%")
                                                    )
                                                ),
                                                
                                                fluidRow(
                                                    
                                                    
                                                    
                                                    
                                                    # PANEL : Fenêtre accueillant le tableau des données ========
                                                    box(
                                                        width = 12,
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