# LEXIQUE :
#    - INPUT : Élément de l'interface attendant un choix de l'utilisateur
#      OUTPUT : Élément de l'interface renvoyé par le côté serveur selon les inputs
#      PANEL : Élément de l'interface accueillant les inputs ou les outputs.

subtab_onglet3 = tabPanel("", # Chaine vide pour éviter un pop-up inutile lorsque le curseur est dans le body.
                          fluidPage(
                              tags$div(id="box_ggplot_scatter",
                                       
                                       # PANEL : Fenêtre acceuillant le graphique scatter plot =========
                                       box(
                                           width = 12,
                                           height = "900px",
                                           title = "SCATTER PLOT",
                                           solidHeader = TRUE,
                                           status = "primary",
                                           
                                           fluidRow(
                                               tags$div(
                                                   id = "pdf_col1_onglet3",
                                                   
                                                   column(
                                                       width = 2,
                                                       
                                                       conditionalPanel("input.choix_var1_onglet3 != 'XXXX'",
                                                                        
                                                                        # OUTPUT : Documentation PDF de la variable 1
                                                                        dropdownButton(
                                                                            htmlOutput('pdf1_onglet3'),
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
                                                   
                                                   conditionalPanel("input.choix_var2_onglet3 != 'XXXX'",
                                                                    
                                                                    # OUTPUT : Documentation PDF de la variable 2
                                                                    dropdownButton(
                                                                        htmlOutput('pdf2_onglet3'),
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
                                           
                                           # OUTPUT : Graphique Scatter plot ===========================
                                           plotlyOutput("plotly_scatter",
                                                        height = "800px")
                                       )
                                       
                              )
                          )
)