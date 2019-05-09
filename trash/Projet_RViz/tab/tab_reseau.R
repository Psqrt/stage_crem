tab_reseau <- tabPanel("Clubs Network",
                       
                       visNetworkOutput("rs_network",
                                        height = "90%"
                       ),
                       
                       absolutePanel(id = "abspanel_left",
                                     fixed = TRUE,
                                     class = "panel panel-default",
                                     width = "400px",
                                     height = "auto",
                                     draggable = FALSE,
                                     top = 150,
                                     left = 50,
                                     
                                     # h2("LEFT"),
                                     
                                     pickerInput(
                                         inputId = "club_selection_rs",
                                         label = "Select a club",
                                         choices = unique(c(donnees_trans$Team_from, donnees_trans$Team_to)),
                                         selected = "FC Barcelona",
                                         options = list(
                                             'live-search' = TRUE
                                         )
                                     ),
                                     
                                     tags$br(),
                                     
                                     h4("List of positions traded:"),
                                     
                                     tableOutput("table_positions_flux")
                       ),
                       
                       absolutePanel(id = "abspanel_right",
                                     fixed = TRUE,
                                     class = "panel panel-default",
                                     width = "400px",
                                     height = "750px",
                                     draggable = TRUE,
                                     top = 150,
                                     right = 50,
                                     
                                     # h2("RIGHT"),
                                     
                                     plotOutput("line_budget",
                                                height = "230px"),
                                     
                                     plotOutput("line_nombre",
                                                height = "230px"),
                                     
                                     plotOutput("line_nombre_sep",
                                                height = "230px")
                                     
                       )
)