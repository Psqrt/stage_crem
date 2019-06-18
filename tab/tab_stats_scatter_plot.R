# LEXIQUE :
#    - INPUT : Élément de l'interface attendant un choix de l'utilisateur
#      OUTPUT : Élément de l'interface renvoyé par le coté serveur selon les inputs
#      PANEL : Élément de l'interface accueillant les inputs ou les outputs.

subtab_stats_scatter_plot = tabPanel("", # Chaine vide pour éviter un pop-up inutile lorsque le curseur est dans le body.
                          fluidPage(
                              tags$div(id="box_plotly_scatter",
                                       
                                       # PANEL : Fenêtre acceuillant le graphique scatter plot =========
                                       box(
                                           width = 12,
                                           height = "90vh",
                                           title = "SCATTER PLOT",
                                           solidHeader = TRUE,
                                           status = "primary",
                                           
                                           fluidRow(
                                               tags$div(
                                                   id = "pdf_col1_stats_scatter_plot",
                                                   
                                                   
                                                   tags$div(id="data_button_stats_scatter_plot",
                                                            
                                                            column(
                                                                width = 2,
                                                                
                                                                conditionalPanel("input.choix_var1_stats_scatter_plot != 'XXXX'",
                                                                                 
                                                                                 # OUTPUT : Documentation PDF de la variable 1
                                                                                 dropdownButton(
                                                                                     htmlOutput('pdf1_stats_scatter_plot'),
                                                                                     circle = FALSE,
                                                                                     status = 'danger',
                                                                                     label = "Documentation Variable 1",
                                                                                     size = "sm",
                                                                                     icon = icon("file-pdf"),
                                                                                     width = "795px",
                                                                                     margin = "0px",
                                                                                     up = F
                                                                                 )
                                                                )
                                                            )
                                                   ),
                                                   
                                                   column(
                                                       width = 2,
                                                       
                                                       conditionalPanel("input.choix_var2_stats_scatter_plot != 'XXXX'",
                                                                        
                                                                        # OUTPUT : Documentation PDF de la variable 2
                                                                        dropdownButton(
                                                                            htmlOutput('pdf2_stats_scatter_plot'),
                                                                            circle = FALSE,
                                                                            status = 'danger',
                                                                            label = "Documentation Variable 2",
                                                                            size = "sm",
                                                                            icon = icon("file-pdf"),
                                                                            width = "795px",
                                                                            margin = "0px",
                                                                            up = F
                                                                        )
                                                       )
                                                   )
                                               ),
                                               
                                               column(
                                                   width = 2,
                                                   
                                                   
                                                   conditionalPanel("input.choix_var1_stats_scatter_plot != 'XXXX' | input.choix_var2_stats_scatter_plot != 'XXXX'",
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
                                                                        
                                                                        dataTableOutput('table_scatter') # table data
                                                                    )
                                                   )
                                               )
                                           ),
                                           
                                           # OUTPUT : Graphique Scatter plot ===========================
                                           plotlyOutput("plotly_scatter",
                                                        height = "75vh")
                                       )
                                       
                              )
                          )
)