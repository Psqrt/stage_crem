# LEXIQUE :
#    - INPUT : Élément de l'interface attendant un choix de l'utilisateur
#      OUTPUT : Élément de l'interface renvoyé par le coté serveur selon les inputs
#      PANEL : Élément de l'interface accueillant les inputs ou les outputs.

tab_homepage <- tabPanel("",
                         fluidRow(
                             tags$div(id = "homepage_contents", 
                                      
                                      box(
                                          width = 12,
                                          solidHeader = TRUE,
                                          status = "primary",
                                          
                                          column(width = 8,
                                                 
                                                 htmlOutput("presentation_homepage")),
                                          column(width = 4,
                                                 
                                                 # fluidRow(
                                                 htmlOutput("presentation_homepage_eusilc_titre"),
                                                 htmlOutput("presentation_homepage_img"),
                                                 # ),
                                                 fluidRow(
                                                     valueBox(value = 2003, 
                                                              subtitle = "Creation date", 
                                                              icon = icon("calendar-alt"),
                                                              color = "yellow",
                                                              width = 6),
                                                     valueBox(value = 35, 
                                                              subtitle = "Countries surveyed in 2019", 
                                                              icon = icon("globe"),
                                                              color = "orange",
                                                              width = 6)
                                                 ),
                                                 
                                                 fluidRow(
                                                     valueBox(value = "> 130,000",
                                                              subtitle = "Households surveyed", 
                                                              icon = icon("home"),
                                                              color = "blue",
                                                              width = 6),
                                                     valueBox(value = "> 270,000", 
                                                              subtitle = "People surveyed", 
                                                              icon = icon("user"),
                                                              color = "purple",
                                                              width = 6)
                                                 ),
                                                 htmlOutput("presentation_homepage_survey_text")
                                                 
                                          )
                                      )
                             )
                         )
)