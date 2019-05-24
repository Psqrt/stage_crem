subtab_onglet2 = tabPanel("",
                          fluidPage(
                              tags$div(id="box_ggplot_ts",
                                       box(
                                           width = 12,
                                           height = "900px",
                                           title = "TIME SERIES",
                                           solidHeader = TRUE,
                                           status = "primary",
                                           
                                           
                                           fluidRow(
                                               column(
                                                   width = 2,
                                                   
                                                   conditionalPanel(
                                                       "input.choix_var_onglet2 != 'XXXX'",
                                                       
                                                       dropdownButton(
                                                           htmlOutput('pdf1_onglet2'),
                                                           circle = FALSE,
                                                           status = 'danger',
                                                           label = "Documentation Variable",
                                                           size = "sm",
                                                           icon = icon("file-pdf"),
                                                           width = "795px",
                                                           margin = "0px",
                                                           up = F
                                                       )
                                                   )
                                               )
                                           ),
                                           
                                           conditionalPanel(
                                               "input.choix_nuts_onglet2 == 'NUTS 0'",
                                               plotlyOutput("ggplot_all_countries",height = "800px")
                                           ),
                                           conditionalPanel(
                                               "input.choix_nuts_onglet2 != 'NUTS 0'",
                                               plotlyOutput("ggplot_country_regions",height = "800px")
                                           )
                                       )
                              )
                              
                          )
)