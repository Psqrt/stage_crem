# LEXIQUE :
#    - INPUT : Élément de l'interface attendant un choix de l'utilisateur
#      OUTPUT : Élément de l'interface renvoyé par le coté serveur selon les inputs
#      PANEL : Élément de l'interface accueillant les inputs ou les outputs.

tab_carto <- tabPanel("", # Chaine vide pour éviter un pop-up inutile lorsque le curseur est dans le body.
                      
                      # = OUTPUT : Carte Leaflet =======================================================
                      leafletOutput("map",
                                    height = "100%"),
                      # ================================================================================
                      
                      # PANEL : Fenêtre contenant le bouton PDF (documentation) ########################
                      absolutePanel(
                          id = "abspanel_map_bot",
                          fixed = FALSE,
                          class = "panel panel-default",
                          width = "auto",
                          height = "auto",
                          bottom = "0px",
                          draggable = FALSE,
                          
                          fluidRow(
                                     conditionalPanel('input.choix_variable_1_map != "XXXX"',
                                                      # INPUT : Bouton ouvrant ou fermant la documentation PDF de la variable ######
                                                      dropdownButton(
                                                          htmlOutput('pdf_doc_var1_map'),
                                                          circle = FALSE,
                                                          status = 'danger',
                                                          label = "Documentation 1",
                                                          size = "sm",
                                                          icon = icon("file-pdf"),
                                                          width = "795px",
                                                          margin = "0px",
                                                          up = T
                                                      )
                              ),
                                     
                                     conditionalPanel("input.choix_variable_2_map != 'XXXX' & input.switch_var2_map == 1",
                                                      # INPUT : Bouton ouvrant ou fermant la documentation PDF de la variable ######
                                                      dropdownButton(
                                                          htmlOutput('pdf_doc_var2_map'),
                                                          circle = FALSE,
                                                          status = 'danger',
                                                          label = "Documentation 2",
                                                          size = "sm",
                                                          icon = icon("file-pdf"),
                                                          width = "795px",
                                                          margin = "0px",
                                                          up = T
                                                      )
                                     )
                          )
                      ),
                          
                      # PANEL : Fenêtre contenant le bouton permettant d'accéder aux données supplémentaires
                      absolutePanel(
                          id = "abspanel_map_right_button",
                          fixed = FALSE,
                          class = "panel panel-default",
                          width = "auto",
                          height = "auto",
                          bottom = "0px",
                          right = "15px",
                          draggable = FALSE,
                          
                          # INPUT : Bouton ouvrant ou fermant la fenêtre contenant les données supplémentaires
                          actionBttn(
                              inputId = "infoplus",
                              label = "Information", 
                              style = "material-circle",
                              color = "primary",
                              icon = icon("plus-circle"),
                              size = "sm",
                              block = T
                          )
                      ),
                      
                      
                      # Afin de garder la fenêtre ouverte même lorsque l'utilisateur clique ailleurs (persistence),
                      # la condition pour faire apparaitre ou disparaitre la fenêtre se fera uniquement en fonction
                      # du nombre de clics sur le bouton (Id = infoplus).
                      # Le bouton comptabilise le nombre de clics et si celui-ci est pair (modulo 2), la fenetre est fermée,
                      # sinon, elle est ouverte.
                      # PANEL : Fenêtre contenant les données supplémentaires ==========================
                      conditionalPanel("(input.infoplus % 2) == 1", # Le % détermine le reste d'une division en javascript
                                       absolutePanel(
                                           id = "abspanel_map_right",
                                           fixed = FALSE,
                                           class = "panel panel-default",
                                           width = "470px",
                                           height = "auto",
                                           bottom = "40px",
                                           right = "15px",
                                           draggable = FALSE,
                                           
                                           # OUTPUT : Éléments à afficher dans la fenêtre des données supplémentaires.
                                           htmlOutput("panel_droite_map_titre1"),
                                           htmlOutput("panel_droite_map_contenu1"),
                                           tags$hr(),
                                           htmlOutput("panel_droite_map_titre2"),
                                           htmlOutput("panel_droite_map_contenu2")
                                       )
                      )
)