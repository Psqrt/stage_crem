# == Mise en commun des deux sources indiquant la dimension temporelle =================================
#        - Soit l'année, soit la période
#        - dans tous les cas, le résultat sera une liste (même une liste d'un élément)
liste_annee = reactive({
  if (input$switch_periode_map == TRUE){
    if (is.null(input$choix_periode)){
      c(0)
    } else {
      # print(input$choix_periode)
      c(as.numeric(substr(input$choix_periode, 1, 4)):as.numeric(substr(input$choix_periode, 6, 9)))
    }
  } else {
    # print(input$choix_periode)
    c(as.numeric(input$choix_annee))
  }
})


# == Update switch / var2 ==============================================================================
# ... réinitalisation de la variable 2 en "XXXX" lorsqu'on désactive la variable 2 (switch)

observeEvent(input$switch_var2_map, {updateSelectInput(session, "choix_variable_2_map", selected = "XXXX")})


# == Update liste déroulante en fonction du NUTS =======================================================
# Liste de toutes les variables H retenues (avec leurs labels) pour alimenter les listes déroulantes en NUTS 1 ou 2
# car les variables R et P ne sont pas renseignées pour les régions NUTS 1 et 2
# c'est-à-dire qu'on ne connait pas la région d'un individu (contrairement à la région d'un ménage qui est renseignée)
observeEvent(input$choix_nuts, {
  if (input$choix_nuts == "NUTS 0"){
    updateSelectInput(session, "choix_variable_1_map", 
                      choices = c("Select a variable" = "XXXX", liste_deroulante_map),
                      selected = input$choix_variable_1_map)
  } else {
    updateSelectInput(session, "choix_variable_1_map", 
                      choices = c("Select a variable" = "XXXX", liste_reduite),
                      selected = if_else(input$choix_variable_1_map %in% liste_reduite,
                                         input$choix_variable_1_map,
                                         "XXXX"))
  }
})



# == Update liste déroulante en fonction du NUTS =======================================================
# Liste de toutes les variables H retenues (avec leurs labels) pour alimenter les listes déroulantes en NUTS 1 ou 2
# car les variables R et P ne sont pas renseignées pour les régions NUTS 1 et 2
# c'est-à-dire qu'on ne connait pas la région d'un individu (contrairement à la région d'un ménage qui est renseignée)
observeEvent(input$choix_nuts, {
  if (input$choix_nuts == "NUTS 0"){
    updateSelectInput(session, "choix_variable_2_map", 
                      choices = c("Select a variable" = "XXXX", liste_deroulante_map),
                      selected = input$choix_variable_2_map)
  } else {
    updateSelectInput(session, "choix_variable_2_map", 
                      choices = c("Select a variable" = "XXXX", liste_reduite),
                      selected = if_else(input$choix_variable_2_map %in% liste_reduite,
                                         input$choix_variable_2_map,
                                         "XXXX"))
  }
})
# == Filtrage de la base ===============================================================================
# ... selon les inputs de l'utilisateur (niveau nuts, et année/période)
moyenne_region_filtre = reactive({
  if (input$switch_periode_map){
    moyenne_region %>% 
      filter(NUTS == input$choix_nuts &
               PERIODE == input$choix_periode)
  } else {
    moyenne_region %>%
      filter(NUTS == input$choix_nuts &
               ANNEE == input$choix_annee)
  }
})


# == PDF 1 =============================================================================================
output$pdf_doc_var1_map <- renderText({
  page = recode(substr(input$choix_variable_1_map, 1, 5), !!!dico_liste_variable_page)
  return(paste('<iframe style="height:500px; width:793px;" src="./pdf/', page, '.pdf', '"></iframe>', sep = ""))
})

# == PDF 2 =============================================================================================
output$pdf_doc_var2_map <- renderText({
  page = recode(substr(input$choix_variable_2_map, 1, 5), !!!dico_liste_variable_page)
  return(paste('<iframe style="height:500px; width:793px;" src="./pdf/', page, '.pdf', '"></iframe>', sep = ""))
})


# == Cartographie ======================================================================================

# 1. On identifie quelle norme utiliser, grâce à l'année de l'enquête (exemple : enquete 2004 = norme 2003).
choix_carte = reactive({
  paste("LISTE ANNEE DANS CHOIX CARTE : ", liste_annee()[1])
  annee_enquete = liste_annee()[1]
  if (annee_enquete < 2006){
    annee_carte = 2003
  } else if (annee_enquete >= 2006 & annee_enquete < 2010){
    annee_carte = 2006
  } else if (annee_enquete >= 2010 & annee_enquete < 2013){
    annee_carte = 2010
  } else if (annee_enquete >= 2013 & annee_enquete < 2016){
    annee_carte = 2013
  } else {
    annee_carte = 2016
  }
  nuts = substr(input$choix_nuts, 6, 6)
  paste0("data_map", annee_carte, "_nuts", nuts, sep = "")
})

