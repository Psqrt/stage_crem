# LEXIQUE :
#    - INPUT : Élément de l'interface attendant un choix de l'utilisateur
#      OUTPUT : Élément de l'interface renvoyé par le côté serveur selon les inputs
#      PANEL : Élément de l'interface accueillant les inputs ou les outputs.

tab_carto <- tabPanel("", # Chaine vide pour éviter un pop-up inutile lorsque le curseur est dans le body.
                      
                      # = OUTPUT : Carte Leaflet =======================================================
                      leafletOutput("map",
                                    height = "100%"),
                      # ================================================================================
                      
                      # = PANEL : Fenêtre contenant les inputs utilisateur =============================
                      absolutePanel(
                          id = "abspanel_map_left",
                          fixed = FALSE,
                          class = "panel panel-default",
                          width = "auto",
                          height = "auto",
                          top = "60px",
                          draggable = FALSE,
                          
                          tags$div(id = "legend_fluidrow",
                                   fluidRow(
                                       column(width = 9,
                                              # = INPUT : Choix du niveau NUTS =========================
                                              radioGroupButtons(
                                                  inputId = "choix_nuts",
                                                  label = "LEVEL",
                                                  choices = c("NUTS 0",
                                                              "NUTS 1",
                                                              "NUTS 2"),
                                                  selected = "NUTS 0",
                                                  checkIcon = list(
                                                      yes = tags$i(class = "fa fa-circle", 
                                                                   style = "color: steelblue"),
                                                      no = tags$i(class = "fa fa-circle-o", 
                                                                  style = "color: steelblue"))
                                              )
                                       ),
                                       
                                       column(width = 1), # Pour simuler une marge entre les deux éléments
                                       
                                       column(width = 2,
                                              tags$div(id = "legend_switch",
                                                       # = INPUT : Choix du mode : ANNEE ou PERIODE ====
                                                       materialSwitch(
                                                           inputId = "switch_periode",
                                                           label = "PERIOD", 
                                                           value = FALSE,
                                                           right = TRUE,
                                                           status = "success"
                                                       )
                                              )
                                       )
                                   )
                          ),
                          
                          tags$div(id = "div_choix_variable_map",
                                   class = "div_cvm",
                                   # = INPUT : Choix de la variable à représenter ======================
                                   selectInput(
                                       inputId = "choix_variable_map",
                                       label = "VARIABLE", 
                                       width = "430px",
                                       choices = liste_deroulante_map,
                                       selected = "HH050_moy"
                                   )
                          ),
                          
                          
                          
                          conditionalPanel("input.switch_periode == 0", # Si le mode ANNEE est actif ===
                                           tags$div(id = "div_choix_annee",
                                                    class = "div_ca",
                                                    # = INPUT : Choix de l'année à représenter =========
                                                    sliderTextInput(
                                                        inputId = "choix_annee",
                                                        width = "430px",
                                                        label = "YEAR", 
                                                        choices = c(2004:2013) # NOTE : coder ce vecteur plus proprement.
                                                    )
                                           )
                          ),
                          
                          conditionalPanel("input.switch_periode == 1", # Si le mode PERIODE est actif =
                                           # = INPUT : Choix de la période à représenter ===============
                                           selectInput(
                                               inputId = "choix_periode",
                                               label = "PERIOD",
                                               width = "430px",
                                               choices = c("2004-2005",
                                                           "2006-2009",
                                                           "2010-2012",
                                                           "2013-2015")
                                           )
                          )
                      ),
                      # FIN PANEL : Fenêtre contenant les inputs utilisateur ###########################
                      
                      
                      # PANEL : Fenêtre contenant le bouton PDF (documentation) ########################
                      absolutePanel(
                          id = "abspanel_map_bot",
                          fixed = FALSE,
                          class = "panel panel-default",
                          width = "auto",
                          height = "auto",
                          bottom = "0px",
                          draggable = FALSE,
                          
                          # INPUT : Bouton ouvrant ou fermant la documentation PDF de la variable ######
                          dropdownButton(
                              htmlOutput('pdf_doc_var1_map'),
                              circle = TRUE,
                              status = 'danger',
                              label = "Documentation",
                              size = "sm",
                              icon = icon("file-pdf"),
                              width = "795px",
                              margin = "0px",
                              up = T
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
                                           width = "540px",
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