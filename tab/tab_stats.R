subtab_timeseries = tabPanel("Time series",
                             
                             absolutePanel(
                                 id = "testtest",
                                 fixed = FALSE,
                                 class = "panel panel-default",
                                 width = "590px",
                                 height = "auto",
                                 top = "60px",
                                 draggable = FALSE,
                                 # textOutput("texte2"),
                                 amChartsOutput(outputId = "amchart")
                                 # plotOutput("plot_test")
                             ),
                             
                             absolutePanel(
                                 id = "abspanel_ts_left",
                                 fixed = FALSE,
                                 class = "panel panel-default",
                                 width = "590px",
                                 height = "auto",
                                 top = "60px",
                                 right = "15px",
                                 draggable = FALSE,
                                 
                                 fluidRow(
                                     column(width = 4,
                                            
                                            materialSwitch(
                                                inputId = "switch_variable_stat",
                                                label = "Variable 2?", 
                                                value = FALSE,
                                                right = TRUE,
                                                status = "success"
                                            )
                                     ),
                                     column(width = 4,
                                            
                                            materialSwitch(
                                                inputId = "switch_region_stat",
                                                label = "Region 2?", 
                                                value = FALSE,
                                                right = TRUE,
                                                status = "success"
                                            )
                                     )
                                 ),
                                 
                                 
                                 
                                 selectInput(
                                     inputId = "choix_var_ts1",
                                     label = "VARIABLE 1",
                                     choices = c("Choose a variable" = "XXXX", liste_deroulante_map),
                                     selected = "XXXX",
                                     width = "555px"
                                 ),
                                 
                                 conditionalPanel(
                                     "input.switch_variable_stat == 1",
                                     selectInput(
                                         inputId = "choix_var_ts2",
                                         label = "VARIABLE 2",
                                     choices = c("Choose a variable" = "XXXX", liste_deroulante_map),
                                         selected = "XXXX",
                                         width = "555px"
                                     )
                                 ),
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 tags$div(id = "legend_fluidrow_ts",
                                          fluidRow(
                                              column(width = 4,
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
                                                                      
                                                                      selectInput(
                                                                          inputId = "choix_region_ts1a",
                                                                          label = "REGION 1",
                                                                          choices = c("Choose a country" = "XXXX", liste_nuts0_stat),
                                                                          width = "350px"
                                                                      )
                                                     ),
                                                     conditionalPanel("input.choix_nuts_ts1 == 'NUTS 1'",
                                                                      
                                                                      selectInput(
                                                                          inputId = "choix_region_ts1b",
                                                                          label = "REGION 1",
                                                                          choices = c("Choose a region" = "XXXX", liste_nuts1_stat),
                                                                          # selected = "FR",
                                                                          width = "350px"
                                                                      )
                                                     ),
                                                     conditionalPanel("input.choix_nuts_ts1 == 'NUTS 2'",
                                                                      
                                                                      selectInput(
                                                                          inputId = "choix_region_ts1c",
                                                                          label = "REGION 1",
                                                                          choices = c("Choose a region" = "XXXX", liste_nuts2_stat),
                                                                          # selected = "FR",
                                                                          width = "350px"
                                                                      )
                                                     )
                                              )
                                          ),
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          conditionalPanel(
                                              "input.switch_region_stat == 1",
                                              fluidRow(
                                                  column(width = 4,
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
                                                                          
                                                                          selectInput(
                                                                              inputId = "choix_region_ts2a",
                                                                              label = "REGION 2",
                                                                          choices = c("Choose a country" = "XXXX", liste_nuts0_stat),
                                                                              # selected = "FR",
                                                                              width = "350px"
                                                                          )
                                                         ),
                                                         conditionalPanel("input.choix_nuts_ts2 == 'NUTS 1'",
                                                                          
                                                                          selectInput(
                                                                              inputId = "choix_region_ts2b",
                                                                              label = "REGION 2",
                                                                          choices = c("Choose a region" = "XXXX", liste_nuts1_stat),
                                                                              # selected = "FR",
                                                                              width = "350px"
                                                                          )
                                                         ),
                                                         conditionalPanel("input.choix_nuts_ts2 == 'NUTS 2'",
                                                                          
                                                                          selectInput(
                                                                              inputId = "choix_region_ts2c",
                                                                              label = "REGION 2",
                                                                          choices = c("Choose a region" = "XXXX", liste_nuts2_stat),
                                                                              # selected = "FR",
                                                                              width = "350px"
                                                                          )
                                                         )
                                                  )
                                              )
                                          )
                                 )
                             )
)
