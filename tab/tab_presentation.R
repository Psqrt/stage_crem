# LEXIQUE :
#    - INPUT : Élément de l'interface attendant un choix de l'utilisateur
#      OUTPUT : Élément de l'interface renvoyé par le coté serveur selon les inputs
#      PANEL : Élément de l'interface accueillant les inputs ou les outputs.

tab_presentation <- tabPanel("",
                             fluidRow(
                                 tags$div(id = "presentation_contents", 
                                          
                                          box(
                                              width = 12,
                                              solidHeader = TRUE,
                                              status = "primary",
                                              
                                              # "a"
                                              htmlOutput("presentation")
                                              
                                          )
                                 )
                             )
)