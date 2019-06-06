# LEXIQUE :
#    - INPUT : Élément de l'interface attendant un choix de l'utilisateur
#      OUTPUT : Élément de l'interface renvoyé par le coté serveur selon les inputs
#      PANEL : Élément de l'interface accueillant les inputs ou les outputs.

subtab_onglet2 = tabPanel("", # Chaine vide pour éviter un pop-up inutile lorsque le curseur est dans le body.
                          fluidPage(
                              tags$div(id="box_ggplot_ts",
                                       
                                       # PANEL : Fenêtre accueillant le graphique time series ==========
                                       box(
                                           width = 12,
                                           height = "900px",
                                           title = "TIME SERIES",
                                           solidHeader = TRUE,
                                           status = "primary",
                                           
                                           
                                           conditionalPanel("input.choix_var_onglet2 != 'XXXX'",
                                                            tags$div(id="data_button_onglet2",
                                                                     # OUTPUT : Documentation PDF de la variable
                                                                     dropdownButton(
                                                                         circle = FALSE,
                                                                         status = 'danger',
                                                                         label = "Documentation Variable",
                                                                         size = "sm",
                                                                         icon = icon("file-pdf"),
                                                                         width = "795px",
                                                                         margin = "0px",
                                                                         up = F,
                                                                         
                                                                         htmlOutput('pdf1_onglet2') # PDF
                                                                     )
                                                            ),
                                                            
                                                            # OUTPUT : Table des données filtrées
                                                            dropdownButton(
                                                                circle = FALSE,
                                                                status = 'primary',
                                                                label = "Data",
                                                                size = "sm",
                                                                icon = icon("database"),
                                                                width = "795px",
                                                                margin = "0px",
                                                                up = F,
                                                                
                                                                dataTableOutput('table_ts') # table data
                                                            )
                                           ),
                                           
                                           conditionalPanel("input.choix_nuts_onglet2 == 'NUTS 0'",
                                                            # OUTPUT : Graphique si on est à l'échelle des pays
                                                            plotlyOutput("plotly_ts_nuts0",height = "800px")
                                           ),
                                           conditionalPanel("input.choix_nuts_onglet2 != 'NUTS 0'",
                                                            # OUTPUT : Graphique si on n'est pas à 'échelle des pays
                                                            plotlyOutput("plotly_ts_nuts12",height = "800px")
                                           )
                                       )
                              )
                              
                          )
)