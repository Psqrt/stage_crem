tab_carto <- tabPanel("Transfers map",
                      
                      leafletOutput("map",
                                    height = "88%"),
                      
                      absolutePanel(
                          id = "abspanel_map_left",
                          fixed = TRUE,
                          class = "panel panel-default",
                          width = "auto",
                          height = "auto",
                          draggable = FALSE,
                          top = "15%",
                          left = "49%",
                          
                          fluidRow(
                              column(width = 2,
                                     
                                     dropdownButton(
                                         tags$h5("Market shares per season of the top 10 biggest Clubs"),
                                         
                                         plotOutput("marketshare"),
                                         circle = TRUE,
                                         status = 'danger',
                                         label = "G1",
                                         size = "xs",
                                         icon = NULL,
                                         width = "500px"
                                     )
                              ),
                              
                              column(width = 2,
                                     
                                     dropdownButton(
                                         tags$h5(textOutput("ligne0_titre_liste")),
                                         tags$h6(textOutput("ligne1_titre_liste")),
                                         tags$h6(textOutput("ligne2_titre_liste")),
                                         tags$h6(textOutput("ligne3_titre_liste")),
                                         
                                         tableOutput("top_player"),
                                         circle = TRUE,
                                         status = 'danger',
                                         label = "G2",
                                         size = "xs",
                                         icon = NULL,
                                         width = "400px"
                                     )
                              ),
                              
                              column(width = 2,
                                     
                                     dropdownButton(
                                         tags$h5(textOutput("titre_graphique_player")),
                                         
                                         plotOutput("evol",
                                         inline = TRUE),
                                         circle = TRUE,
                                         status = 'danger',
                                         label = "G3",
                                         size = "xs",
                                         icon = NULL,
                                         width = "500px"
                                     )
                              )
                          )
                      ),
                      
                      absolutePanel(
                          id = "abspanel_map_bottom",
                          fixed = TRUE,
                          class = "panel panel-default",
                          width = "auto",
                          height = "5%",
                          draggable = FALSE,
                          bottom = 30,
                          left = 12,
                          
                          radioGroupButtons(
                              inputId = "player_or_club_or_season",
                              label = "Select between:",
                              choices = c("Player", "Club", "Mercato"),
                              selected = "Mercato"
                          )
                      ),
                      
                      conditionalPanel(
                          condition = "input.player_or_club_or_season == 'Player'",
                          
                          absolutePanel(
                              id = "abspanel_map_bottom_player",
                              fixed = TRUE,
                              class = "panel panel-default",
                              width = "50%",
                              height = "5%",
                              draggable = FALSE,
                              bottom = 30,
                              left = 400,
                              
                              fluidRow(
                                  column(width = 3,
                                         pickerInput(
                                             inputId = "player_name",
                                             label = "Player: ",
                                             choices = c(unique(donnees_trans$Name)),
                                             selected = NA,
                                             options = list(
                                                 'live-search'=TRUE
                                             )
                                         )
                                  ),
                                  
                                  column(width = 3,
                                         actionButton(
                                             inputId = "recalc_player",
                                             label = "Confirm"),
                                         tags$style(type = 'text/css',
                                                    "#recalc_player { margin-top: 25px;}")
                                  )
                              )
                              
                          )
                      ),
                      
                      conditionalPanel(
                          condition = "input.player_or_club_or_season == 'Club'",
                          
                          absolutePanel(
                              id = "abspanel_map_bottom_club",
                              fixed = TRUE,
                              class = "panel panel-default",
                              width = "50%",
                              height = "5%",
                              draggable = FALSE,
                              bottom = 30,
                              left = 400,
                              
                              fluidRow(
                                  column(width = 3,
                                         pickerInput(
                                             inputId = "Club_name",
                                             label = "Club: ",
                                             choices = c(clubs_trans$Clubs),
                                             selected = NA,
                                             options = list(
                                                 'live-search' = TRUE
                                             )
                                         )
                                  ),
                                  
                                  column(width = 3,
                                         pickerInput(
                                             inputId = "season_pour_club",
                                             label = "Season(s): ",
                                             choices = seasons,
                                             multiple = TRUE,
                                             selected = seasons,
                                             options = list(
                                                 'actions-box' = TRUE
                                             )
                                         )
                                  ),
                                  
                                  column(width = 3,
                                         sliderInput(
                                             inputId = "price_pour_club",
                                             label = "Transfer fees",
                                             min = 0,
                                             max = max(donnees_trans$Transfer_fee),
                                             value = c(0, max(donnees_trans$Transfer_fee)
                                             )
                                         )
                                  ),
                                  
                                  column(width = 3,
                                         actionButton(
                                             inputId = "recalc_club",
                                             label = "Confirm"),
                                         tags$style(type = 'text/css',
                                                    "#recalc_club { margin-top: 25px;}")
                                         
                                  )
                              )
                          )
                      ),
                      
                      
                      conditionalPanel(
                          condition = "input.player_or_club_or_season == 'Mercato'",
                          
                          absolutePanel(
                              id = "abspanel_map_bottom_season",
                              fixed = TRUE,
                              class = "panel panel-default",
                              width = "50%",
                              height = "5%",
                              draggable = FALSE,
                              bottom = 30,
                              left = 400,
                              
                              fluidRow(
                                  column(width = 3,
                                         pickerInput(
                                             inputId = "Mercatos_choices",
                                             label = "Mercato: ",
                                             choices= list('Summer + Winter Mercatos' = seasons),
                                             selected = NA,
                                             multiple = TRUE,
                                             options = list(
                                                 'actions-box' = TRUE)
                                         )
                                  ),
                                  
                                  column(width = 3,
                                         sliderInput(
                                             inputId = "price_pour_season",
                                             label = "Transfer fees",
                                             min = 0,
                                             max = max(donnees_trans$Transfer_fee),
                                             value = c(0, max(donnees_trans$Transfer_fee))
                                         )
                                  ),
                                  
                                  column(width = 3,
                                         actionButton(
                                             inputId = "recalc_season",
                                             label = "Confirm"),
                                         tags$style(type = 'text/css',
                                                    "#recalc_season { margin-top: 25px;}")
                                         
                                  )
                              )
                          )
                      )
)