# 2. Idem pour récupérer les frontières des pays.
choix_carte_front = reactive({
  paste("LISTE ANNEE DANS CHOIX CARTE : ", liste_annee()[1])
  annee_enquete = liste_annee()[1]
  if (annee_enquete < 2006){
    annee_carte = 2003
  } else if (annee_enquete >= 2006 & annee_enquete < 2010){
    annee_carte = 2006
  } else if (annee_enquete >= 2010 & annee_enquete < 2013){
    annee_carte = 2010
  } else if (annee_enquete >= 2013 & annee_enquete < 2016){
    annee_carte = 2013
  } else {
    annee_carte = 2016
  }
  paste0("data_map", annee_carte, "_nuts0_front", sep = "")
})

# 3. Paramètres globaux de la carte
# 3.1. Choix de la palette
pal <- colorNumeric("YlOrRd", NULL, na.color = "#F0F0F0", alpha = T)
# 3.2. Placement du centre de la carte à l'état initial
lng_init = 7.2231853
lat_init = 49.6014421
# 3.3. Choix du fond de carte
fond = "//{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png"
# autres fonds de carte :
# //{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png
# //server.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Light_Gray_Base/MapServer/tile/{z}/{y}/{x}

# 4. Render de la carte
# 4.1. Paramètres globaux
output$map <- renderLeaflet({
  leaflet(options = leafletOptions(zoomControl = FALSE)) %>%
    addTiles(urlTemplate = fond) %>%
    setView(lng = lng_init, lat = lat_init, zoom = 5)
})

# 4.2. Mise à jour dynamique de la carte
observe({
  variable_1_choisie = input$choix_variable_1_map    
  variable_2_choisie = input$choix_variable_2_map
  variable_1_choisie_na = str_replace(variable_1_choisie, "_moy", "_na")
  variable_2_choisie_na = str_replace(variable_2_choisie, "_moy", "_na")
  
  if (input$choix_variable_1_map != "XXXX"){
    if (input$choix_variable_2_map == "XXXX"){ # CAS VAR 1 OK VAR 2 PAS OK
      contenu_popup = sprintf("<center><b> %s </b></center><br>
                              <b>Surveyed Households :</b> %s<br>
                              <b>Surveyed People :</b> %s<br>
                              <b>Variable 1 : </b> %s (%1.2f%% NA)",
                              moyenne_region_filtre()$NOM_REGION,
                              format(moyenne_region_filtre()$NB_MENAGE, big.mark = ","),
                              format(moyenne_region_filtre()$NB_PERSONNE, big.mark = ","),
                              round(moyenne_region_filtre()[, variable_1_choisie], 2),
                              moyenne_region_filtre()[, variable_1_choisie_na])
    } else {
      contenu_popup = sprintf("<center><b> %s </b></center><br>
                              <b>Surveyed Households :</b> %s<br>
                              <b>Surveyed People :</b> %s<br>
                              <b>Variable 1 : </b> %s (%1.2f%% NA)<br>
                              <b>Variable 2 : </b> %s (%1.2f%% NA)", 
                              moyenne_region_filtre()$NOM_REGION,
                              format(moyenne_region_filtre()$NB_MENAGE, big.mark = ","),
                              format(moyenne_region_filtre()$NB_PERSONNE, big.mark = ","),
                              round(moyenne_region_filtre()[, variable_1_choisie], 2),
                              moyenne_region_filtre()[, variable_1_choisie_na],
                              round(moyenne_region_filtre()[, variable_2_choisie], 2),
                              moyenne_region_filtre()[, variable_2_choisie_na])
    }
    
    leafletProxy('map') %>% 
      clearShapes() %>% # on supprime les anciens tracés ...
      clearMarkers() %>% # on supprime les anciens cercles (2nde variable) ...
      addPolygons(data = get(choix_carte()), # ... pour en retracer d'autres
                  layerId = ~NUTS_ID,
                  color = "black",
                  weight = 0.3,
                  smoothFactor = 0,
                  popup = ~contenu_popup,
                  fillOpacity = 0.6,
                  fillColor = ~pal(moyenne_region_filtre()[, variable_1_choisie])) %>% 
      # highlightOptions = highlightOptions(color = "white", weight = 2, bringToFront = T)) %>%
      addPolylines(data = get(choix_carte_front()), # frontières des pays
                   weight = 2,
                   color = "black",
                   opacity = 0.8) %>% 
      # addCircleMarkers(data = moyenne_region_filtre(), # 2nde variable croisée
      #                  lng = ~LNG_CENTRE,
      #                  lat = ~LAT_CENTRE,
      #                  color = "red") %>% 
      clearControls() %>% # reset de la légende ...
      addLegend(pal = pal, # ... pour en remettre une à jour
                values = moyenne_region_filtre()[, variable_1_choisie], 
                title = "<center>LEGEND</center> <br> Variable 1",
                opacity = 2.0,
                na.label = "NA")
  } else {
    if (input$choix_variable_2_map != "XXXX"){
      contenu_popup = sprintf("<center><b> %s </b></center><br>
                              <b>Surveyed Households :</b> %s<br>
                              <b>Surveyed People :</b> %s<br>
                              <b>Variable 2 : </b> %s (%1.2f%% NA)",
                              moyenne_region_filtre()$NOM_REGION,
                              format(moyenne_region_filtre()$NB_MENAGE, big.mark = ","),
                              format(moyenne_region_filtre()$NB_PERSONNE, big.mark = ","),
                              round(moyenne_region_filtre()[, variable_2_choisie], 2),
                              moyenne_region_filtre()[, variable_2_choisie_na])
    } else {
      contenu_popup = ""
    }
    leafletProxy('map') %>% 
      clearShapes() %>% # on supprime les anciens tracés ...
      clearMarkers() %>% # on supprime les anciens cercles (2nde variable) ...
      clearControls() # reset de la légende ...
  }
  
  if (input$choix_variable_2_map != "XXXX"){
    calcul_radius = (2*(1 + (moyenne_region_filtre()[, variable_2_choisie]/max(moyenne_region_filtre()[, variable_2_choisie], na.rm = T)))**4)/(0.5*(as.integer(substr(input$choix_nuts, 6, 6)) + 1))
    leafletProxy('map') %>% 
      addCircleMarkers(data = moyenne_region_filtre(), # 2nde variable croisée
                       lng = ~LNG_CENTRE,
                       lat = ~LAT_CENTRE,
                       layerId = ~REGION,
                       stroke = T,
                       weight = 1.5,
                       color = "black",
                       fillColor = "white",
                       fillOpacity = if_else(is.na(calcul_radius), 0, 0.6),
                       opacity = if_else(is.na(calcul_radius), 0, 0.6),
                       radius = calcul_radius,
                       popup = ~contenu_popup)
  }
})


