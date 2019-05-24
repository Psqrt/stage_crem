subtab_onglet3 = tabPanel("",
                          fluidPage(
                              tags$div(id="box_ggplot_scatter",
                                       
                                       
                                       
                                       
                                       
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
                                                       
                                                       conditionalPanel(
                                                           "input.choix_var1_onglet3 != 'XXXX'",
                                                           
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
                                                   
                                                   conditionalPanel(
                                                       "input.choix_var2_onglet3 != 'XXXX'",
                                                       
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
                                           
                                           plotlyOutput("ggplot_scatter",height = "800px")
                                       )
                                       
                              )
                          )
)