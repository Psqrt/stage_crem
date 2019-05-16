tab_carto <- tabPanel("Map",
                      
                      leafletOutput("map",
                                    height = "100%"),
                      
                      
                      absolutePanel(
                          id = "abspanel_map_left",
                          fixed = FALSE,
                          class = "panel panel-default",
                          width = "auto",
                          height = "auto",
                          top = "60px",
                          draggable = FALSE,
                          
                          tags$div(id = "legend_fluidrow",
                                   fluidRow(
                                       column(width = 8,
                                              radioGroupButtons(
                                                  inputId = "choix_nuts",
                                                  label = "LEVEL",
                                                  choices = c("NUTS 0",
                                                              "NUTS 1",
                                                              "NUTS 2"),
                                                  selected = "NUTS 0",
                                                  checkIcon = list(
                                                      yes = tags$i(class = "fa fa-circle", 
                                                                   style = "color: steelblue"),
                                                      no = tags$i(class = "fa fa-circle-o", 
                                                                  style = "color: steelblue"))
                                              )
                                       ),
                                       
                                       column(width = 4,
                                              tags$div(id = "legend_switch",
                                                       materialSwitch(
                                                           inputId = "switch_periode",
                                                           label = "PERIOD", 
                                                           value = FALSE,
                                                           right = TRUE,
                                                           status = "success"
                                                       )
                                              )
                                       )
                                   )
                          ),
                                   
                          tags$div(id = "div_choix_variable_map",
                                   class = "div_cvm",
                                   selectInput(
                                       inputId = "choix_variable_map",
                                       label = "VARIABLE", 
                                       width = "430px",
                                       choices = liste_deroulante_map,
                                       selected = "HH050_moy"
                                   )
                          ),
                          
                          
                          
                          conditionalPanel("input.switch_periode == 0",
                                           tags$div(id = "div_choix_annee",
                                                    class = "div_ca",
                                                    sliderTextInput(
                                                        inputId = "choix_annee",
                                                        width = "430px",
                                                        label = "YEAR", 
                                                        choices = c(2004:2013)
                                                    )
                                           )
                          ),
                          
                          conditionalPanel("input.switch_periode == 1",
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
                      )
)