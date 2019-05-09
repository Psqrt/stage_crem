tab_joueurs <- tabPanel("Players", #nom de l'onglet (s'affiche dans la barre de navigation horizontale)
                        
                        # contenu de l'onglet
                        sidebarLayout(
                            # panel latéral
                            sidebarPanel(
                                
                                fluidRow( # format : 2 colonnes (6+6)
                                    column(width = 6,
                                           pickerInput( # choix du club
                                               inputId = "club_filtre",
                                               label = "Player's Club",
                                               choices = c("...", sort(unique(donnees_joueurs$Club))),
                                               selected = "...",
                                               options = list(
                                                   'live-search' = TRUE
                                               )
                                           ),
                                           
                                           pickerInput( # choix du pied préféré
                                               inputId = "foot_filtre",
                                               label = "Player's Preferred Foot",
                                               choices = c("...", sort(unique(donnees_joueurs$Preferred.Foot))),
                                               selected = "...",
                                               options = list(
                                                   'live-search' = TRUE
                                               )
                                           ),
                                           
                                           pickerInput( # choix de la nationalité
                                               inputId = "nationalite_filtre",
                                               label = "Player's Nationality",
                                               choices = c("...", sort(unique(donnees_joueurs$Nationality))),
                                               selected = "...",
                                               options = list(
                                                   'live-search' = TRUE
                                               )
                                           ),
                                           
                                           tags$strong("Profile parameters : characteristics"),
                                           
                                           dropdownButton( # bouton contenant un menu à ouvrir au clic
                                               circle = FALSE,
                                               status = "danger",
                                               icon = icon("user-circle"), #arrows
                                               width = "900px",
                                               
                                               
                                               # contenu du dropdownbutton
                                               
                                               fluidRow(
                                                   column(width = 10,
                                                          tags$h4("Field Characteristics"),
                                                          paste("Set a minimum value for each characteristic in order to filter players.")
                                                   ),
                                                   
                                                   column(width = 2,
                                                          div(style = "float:right", actionBttn( # bouton valider
                                                              inputId = "button_ok_characteristics",
                                                              label = "Submit",
                                                              style = "simple",
                                                              color = "success",
                                                              size = "sm"
                                                          )),
                                                          div(style = "float:right", actionBttn( # bouton réinitialiser
                                                              inputId = "button_reset_characteristics",
                                                              label = "Reset",
                                                              style = "simple",
                                                              color = "warning",
                                                              size = "sm"
                                                          ))
                                                   )
                                               ),
                                               
                                               checkboxInput( # choix afficher les sans-stats
                                                   inputId = "chars_non_assignes",
                                                   label = "Show Players without Characteristics only",
                                                   value = FALSE
                                               ),
                                               
                                               tags$hr(),
                                               tags$h4("Attacking"),
                                               fluidRow(
                                                   shinyjs::useShinyjs(), # permet de capter tous les inputs de ce fluidrow
                                                   id = "menu_char_select1", # yep
                                                   column(width = 2,
                                                          knobInput(
                                                              inputId = "crossing_char_filtre",
                                                              label = "Crossing",
                                                              value = 0,
                                                              min = 0,
                                                              max = 100,
                                                              displayPrevious = TRUE, 
                                                              lineCap = "round",
                                                              fgColor = "#428BCA",
                                                              inputColor = "#428BCA",
                                                              width = '90%',
                                                              height = '90%'
                                                          )
                                                   ),
                                                   column(width = 2,
                                                          knobInput(
                                                              inputId = "finishing_char_filtre",
                                                              label = "Finishing",
                                                              value = 0,
                                                              min = 0,
                                                              max = 100,
                                                              displayPrevious = TRUE, 
                                                              lineCap = "round",
                                                              fgColor = "#428BCA",
                                                              inputColor = "#428BCA",
                                                              width = '90%',
                                                              height = '90%'
                                                          )
                                                   ),
                                                   column(width = 2,
                                                          knobInput(
                                                              inputId = "headingaccuracy_char_filtre",
                                                              label = "HeadingAccuracy",
                                                              value = 0,
                                                              min = 0,
                                                              max = 100,
                                                              displayPrevious = TRUE, 
                                                              lineCap = "round",
                                                              fgColor = "#428BCA",
                                                              inputColor = "#428BCA",
                                                              width = '90%',
                                                              height = '90%'
                                                          )
                                                   ),
                                                   column(width = 2,
                                                          knobInput(
                                                              inputId = "shortpassing_char_filtre",
                                                              label = "Short Passing",
                                                              value = 0,
                                                              min = 0,
                                                              max = 100,
                                                              displayPrevious = TRUE, 
                                                              lineCap = "round",
                                                              fgColor = "#428BCA",
                                                              inputColor = "#428BCA",
                                                              width = '90%',
                                                              height = '90%'
                                                          )
                                                   ),
                                                   column(width = 2,
                                                          knobInput(
                                                              inputId = "volleys_char_filtre",
                                                              label = "Volleys",
                                                              value = 0,
                                                              min = 0,
                                                              max = 100,
                                                              displayPrevious = TRUE, 
                                                              lineCap = "round",
                                                              fgColor = "#428BCA",
                                                              inputColor = "#428BCA",
                                                              width = '90%',
                                                              height = '90%'
                                                          )
                                                   ),
                                                   column(width = 2)
                                               ),
                                               
                                               tags$hr(),
                                               tags$h4("Skill"),
                                               fluidRow(
                                                   shinyjs::useShinyjs(), # permet de capter tous les inputs de ce fluidrow
                                                   id = "menu_char_select2",
                                                   column(width = 2,
                                                          knobInput(
                                                              inputId = "dribbling_char_filtre",
                                                              label = "Dribbling",
                                                              value = 0,
                                                              min = 0,
                                                              max = 100,
                                                              displayPrevious = TRUE, 
                                                              lineCap = "round",
                                                              fgColor = "#428BCA",
                                                              inputColor = "#428BCA",
                                                              width = '90%',
                                                              height = '90%'
                                                          )
                                                   ),
                                                   column(width = 2,
                                                          knobInput(
                                                              inputId = "curve_char_filtre",
                                                              label = "Curve",
                                                              value = 0,
                                                              min = 0,
                                                              max = 100,
                                                              displayPrevious = TRUE, 
                                                              lineCap = "round",
                                                              fgColor = "#428BCA",
                                                              inputColor = "#428BCA",
                                                              width = '90%',
                                                              height = '90%'
                                                          )
                                                   ),
                                                   column(width = 2,
                                                          knobInput(
                                                              inputId = "fkaccuracy_char_filtre",
                                                              label = "FK Accuracy",
                                                              value = 0,
                                                              min = 0,
                                                              max = 100,
                                                              displayPrevious = TRUE, 
                                                              lineCap = "round",
                                                              fgColor = "#428BCA",
                                                              inputColor = "#428BCA",
                                                              width = '90%',
                                                              height = '90%'
                                                          )
                                                   ),
                                                   column(width = 2,
                                                          knobInput(
                                                              inputId = "longpassing_char_filtre",
                                                              label = "Long Passing",
                                                              value = 0,
                                                              min = 0,
                                                              max = 100,
                                                              displayPrevious = TRUE, 
                                                              lineCap = "round",
                                                              fgColor = "#428BCA",
                                                              inputColor = "#428BCA",
                                                              width = '90%',
                                                              height = '90%'
                                                          )
                                                   ),
                                                   column(width = 2,
                                                          knobInput(
                                                              inputId = "ballcontrol_char_filtre",
                                                              label = "Ball Control",
                                                              value = 0,
                                                              min = 0,
                                                              max = 100,
                                                              displayPrevious = TRUE, 
                                                              lineCap = "round",
                                                              fgColor = "#428BCA",
                                                              inputColor = "#428BCA",
                                                              width = '90%',
                                                              height = '90%'
                                                          )
                                                   ),
                                                   column(width = 2)
                                               ),
                                               
                                               tags$hr(),
                                               tags$h4("Movement"),
                                               fluidRow(
                                                   shinyjs::useShinyjs(), # permet de capter tous les inputs de ce fluidrow
                                                   id = "menu_char_select3",
                                                   column(width = 2,
                                                          knobInput(
                                                              inputId = "acceleration_char_filtre",
                                                              label = "Acceleration",
                                                              value = 0,
                                                              min = 0,
                                                              max = 100,
                                                              displayPrevious = TRUE, 
                                                              lineCap = "round",
                                                              fgColor = "#428BCA",
                                                              inputColor = "#428BCA",
                                                              width = '90%',
                                                              height = '90%'
                                                          )
                                                   ),
                                                   column(width = 2,
                                                          knobInput(
                                                              inputId = "sprintspeed_char_filtre",
                                                              label = "Sprint Speed",
                                                              value = 0,
                                                              min = 0,
                                                              max = 100,
                                                              displayPrevious = TRUE, 
                                                              lineCap = "round",
                                                              fgColor = "#428BCA",
                                                              inputColor = "#428BCA",
                                                              width = '90%',
                                                              height = '90%'
                                                          )
                                                   ),
                                                   column(width = 2,
                                                          knobInput(
                                                              inputId = "agility_char_filtre",
                                                              label = "Agility",
                                                              value = 0,
                                                              min = 0,
                                                              max = 100,
                                                              displayPrevious = TRUE, 
                                                              lineCap = "round",
                                                              fgColor = "#428BCA",
                                                              inputColor = "#428BCA",
                                                              width = '90%',
                                                              height = '90%'
                                                          )
                                                   ),
                                                   column(width = 2,
                                                          knobInput(
                                                              inputId = "reactions_char_filtre",
                                                              label = "Reactions",
                                                              value = 0,
                                                              min = 0,
                                                              max = 100,
                                                              displayPrevious = TRUE, 
                                                              lineCap = "round",
                                                              fgColor = "#428BCA",
                                                              inputColor = "#428BCA",
                                                              width = '90%',
                                                              height = '90%'
                                                          )
                                                   ),
                                                   column(width = 2,
                                                          knobInput(
                                                              inputId = "balance_char_filtre",
                                                              label = "Balance",
                                                              value = 0,
                                                              min = 0,
                                                              max = 100,
                                                              displayPrevious = TRUE, 
                                                              lineCap = "round",
                                                              fgColor = "#428BCA",
                                                              inputColor = "#428BCA",
                                                              width = '90%',
                                                              height = '90%'
                                                          )
                                                   ),
                                                   column(width = 2)
                                               ),
                                               
                                               tags$hr(),
                                               tags$h4("Power"),
                                               fluidRow(
                                                   shinyjs::useShinyjs(), # permet de capter tous les inputs de ce fluidrow
                                                   id = "menu_char_select4",
                                                   column(width = 2,
                                                          knobInput(
                                                              inputId = "shotpower_char_filtre",
                                                              label = "Shot Power",
                                                              value = 0,
                                                              min = 0,
                                                              max = 100,
                                                              displayPrevious = TRUE, 
                                                              lineCap = "round",
                                                              fgColor = "#428BCA",
                                                              inputColor = "#428BCA",
                                                              width = '90%',
                                                              height = '90%'
                                                          )
                                                   ),
                                                   column(width = 2,
                                                          knobInput(
                                                              inputId = "jumping_char_filtre",
                                                              label = "Jumping",
                                                              value = 0,
                                                              min = 0,
                                                              max = 100,
                                                              displayPrevious = TRUE, 
                                                              lineCap = "round",
                                                              fgColor = "#428BCA",
                                                              inputColor = "#428BCA",
                                                              width = '90%',
                                                              height = '90%'
                                                          )
                                                   ),
                                                   column(width = 2,
                                                          knobInput(
                                                              inputId = "stamina_char_filtre",
                                                              label = "Stamina",
                                                              value = 0,
                                                              min = 0,
                                                              max = 100,
                                                              displayPrevious = TRUE, 
                                                              lineCap = "round",
                                                              fgColor = "#428BCA",
                                                              inputColor = "#428BCA",
                                                              width = '90%',
                                                              height = '90%'
                                                          )
                                                   ),
                                                   column(width = 2,
                                                          knobInput(
                                                              inputId = "strength_char_filtre",
                                                              label = "Strength",
                                                              value = 0,
                                                              min = 0,
                                                              max = 100,
                                                              displayPrevious = TRUE, 
                                                              lineCap = "round",
                                                              fgColor = "#428BCA",
                                                              inputColor = "#428BCA",
                                                              width = '90%',
                                                              height = '90%'
                                                          )
                                                   ),
                                                   column(width = 2,
                                                          knobInput(
                                                              inputId = "longshots_char_filtre",
                                                              label = "Long Shots",
                                                              value = 0,
                                                              min = 0,
                                                              max = 100,
                                                              displayPrevious = TRUE, 
                                                              lineCap = "round",
                                                              fgColor = "#428BCA",
                                                              inputColor = "#428BCA",
                                                              width = '90%',
                                                              height = '90%'
                                                          )
                                                   ),
                                                   column(width = 2)
                                               ),
                                               
                                               tags$hr(),
                                               tags$h4("Mentality"),
                                               fluidRow(
                                                   shinyjs::useShinyjs(), # permet de capter tous les inputs de ce fluidrow
                                                   id = "menu_char_select5",
                                                   column(width = 2,
                                                          knobInput(
                                                              inputId = "aggression_char_filtre",
                                                              label = "Aggression",
                                                              value = 0,
                                                              min = 0,
                                                              max = 100,
                                                              displayPrevious = TRUE, 
                                                              lineCap = "round",
                                                              fgColor = "#428BCA",
                                                              inputColor = "#428BCA",
                                                              width = '90%',
                                                              height = '90%'
                                                          )
                                                   ),
                                                   column(width = 2,
                                                          knobInput(
                                                              inputId = "interceptions_char_filtre",
                                                              label = "Interceptions",
                                                              value = 0,
                                                              min = 0,
                                                              max = 100,
                                                              displayPrevious = TRUE, 
                                                              lineCap = "round",
                                                              fgColor = "#428BCA",
                                                              inputColor = "#428BCA",
                                                              width = '90%',
                                                              height = '90%'
                                                          )
                                                   ),
                                                   column(width = 2,
                                                          knobInput(
                                                              inputId = "positioning_char_filtre",
                                                              label = "Positioning",
                                                              value = 0,
                                                              min = 0,
                                                              max = 100,
                                                              displayPrevious = TRUE, 
                                                              lineCap = "round",
                                                              fgColor = "#428BCA",
                                                              inputColor = "#428BCA",
                                                              width = '90%',
                                                              height = '90%'
                                                          )
                                                   ),
                                                   column(width = 2,
                                                          knobInput(
                                                              inputId = "vision_char_filtre",
                                                              label = "Vision",
                                                              value = 0,
                                                              min = 0,
                                                              max = 100,
                                                              displayPrevious = TRUE, 
                                                              lineCap = "round",
                                                              fgColor = "#428BCA",
                                                              inputColor = "#428BCA",
                                                              width = '90%',
                                                              height = '90%'
                                                          )
                                                   ),
                                                   column(width = 2,
                                                          knobInput(
                                                              inputId = "penalties_char_filtre",
                                                              label = "Penalties",
                                                              value = 0,
                                                              min = 0,
                                                              max = 100,
                                                              displayPrevious = TRUE, 
                                                              lineCap = "round",
                                                              fgColor = "#428BCA",
                                                              inputColor = "#428BCA",
                                                              width = '90%',
                                                              height = '90%'
                                                          )
                                                   ),
                                                   column(width = 2,
                                                          knobInput(
                                                              inputId = "composure_char_filtre",
                                                              label = "Composure",
                                                              value = 0,
                                                              min = 0,
                                                              max = 100,
                                                              displayPrevious = TRUE,
                                                              lineCap = "round",
                                                              fgColor = "#428BCA",
                                                              inputColor = "#428BCA",
                                                              width = '90%',
                                                              height = '90%'
                                                          ))
                                               ),
                                               
                                               tags$hr(),
                                               tags$h4("Defending"),
                                               fluidRow(
                                                   shinyjs::useShinyjs(), # permet de capter tous les inputs de ce fluidrow
                                                   id = "menu_char_select6",
                                                   column(width = 2,
                                                          knobInput(
                                                              inputId = "marking_char_filtre",
                                                              label = "Marking",
                                                              value = 0,
                                                              min = 0,
                                                              max = 100,
                                                              displayPrevious = TRUE, 
                                                              lineCap = "round",
                                                              fgColor = "#428BCA",
                                                              inputColor = "#428BCA",
                                                              width = '90%',
                                                              height = '90%'
                                                          )
                                                   ),
                                                   column(width = 2,
                                                          knobInput(
                                                              inputId = "standingtackle_char_filtre",
                                                              label = "StandingTackle",
                                                              value = 0,
                                                              min = 0,
                                                              max = 100,
                                                              displayPrevious = TRUE, 
                                                              lineCap = "round",
                                                              fgColor = "#428BCA",
                                                              inputColor = "#428BCA",
                                                              width = '90%',
                                                              height = '90%'
                                                          )
                                                   ),
                                                   column(width = 2,
                                                          knobInput(
                                                              inputId = "slidingtackle_char_filtre",
                                                              label = "SlidingTackle",
                                                              value = 0,
                                                              min = 0,
                                                              max = 100,
                                                              displayPrevious = TRUE, 
                                                              lineCap = "round",
                                                              fgColor = "#428BCA",
                                                              inputColor = "#428BCA",
                                                              width = '90%',
                                                              height = '90%'
                                                          )
                                                   ),
                                                   column(width = 2),
                                                   column(width = 2),
                                                   column(width = 2)
                                               ),
                                               
                                               tags$h4("Goalkeeping Characteristics"),
                                               paste("Set a minimum value for each characteristic in order to filter players."),
                                               tags$hr(),
                                               fluidRow(
                                                   shinyjs::useShinyjs(), # permet de capter tous les inputs de ce fluidrow
                                                   id = "menu_char_select7",
                                                   column(width = 2,
                                                          knobInput(
                                                              inputId = "gkreflexes_char_filtre",
                                                              label = "GK Reflexes",
                                                              value = 0,
                                                              min = 0,
                                                              max = 100,
                                                              displayPrevious = TRUE, 
                                                              lineCap = "round",
                                                              fgColor = "#428BCA",
                                                              inputColor = "#428BCA",
                                                              width = '90%',
                                                              height = '90%'
                                                          )
                                                   ),
                                                   
                                                   column(width = 2,
                                                          knobInput(
                                                              inputId = "gkhandling_char_filtre",
                                                              label = "GK Handling",
                                                              value = 0,
                                                              min = 0,
                                                              max = 100,
                                                              displayPrevious = TRUE, 
                                                              lineCap = "round",
                                                              fgColor = "#428BCA",
                                                              inputColor = "#428BCA",
                                                              width = '90%',
                                                              height = '90%'
                                                          )
                                                   ),
                                                   
                                                   column(width = 2,
                                                          knobInput(
                                                              inputId = "gkkicking_char_filtre",
                                                              label = "GK Kicking",
                                                              value = 0,
                                                              min = 0,
                                                              max = 100,
                                                              displayPrevious = TRUE, 
                                                              lineCap = "round",
                                                              fgColor = "#428BCA",
                                                              inputColor = "#428BCA",
                                                              width = '90%',
                                                              height = '90%'
                                                          )
                                                   ),
                                                   
                                                   column(width = 2,
                                                          knobInput(
                                                              inputId = "gkpositioning_char_filtre",
                                                              label = "GK Positioning",
                                                              value = 0,
                                                              min = 0,
                                                              max = 100,
                                                              displayPrevious = TRUE, 
                                                              lineCap = "round",
                                                              fgColor = "#428BCA",
                                                              inputColor = "#428BCA",
                                                              width = '90%',
                                                              height = '90%'
                                                          )
                                                   ),
                                                   
                                                   column(width = 2,
                                                          knobInput(
                                                              inputId = "gkdiving_char_filtre",
                                                              label = "GK Diving",
                                                              value = 0,
                                                              min = 0,
                                                              max = 100,
                                                              displayPrevious = TRUE, 
                                                              lineCap = "round",
                                                              fgColor = "#428BCA",
                                                              inputColor = "#428BCA",
                                                              width = '90%',
                                                              height = '90%'
                                                          )
                                                   )
                                               ) # fin fluidrow
                                           ),
                                           
                                           tags$strong("Profile parameters : positioning"),
                                           
                                           dropdownButton( # bouton avec menu intérieur pour les positions
                                               circle = FALSE,
                                               status = "danger",
                                               icon = icon("arrows"), #arrows
                                               width = "300px",
                                               tooltip = "Click me to filter",
                                               
                                               # contenu du dropdownbutton
                                               tags$h4("List of Positioning Parameters"), # titre du petit menu
                                               tags$hr(), # trait horizontal pour séparation
                                               useSweetAlert(), # instruction espion pour deboggage
                                               actionLink("positions_selectall_button","Select All"), # bouton selectall
                                               actionLink("positions_unselectall_button","Unselect All"), # bouton unselectall
                                               
                                               checkboxInput( # choix considérer les sans-postes
                                                   inputId = "postes_non_assignes",
                                                   label = "Show Unassigned Players?",
                                                   value = TRUE
                                               ),
                                               
                                               checkboxGroupButtons(
                                                   inputId = "positions_ligne1",
                                                   choices = c(" ", liste_positions_ordre_terrain[1:3], " "),
                                                   individual = T,
                                                   selected = liste_positions_ordre_terrain[1:3],
                                                   justified = T,
                                                   status = 'danger'
                                               ),
                                               
                                               checkboxGroupButtons(
                                                   inputId = "positions_ligne2",
                                                   choices = c(" ", liste_positions_ordre_terrain[4:6], " "),
                                                   individual = T,
                                                   selected = liste_positions_ordre_terrain[4:6],
                                                   justified = T,
                                                   status = 'danger'
                                               ),
                                               
                                               checkboxGroupButtons(
                                                   inputId = "positions_ligne3",
                                                   choices = liste_positions_ordre_terrain[7:11],
                                                   individual = T,
                                                   selected = liste_positions_ordre_terrain[7:11],
                                                   justified = T,
                                                   status = 'warning'
                                               ),
                                               
                                               checkboxGroupButtons(
                                                   inputId = "positions_ligne4",
                                                   choices = liste_positions_ordre_terrain[12:16],
                                                   individual = T,
                                                   selected = liste_positions_ordre_terrain[12:16],
                                                   justified = T,
                                                   status = 'warning'
                                               ),
                                               
                                               checkboxGroupButtons(
                                                   inputId = "positions_ligne5",
                                                   choices = liste_positions_ordre_terrain[17:21],
                                                   individual = T,
                                                   selected = liste_positions_ordre_terrain[17:21],
                                                   justified = T,
                                                   status = 'warning'
                                               ),
                                               
                                               checkboxGroupButtons(
                                                   inputId = "positions_ligne6",
                                                   choices = liste_positions_ordre_terrain[22:26],
                                                   individual = T,
                                                   selected = liste_positions_ordre_terrain[22:26],
                                                   justified = T,
                                                   status = 'success'
                                               ),
                                               
                                               checkboxGroupButtons(
                                                   inputId = "positions_ligne7",
                                                   choices = liste_positions_ordre_terrain[27],
                                                   individual = T,
                                                   selected = liste_positions_ordre_terrain[27],
                                                   justified = T,
                                                   status = 'success'
                                               )
                                           ) # fin de dropdownButton
                                    ), # fin 1ere colonne taille 6
                                    
                                    column(width = 6,
                                           
                                           sliderInput( # choix score overall
                                               inputId = "overall_filtre",
                                               label = "Player's Overall Score",
                                               min = min(donnees_joueurs$Overall),
                                               max = max(donnees_joueurs$Overall),
                                               value = c(min(donnees_joueurs$Overall), max(donnees_joueurs$Overall))
                                           ),
                                           
                                           sliderInput( # choix score potential
                                               inputId = "potential_filtre",
                                               label = "Player's Potential Score",
                                               min = min(donnees_joueurs$Potential),
                                               max = max(donnees_joueurs$Potential),
                                               value = c(min(donnees_joueurs$Potential), max(donnees_joueurs$Potential))
                                           ),
                                           
                                           sliderInput( # choix age
                                               inputId = "age_filtre",
                                               label = "Player's Age",
                                               min = min(donnees_joueurs$Age),
                                               max = max(donnees_joueurs$Age),
                                               value = c(min(donnees_joueurs$Age), max(donnees_joueurs$Age))
                                           ),
                                           
                                           sliderInput( # choix value
                                               inputId = "value_filtre",
                                               label = "Player's Value ($ millions)",
                                               min = min(donnees_joueurs$Value),
                                               max = max(donnees_joueurs$Value),
                                               value = c(min(donnees_joueurs$Value), max(donnees_joueurs$Value))
                                           ),
                                           
                                           sliderInput( # choix wage
                                               inputId = "salaire_filtre",
                                               label = "Player's wage ($ thousands)",
                                               min = min(donnees_joueurs$Wage),
                                               max = max(donnees_joueurs$Wage),
                                               value = c(min(donnees_joueurs$Wage), max(donnees_joueurs$Wage))
                                           )
                                    ) # fin 2eme colonne taille 6
                                ) # fin du fluidrow 6+6
                                
                                
                            ), # fin de sidebarPanel
                            
                            mainPanel(
                                # tabsetPanel(
                                    # tabPanel(title = "Players List",
                                             
                                             # actionButton(inputId = "gotest",
                                             #              label = "GO TEST"),
                                             DT::dataTableOutput("tableau_joueurs_initial"), # table principale
                                             
                                             ##########################################################
                                             # POP-UP FICHE JOUEUR ####################################
                                             ##########################################################
                                             bsModal(
                                                 id = "fichejoueur",
                                                 # title = NA,
                                                 trigger = "xxx", # pas de trigger sauf clic sur ligne du joueur (xxx inexistant)
                                                 size = "large",
                                                 # STYLE HTML POUR MARGINS DU POPUP (BSMODAL)
                                                 tags$style(HTML("
                                .modal-content{
                                padding:20px 50px 50px 50px;
                                }")),
                                                 ####### CONTENU ############
                                                 fluidRow(title = "Summary",
                                                          column(width = 3,
                                                                 htmlOutput("fiche_joueur_photo") # les 
                                                          ),
                                                          
                                                          column(width = 5,
                                                                 tags$h1(textOutput("fiche_joueur_nom")),
                                                                 tags$h4(textOutput("fiche_joueur_id")),
                                                                 htmlOutput("fiche_joueur_nationalite")
                                                          ),
                                                          
                                                          column(width = 4,
                                                                 tags$h4(textOutput("fiche_joueur_age")), #, style = "padding-top:30px;"),
                                                                 tags$h4(textOutput("fiche_joueur_hauteur")),
                                                                 tags$h4(textOutput("fiche_joueur_poids")),
                                                                 tags$h4(textOutput("fiche_joueur_pied_fav")),
                                                                 tags$h4(textOutput("fiche_joueur_club_seul"))
                                                          )
                                                 ), # fin du fluidrow top
                                                 tags$hr(),
                                                 
                                                 tags$h3("Main Characteristics"),
                                                 
                                                 fluidRow(title = "Main Characteristics",
                                                          column(width = 3,
                                                                 tags$h5(textOutput("fiche_joueur_overall")),
                                                                 tags$h5(textOutput("fiche_joueur_potential")),
                                                                 tags$h5(textOutput("fiche_joueur_value"))
                                                          ),
                                                          
                                                          column(width = 5,
                                                                 tags$h5(htmlOutput("fiche_joueur_international")),
                                                                 tags$h5(htmlOutput("fiche_joueur_international2")),
                                                                 tags$h5(htmlOutput("fiche_joueur_weakfoot")),
                                                                 tags$h5(htmlOutput("fiche_joueur_skillmoves"))
                                                          ),
                                                          
                                                          column(width = 4,
                                                                 tags$h5(textOutput("fiche_joueur_workrate")),
                                                                 tags$h5(textOutput("fiche_joueur_bodytype"))
                                                          )
                                                          
                                                 ),
                                                 
                                                 tags$hr(),
                                                 
                                                 tags$h3("Club"),
                                                 
                                                 fluidRow(title = "Club",
                                                          column(width = 4,
                                                                 tags$h5(htmlOutput("fiche_joueur_club_double")),
                                                                 tags$h5(textOutput("fiche_joueur_position")),
                                                                 tags$h5(textOutput("fiche_joueur_jersey"))
                                                          ),
                                                          
                                                          column(width = 8,
                                                                 tags$h5(textOutput("fiche_joueur_salaire")),
                                                                 tags$h5(textOutput("fiche_joueur_joined")),
                                                                 tags$h5(textOutput("fiche_joueur_until")),
                                                                 tags$h5(textOutput("fiche_joueur_release"))
                                                          )
                                                          
                                                 ),
                                                 
                                                 tags$hr(),
                                                 
                                                 tags$h3("Profile"),
                                                 
                                                 # textOutput("tutututu"),
                                                 conditionalPanel(condition = "1 != 1", # bricolage de l'extreme pour cacher le switcheur
                                                                  selectInput(
                                                                      inputId = "invisible",
                                                                      label = "nope invis1 field ou gk",
                                                                      choices = c("...", "Field", "GK"),
                                                                      selected = "...",
                                                                      width = '100%'
                                                                  ),
                                                                  selectInput(
                                                                      inputId = "invisible2",
                                                                      label = "nope invis2 gk double ou solo",
                                                                      choices = c("...", "Double", "Solo"),
                                                                      selected = "...",
                                                                      width = '100%'
                                                                  ),
                                                                  selectInput(
                                                                      inputId = "invisible3",
                                                                      label = "nope invis3 field double ou solo",
                                                                      choices = c("...", "Double", "Solo"),
                                                                      selected = "...",
                                                                      width = '100%'
                                                                  )
                                                 ),
                                                 
                                                 conditionalPanel(condition = "input.invisible == 'GK'",
                                                                  tags$h5("Select another Goalkeeper to compare:"),
                                                                  # tags$h3("yo = gk"),
                                                                  fluidRow(
                                                                      column(width = 5,
                                                                             pickerInput(
                                                                                 inputId = "goalkeeper_comparaison",
                                                                                 # label = "Select another Goalkeeper to compare :", 
                                                                                 choices = c("...", donnees_joueurs_gk$ID),
                                                                                 choicesOpt = list(content = c("...", donnees_joueurs_gk$Choix)),
                                                                                 selected = "...",
                                                                                 options = list(
                                                                                     `live-search` = TRUE)
                                                                             )
                                                                      ),
                                                                      column(width = 7,
                                                                             actionButton(
                                                                                 inputId = "reset_gk_comparaison",
                                                                                 label = "Reset")
                                                                      )
                                                                  )
                                                                  
                                                 ),
                                                 
                                                 conditionalPanel(condition = "input.invisible == 'Field'",
                                                                  tags$h5("Select another Field player to compare:"),
                                                                  # tags$h3("yo not gk"),
                                                                  fluidRow(
                                                                      column(width = 5,
                                                                             pickerInput(
                                                                                 inputId = "field_comparaison",
                                                                                 # label = "Select another Player to compare :",
                                                                                 choices = c("...", donnees_joueurs_field$ID),
                                                                                 choicesOpt = list(content = c("...", donnees_joueurs_field$Choix)),
                                                                                 selected = "...",
                                                                                 options = list(
                                                                                     `live-search` = TRUE)
                                                                             )
                                                                      ),
                                                                      
                                                                      column(width = 7,
                                                                             actionButton(
                                                                                 inputId = "reset_field_comparaison",
                                                                                 label = "Reset"
                                                                             )
                                                                      )
                                                                  )
                                                 ),
                                                 
                                                 conditionalPanel(condition = "input.invisible2 == 'Solo' & input.invisible3 == 'Solo'",
                                                                  plotlyOutput("fiche_joueur_radar4")
                                                 ),
                                                 conditionalPanel(condition = "input.invisible2 == 'Double' & input.invisible == 'GK'",
                                                                  plotlyOutput("fiche_joueur_radar5")
                                                 ),
                                                 conditionalPanel(condition = "input.invisible3 == 'Double' & input.invisible == 'Field'",
                                                                  plotlyOutput("fiche_joueur_radar6")
                                                 ),
                                                 
                                                 tags$hr(),
                                                 
                                                 tags$h3("Position scores"),
                                                 
                                                 plotOutput("graph_terrain")
                                                 
                                             ) # fin du bsmodal
                                             ##########################################################
                                             # FIN POP-UP FICHE JOUEUR ################################
                                             ##########################################################
                                    ) # fin de tabPanel du mainpanel
                                # ) # fin de tabsetPanel du mainpanel
                            # ) # fin de mainPanel
                        ) # fin de sidebarLayout
) # fin de tabpanel

