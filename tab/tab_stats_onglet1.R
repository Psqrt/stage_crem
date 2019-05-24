subtab_onglet1 = tabPanel("onglet1",
                          fluidPage(
                              
                              tags$div(id = "premier_fluidrow_stat",
                                       fluidRow(
                                           box(
                                               width = 7,
                                               title = "TIME SERIES",
                                               solidHeader = TRUE,
                                               status = "primary",
                                               amChartsOutput(outputId = "amchart",
                                                              width = "100%")
                                           ),
                                           box(
                                               width = 5,
                                               title = "PARAMETERS",
                                               solidHeader = TRUE,
                                               status = "primary",
                                               height = "460px",
                                               
                                               tags$div(id = "parametre_ts_stat",
                                                        fluidRow(
                                                            column(width = 3,
                                                                   
                                                                   materialSwitch(
                                                                       inputId = "switch_variable_stat",
                                                                       label = "Variable 2", 
                                                                       value = FALSE,
                                                                       right = TRUE,
                                                                       status = "success"
                                                                   )
                                                            ),
                                                            column(width = 3,
                                                                   
                                                                   materialSwitch(
                                                                       inputId = "switch_region_stat",
                                                                       label = "Region 2", 
                                                                       value = FALSE,
                                                                       right = TRUE,
                                                                       status = "success"
                                                                   )
                                                            ),
                                                            
                                                            column(width = 3,
                                                                   
                                                                   
                                                                   tags$div(
                                                                       id = "panel_pdf1_onglet1", 
                                                                       conditionalPanel(
                                                                           "input.choix_var_ts1 != 'XXXX'",
                                                                           
                                                                           dropdownButton(
                                                                               htmlOutput('pdf1_onglet1'),
                                                                               circle = FALSE,
                                                                               status = 'danger',
                                                                               label = "Variable 1",
                                                                               size = "sm",
                                                                               icon = icon("file-pdf"),
                                                                               width = "795px",
                                                                               margin = "0px",
                                                                               up = F,
                                                                               right = T
                                                                           )
                                                                       )
                                                                   )
                                                            ),
                                                            
                                                            column(width = 3,
                                                                   
                                                                   
                                                                   tags$div(
                                                                       id = "panel_pdf2_onglet1", 
                                                                       conditionalPanel(
                                                                           "input.choix_var_ts2 != 'XXXX' & input.switch_variable_stat == 1",
                                                                           
                                                                           dropdownButton(
                                                                               htmlOutput('pdf2_onglet1'),
                                                                               circle = FALSE,
                                                                               status = 'danger',
                                                                               label = "Variable 2",
                                                                               size = "sm",
                                                                               icon = icon("file-pdf"),
                                                                               width = "795px",
                                                                               margin = "0px",
                                                                               up = F,
                                                                               right = T
                                                                           )
                                                                       )
                                                                   )
                                                            )
                                                            
                                                        ),
                                                        
                                                        
                                                        
                                                        selectInput(
                                                            inputId = "choix_var_ts1",
                                                            label = "VARIABLE 1",
                                                            choices = c("Choose a variable" = "XXXX", liste_deroulante_map),
                                                            selected = "XXXX",
                                                            width = "635px"
                                                        ),
                                                        
                                                        conditionalPanel(
                                                            "input.switch_variable_stat == 1",
                                                            selectInput(
                                                                inputId = "choix_var_ts2",
                                                                label = "VARIABLE 2",
                                                                choices = c("Choose a variable" = "XXXX", liste_deroulante_map),
                                                                selected = "XXXX",
                                                                width = "635px"
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
                                                                                                 width = "410px"
                                                                                             )
                                                                            ),
                                                                            conditionalPanel("input.choix_nuts_ts1 == 'NUTS 1'",
                                                                                             
                                                                                             selectInput(
                                                                                                 inputId = "choix_region_ts1b",
                                                                                                 label = "REGION 1",
                                                                                                 choices = c("Choose a region" = "XXXX", liste_nuts1_stat),
                                                                                                 # selected = "FR",
                                                                                                 width = "410px"
                                                                                             )
                                                                            ),
                                                                            conditionalPanel("input.choix_nuts_ts1 == 'NUTS 2'",
                                                                                             
                                                                                             selectInput(
                                                                                                 inputId = "choix_region_ts1c",
                                                                                                 label = "REGION 1",
                                                                                                 choices = c("Choose a region" = "XXXX", liste_nuts2_stat),
                                                                                                 # selected = "FR",
                                                                                                 width = "410px"
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
                                                                                                     width = "410px"
                                                                                                 )
                                                                                ),
                                                                                conditionalPanel("input.choix_nuts_ts2 == 'NUTS 1'",
                                                                                                 
                                                                                                 selectInput(
                                                                                                     inputId = "choix_region_ts2b",
                                                                                                     label = "REGION 2",
                                                                                                     choices = c("Choose a region" = "XXXX", liste_nuts1_stat),
                                                                                                     # selected = "FR",
                                                                                                     width = "410px"
                                                                                                 )
                                                                                ),
                                                                                conditionalPanel("input.choix_nuts_ts2 == 'NUTS 2'",
                                                                                                 
                                                                                                 selectInput(
                                                                                                     inputId = "choix_region_ts2c",
                                                                                                     label = "REGION 2",
                                                                                                     choices = c("Choose a region" = "XXXX", liste_nuts2_stat),
                                                                                                     # selected = "FR",
                                                                                                     width = "410px"
                                                                                                 )
                                                                                )
                                                                         )
                                                                     )
                                                                 )
                                                        )
                                               )
                                           )
                                           
                                       )
                              ),
                              #     )
                              # ),
                              
                              tags$div(id = "deuxieme_fluidrow_stat",
                                       fluidRow(
                                           box(
                                               width = 7,
                                               title = "BAR PLOT",
                                               solidHeader = TRUE,
                                               status = "primary",
                                               
                                               amChartsOutput(outputId = "barplot",
                                                              width = "100%")
                                           ),
                                           box(
                                               width = 5,
                                               title = "DATA",
                                               solidHeader = TRUE,
                                               status = "primary",
                                               DT::dataTableOutput("df_tableau_central")
                                           )
                                       )
                              )
                          )
)