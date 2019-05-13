tab_carto <- tabPanel("NOM ONGLET",
                      
                      textOutput("texte"),
                      
                      leafletOutput("map",
                                    height = "1000px"),
                      
                      
                      absolutePanel(
                          id = "abspanel_map_left",
                          fixed = FALSE,
                          class = "panel panel-default",
                          width = "auto",
                          height = "auto",
                          top = "60px",
                          draggable = TRUE,
                          
                          
                          dropdownButton(
                              label = "LISTE PARAMS",
                              width = "300px",
                              circle = FALSE,
                              tags$h3("TITRE ABS PANEL"),
                              
                              
                              radioGroupButtons(
                                  inputId = "choix_nuts",
                                  label = "LEVEL:",
                                  choices = c("NUTS 0",
                                              "NUTS 1",
                                              "NUTS 2"),
                                  selected = "NUTS 0",
                                  checkIcon = list(
                                      yes = tags$i(class = "fa fa-circle", 
                                                   style = "color: steelblue"),
                                      no = tags$i(class = "fa fa-circle-o", 
                                                  style = "color: steelblue"))
                              ),
                              
                              
                              selectInput(
                                  inputId = "choix_variable_map",
                                  label = "INDICATOR", 
                                  choices = c(c("Warm" = "HH050", 
                                                "Arrears" = "HS021",
                                                "Leaking" = "HH040"))
                              ),
                              
                              selectInput(
                                  inputId = "choix_modalite_map",
                                  label = "MODALITE (PLUS TARD)", 
                                  choices = c("Never", "Once", "At least once")
                              ),
                              
                              
                              
                              materialSwitch(
                                  inputId = "switch_periode",
                                  label = "PERIOD", 
                                  value = FALSE,
                                  right = TRUE
                              ),
                              
                              
                              
                              conditionalPanel("input.switch_periode == 0",
                                               sliderTextInput(
                                                   inputId = "choix_annee",
                                                   label = "YEAR:", 
                                                   choices = c(2004:2013)
                                               )
                              ),
                              
                              conditionalPanel("input.switch_periode == 1",
                                               selectInput(
                                                   inputId = "choix_periode",
                                                   label = "PERIOD",
                                                   choices = c("2004-2005",
                                                               "2006-2009",
                                                               "2010-2012",
                                                               "2013-2015")
                                               )
                              )
                              
                              
                              
                              
                              
                              # prettyCheckbox(
                              #     inputId = "colorblind_safe",
                              #     label = "COLORBLIND SAFE", 
                              #     value = FALSE,
                              #     status = "primary",
                              #     icon = icon("check"),
                              #     fill = TRUE
                              # ),
                              
                              # prettyCheckbox(
                              #     inputId = "na_proportion",
                              #     label = "NA PROPORTION", 
                              #     value = FALSE,
                              #     status = "primary",
                              #     icon = icon("check"),
                              #     fill = TRUE
                              # )
                              
                              
                              
                              
                          )
                      )
)