# == Panel informations de droite ======================================================================

observeEvent(input$choix_variable_1_map, {
  if (input$choix_variable_1_map == "XXXX" & input$choix_variable_2_map == "XXXX"){
    texte1 = "Select a variable ..."
    texte2 = "... then select a region."
    titre1 = ""
    titre2 = ""
    # 4. Les sorties ... cas initialisation et sélection de variable
    output$panel_droite_map_titre1 = renderUI({titre1})
    output$panel_droite_map_contenu1 = renderUI({HTML(texte1)})
    output$panel_droite_map_titre2 = renderUI({titre2})
    output$panel_droite_map_contenu2 = renderUI({HTML(texte2)})
  }
})

observeEvent(input$choix_variable_2_map, {
  if (input$choix_variable_1_map == "XXXX" & input$choix_variable_2_map == "XXXX"){
    texte1 = "Select a variable ..."
    texte2 = "... then select a region."
    titre1 = ""
    titre2 = ""
    # 4. Les sorties ... cas initialisation et sélection de variable
    output$panel_droite_map_titre1 = renderUI({titre1})
    output$panel_droite_map_contenu1 = renderUI({HTML(texte1)})
    output$panel_droite_map_titre2 = renderUI({titre2})
    output$panel_droite_map_contenu2 = renderUI({HTML(texte2)})
  }
})

observeEvent(input$map_marker_click, {
  # 1. Récupération de l'information du clic : quelle région a été pointée par l'utilisateur
  info_click <- input$map_marker_click
  source("contenu_panel_map.R", local = T, encoding = "UTF-8")
  
  # 4. Les sorties ... cas sélection région
  output$panel_droite_map_titre1 = renderUI({titre1})
  output$panel_droite_map_contenu1 = renderUI({HTML(texte1)})
  output$panel_droite_map_titre2 = renderUI({titre2})
  output$panel_droite_map_contenu2 = renderUI({HTML(texte2)})
  
  
})

observeEvent(input$map_shape_click, {
  
  # 1. Récupération de l'information du clic : quelle région a été pointée par l'utilisateur
  info_click <- input$map_shape_click
  
  source("contenu_panel_map.R", local = T, encoding = "UTF-8")
  
  if(exists("titre1")){
    # 4. Les sorties ... cas sélection région
    output$panel_droite_map_titre1 = renderUI({titre1})
    output$panel_droite_map_contenu1 = renderUI({HTML(texte1)})
    output$panel_droite_map_titre2 = renderUI({titre2})
    output$panel_droite_map_contenu2 = renderUI({HTML(texte2)})
  }
})
