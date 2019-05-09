tab_carto <- tabPanel("NOM ONGLET",
                      
                      
                      
                      leafletOutput("map",
                                    height = "1000px"),
                      
                      
                      absolutePanel(
                          id = "abspanel_map_left",
                          fixed = TRUE,
                          class = "panel panel-default",
                          width = "auto",
                          height = "auto",
                          top = "60px",
                          left = "240px",
                          draggable = TRUE,
                          
                          
                          dropdownButton(
                              label = "LISTE PARAMS",
                              width = "300px",
                              circle = FALSE,
                              tags$h3("TITRE ABS PANEL"),
                              
                              
                              radioGroupButtons(
                                  inputId = "Id073",
                                  label = "Label",
                                  choices = c("NUTS 0",
                                              "NUTS 1",
                                              "NUTS 2"),
                                  checkIcon = list(
                                      yes = tags$i(class = "fa fa-circle", 
                                                   style = "color: steelblue"),
                                      no = tags$i(class = "fa fa-circle-o", 
                                                  style = "color: steelblue"))
                              ),
                              
                              
                              
                              selectInput(
                                  inputId = "Id081",
                                  label = "VARIABLE A CHOISIR", 
                                  choices = c("leaking", "arrears", "warm")
                              ),
                              
                              selectInput(
                                  inputId = "Id081conditionel",
                                  label = "MODALITES VAR QUALI", 
                                  choices = c("Never", "Once", "At least once")
                              ),
                              
                              
                              
                              materialSwitch(
                                  inputId = "Id076",
                                  label = "PERIODE", 
                                  right = TRUE
                              ),
                              
                              
                              
                              sliderTextInput(
                                  inputId = "Id095",
                                  label = "Choose a letter:", 
                                  choices = c(2004:2013)
                              ),
                              
                              selectInput(
                                  inputId = "Id081conditionel2",
                                  label = "MODALITES PERIODES", 
                                  choices = c("2004-2009", "2010-2012")
                              ),
                              
                              
                              
                              
                              
                              prettyCheckbox(
                                  inputId = "Id023",
                                  label = "Colorbind safe", 
                                  value = FALSE,
                                  status = "primary",
                                  icon = icon("check"),
                                  fill = TRUE
                              ),
                              
                              prettyCheckbox(
                                  inputId = "Id023a",
                                  label = "NA proportion", 
                                  value = FALSE,
                                  status = "primary",
                                  icon = icon("check"),
                                  fill = TRUE
                              )
                              
                              
                              
                              
                          )
                      )
)