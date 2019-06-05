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
  if (input$choix_variable_1_map != "XXXX"){
    if (input$choix_variable_2_map == "XXXX"){ # CAS VAR 1 OK VAR 2 PAS OK
      contenu_popup = sprintf("<center><b> %s </b></center><br> <b> Variable 1 : </b> %s", 
                              moyenne_region_filtre()$NOM_REGION, 
                              round(moyenne_region_filtre()[, variable_1_choisie], 2))
    } else {
      contenu_popup = sprintf("<center><b> %s </b></center><br> <b> Variable 1 : </b> %s <br>  <b> Variable 2 : </b> %s ", 
                              moyenne_region_filtre()$NOM_REGION, 
                              round(moyenne_region_filtre()[, variable_1_choisie], 2),
                              round(moyenne_region_filtre()[, variable_2_choisie], 2))
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
      contenu_popup = sprintf("<center><b> %s </b></center><br><b> Variable 2 : </b> %s ", 
                              moyenne_region_filtre()$NOM_REGION,
                              round(moyenne_region_filtre()[, variable_2_choisie], 2))
    } else {
      contenu_popup = ""
    }
    leafletProxy('map') %>% 
      clearShapes() %>% # on supprime les anciens tracés ...
      clearMarkers() %>% # on supprime les anciens cercles (2nde variable) ...
      clearControls() # reset de la légende ...
  }
  
  if (input$choix_variable_2_map != "XXXX"){
    calcul_radius = (20*(moyenne_region_filtre()[, variable_2_choisie]/max(moyenne_region_filtre()[, variable_2_choisie], na.rm = T))**4)/(0.5*(as.integer(substr(input$choix_nuts, 6, 6)) + 1))
    leafletProxy('map') %>% 
      addCircleMarkers(data = moyenne_region_filtre(), # 2nde variable croisée
                       lng = ~LNG_CENTRE,
                       lat = ~LAT_CENTRE,
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
  texte1 = "Choose a variable ..."
  texte2 = "... then choose a region."
  titre1 = ""
  titre2 = ""
  
  observeEvent(input$map_shape_click, {
    
    # 1. Récupération de l'information du clic : quelle région a été pointée par l'utilisateur
    info_click <- input$map_shape_click
    
    if (!is.null(info_click$id)){
      # 2. Filtrage de la base pour récupérer l'ensemble des données pour cette région à l'année T ou période P
      ligne_click = moyenne_region_filtre() %>% 
        filter(REGION == info_click$id)
      
      # 3. Affichage conditionnel en fonction de l'échelle actuelle
      if (input$choix_nuts == "NUTS 2"){
        
        ligne_donnees_2 = moyenne_region %>% 
          filter(ANNEE == ligne_click$ANNEE & 
                   REGION == substr(ligne_click$REGION, 1, 3))
        
        # En NUTS 2, donner des informations sur la région choisie et sur la région NUTS 1 qui l'englobe
        texte1 = paste("<table>",
                       "<tr><td><strong>Population</strong></td><td style = 'text-align: right'>", format(ligne_click$POPULATION, big.mark = ","), "inhabitants</td></tr>",
                       "<tr><td><strong>Density</strong></td><td style = 'text-align: right'>", format(round(ligne_click$DENSITE), big.mark = ","), "inhabitants/km²</td></tr>",
                       "<tr><td><strong>PIB par habitant</strong></td><td style = 'text-align: right'>", format(ligne_click$PIBH, big.mark = ","), "€/inhabitant/year</td></tr>",
                       "<tr><td><strong>Young people who permaturely left education</strong></td><td style = 'text-align: right'>", ligne_click$EDUC_JEUNE, "%</td></tr>",
                       "<tr><td><strong>People at risk of poverty or social exclusion</strong></td><td style = 'text-align: right'>", ligne_click$RISQUE_PAUVR_NB, "%</td></tr>",
                       "<tr><td><strong>Risk of poverty rate</strong></td><td style = 'text-align: right'>", ligne_click$RISQUE_PAUVR_TX, "%</td></tr>",
                       "<tr><td><strong>Unemployment rate</strong></td><td style = 'text-align: right'>", ligne_click$CHOMAGE_TX, "%</td></tr>",
                       "<tr><td><strong>Cooling degree days</strong></td><td style = 'text-align: right'>", ligne_click$DEGRES_JOUR_COLD, "</td></tr>",
                       "<tr><td><strong>Heating degree days</strong></td><td style = 'text-align: right'>", ligne_click$DEGRES_JOUR_HOT, "</td></tr>",
                       "</table>")
        
        texte2 = paste("<table>",
                       "<tr><td><strong>Population</strong></td><td style = 'text-align: right'>", format(ligne_donnees_2$POPULATION, big.mark = ","), "inhabitants</td></tr>",
                       "<tr><td><strong>Density</strong></td><td style = 'text-align: right'>", format(round(ligne_donnees_2$DENSITE), big.mark = ","), "inhabitants/km²</td></tr>",
                       "<tr><td><strong>PIB par habitant</strong></td><td style = 'text-align: right'>", format(ligne_donnees_2$PIBH, big.mark = ","), "€/inhabitant/year</td></tr>",
                       "<tr><td><strong>Young people who permaturely left education</strong></td><td style = 'text-align: right'>", ligne_donnees_2$EDUC_JEUNE, "%</td></tr>",
                       "<tr><td><strong>People at risk of poverty or social exclusion</strong></td><td style = 'text-align: right'>", ligne_donnees_2$RISQUE_PAUVR_NB, "%</td></tr>",
                       "<tr><td><strong>Risk of poverty rate</strong></td><td style = 'text-align: right'>", ligne_donnees_2$RISQUE_PAUVR_TX, "%</td></tr>",
                       "<tr><td><strong>Unemployment rate</strong></td><td style = 'text-align: right'>", ligne_donnees_2$CHOMAGE_TX, "%</td></tr>",
                       "<tr><td><strong>Cooling degree days</strong></td><td style = 'text-align: right'>", ligne_donnees_2$DEGRES_JOUR_COLD, "</td></tr>",
                       "<tr><td><strong>Heating degree days</strong></td><td style = 'text-align: right'>", ligne_donnees_2$DEGRES_JOUR_HOT, "</td></tr>",
                       "</table>")
        
        titre1 = tags$h4(ligne_click$NOM_REGION)
        titre2 = tags$h4(ligne_donnees_2$NOM_REGION)
      } else if (input$choix_nuts == "NUTS 1"){
        # En NUTS 1, donner des informations sur la région choisie et sur le pays qui l'englobe
        
        
        ligne_donnees_2 = moyenne_region %>% 
          filter(ANNEE == ligne_click$ANNEE & 
                   REGION == substr(ligne_click$REGION, 1, 2))
        
        texte1 = paste("<table>",
                       "<tr><td><strong>Population</strong></td><td style = 'text-align: right'>", format(ligne_click$POPULATION, big.mark = ","), "inhabitants</td></tr>",
                       "<tr><td><strong>Density</strong></td><td style = 'text-align: right'>", format(round(ligne_click$DENSITE), big.mark = ","), "inhabitants/km²</td></tr>",
                       "<tr><td><strong>GDP per capita</strong></td><td style = 'text-align: right'>", format(ligne_click$PIBH, big.mark = ","), "€/inhabitant/year</td></tr>",
                       "<tr><td><strong>Young people who permaturely left education</strong></td><td style = 'text-align: right'>", ligne_click$EDUC_JEUNE, "%</td></tr>",
                       "<tr><td><strong>People at risk of poverty or social exclusion</strong></td><td style = 'text-align: right'>", ligne_click$RISQUE_PAUVR_NB, "%</td></tr>",
                       "<tr><td><strong>Risk of poverty rate</strong></td><td style = 'text-align: right'>", ligne_click$RISQUE_PAUVR_TX, "%</td></tr>",
                       "<tr><td><strong>Unemployment rate</strong></td><td style = 'text-align: right'>", ligne_click$CHOMAGE_TX, "%</td></tr>",
                       "<tr><td><strong>Cooling degree days</strong></td><td style = 'text-align: right'>", ligne_click$DEGRES_JOUR_COLD, "</td></tr>",
                       "<tr><td><strong>Heating degree days</strong></td><td style = 'text-align: right'>", ligne_click$DEGRES_JOUR_HOT, "</td></tr>",
                       "</table>")
        
        texte2 = paste("<table>",
                       "<tr><td><strong>Population</strong></td><td style = 'text-align: right'>", format(ligne_donnees_2$POPULATION, big.mark = ","), "inhabitants</td></tr>",
                       "<tr><td><strong>Density</strong></td><td style = 'text-align: right'>", format(round(ligne_donnees_2$DENSITE), big.mark = ","), "inhabitants/km²</td></tr>",
                       "<tr><td><strong>GDP per capita</strong></td><td style = 'text-align: right'>", format(ligne_donnees_2$PIBH, big.mark = ","), "€/inhabitant/year</td></tr>",
                       "<tr><td><strong>Young people who permaturely left education</strong></td><td style = 'text-align: right'>", ligne_donnees_2$EDUC_JEUNE, "%</td></tr>",
                       "<tr><td><strong>People at risk of poverty or social exclusion</strong></td><td style = 'text-align: right'>", ligne_donnees_2$RISQUE_PAUVR_NB, "%</td></tr>",
                       "<tr><td><strong>Risk of poverty rate</strong></td><td style = 'text-align: right'>", ligne_donnees_2$RISQUE_PAUVR_TX, "%</td></tr>",
                       "<tr><td><strong>Unemployment rate</strong></td><td style = 'text-align: right'>", ligne_donnees_2$CHOMAGE_TX, "%</td></tr>",
                       "<tr><td><strong>Cooling degree days</strong></td><td style = 'text-align: right'>", ligne_donnees_2$DEGRES_JOUR_COLD, "</td></tr>",
                       "<tr><td><strong>Heating degree days</strong></td><td style = 'text-align: right'>", ligne_donnees_2$DEGRES_JOUR_HOT, "</td></tr>",
                       "</table>")
        
        titre1 = tags$h4(ligne_click$NOM_REGION)
        titre2 = tags$h4(ligne_donnees_2$NOM_REGION)
        
      } else if (input$choix_nuts == "NUTS 0"){
        # En NUTS 0, donner des informations sur le pays choisi et sur l'Europe
        
        moyenne_region_eu28_filtre = moyenne_region_eu28 %>% 
          filter(ANNEE == ligne_click$ANNEE)
        
        texte1 = paste("<table>",
                       "<tr><td><strong>Population</strong></td><td style = 'text-align: right'>", format(ligne_click$POPULATION, big.mark = ","), "inhabitants</td></tr>",
                       "<tr><td><strong>Density</strong></td><td style = 'text-align: right'>", format(round(ligne_click$DENSITE), big.mark = ","), "inhabitants/km²</td></tr>",
                       "<tr><td><strong>GDP per capita</strong></td><td style = 'text-align: right'>", format(ligne_click$PIBH, big.mark = ","), "€/inhabitant/year</td></tr>",
                       "<tr><td><strong>Young people who permaturely left education</strong></td><td style = 'text-align: right'>", ligne_click$EDUC_JEUNE, "%</td></tr>",
                       "<tr><td><strong>People at risk of poverty or social exclusion</strong></td><td style = 'text-align: right'>", ligne_click$RISQUE_PAUVR_NB, "%</td></tr>",
                       "<tr><td><strong>Risk of poverty rate</strong></td><td style = 'text-align: right'>", ligne_click$RISQUE_PAUVR_TX, "%</td></tr>",
                       "<tr><td><strong>Unemployment rate</strong></td><td style = 'text-align: right'>", ligne_click$CHOMAGE_TX, "%</td></tr>",
                       "<tr><td><strong>Cooling degree days</strong></td><td style = 'text-align: right'>", ligne_click$DEGRES_JOUR_COLD, "</td></tr>",
                       "<tr><td><strong>Heating degree days</strong></td><td style = 'text-align: right'>", ligne_click$DEGRES_JOUR_HOT, "</td></tr>",
                       "</table>")
        
        texte2 = paste("<table>",
                       "<tr><td><strong>Population</strong></td><td style = 'text-align: right'>", format(moyenne_region_eu28_filtre$POPULATION, big.mark = ","), "inhabitants</td></tr>",
                       "<tr><td><strong>Density</strong></td><td style = 'text-align: right'>", format(round(moyenne_region_eu28_filtre$DENSITE), big.mark = ","), "inhabitants/km²</td></tr>",
                       "<tr><td><strong>GDP per capita</strong></td><td style = 'text-align: right'>", format(moyenne_region_eu28_filtre$PIBH, big.mark = ","), "€/inhabitant/year</td></tr>",
                       "<tr><td><strong>Young people who permaturely left education</strong></td><td style = 'text-align: right'>", moyenne_region_eu28_filtre$EDUC_JEUNE, "%</td></tr>",
                       "<tr><td><strong>People at risk of poverty or social exclusion</strong></td><td style = 'text-align: right'>", moyenne_region_eu28_filtre$RISQUE_PAUVR_NB, "%</td></tr>",
                       "<tr><td><strong>Risk of poverty rate</strong></td><td style = 'text-align: right'>", moyenne_region_eu28_filtre$RISQUE_PAUVR_TX, "%</td></tr>",
                       "<tr><td><strong>Unemployment rate</strong></td><td style = 'text-align: right'>", moyenne_region_eu28_filtre$CHOMAGE_TX, "%</td></tr>",
                       "<tr><td><strong>Cooling degree days</strong></td><td style = 'text-align: right'>", moyenne_region_eu28_filtre$DEGRES_JOUR_COLD, "</td></tr>",
                       "<tr><td><strong>Heating degree days</strong></td><td style = 'text-align: right'>", moyenne_region_eu28_filtre$DEGRES_JOUR_HOT, "</td></tr>",
                       "</table>")
        
        titre1 = tags$h4(ligne_click$NOM_REGION)
        titre2 = tags$h4("Europe")
        
        
        if (input$choix_variable_1_map == "XXXX"){
          texte1 = "Choose a variable ..."
          texte2 = "... then choose a region."
          titre1 = ""
          titre2 = ""
        }
        
        
      }
      
    }
    # 4. Les sorties ... cas sélection région
    output$panel_droite_map_titre1 = renderUI({titre1})
    output$panel_droite_map_contenu1 = renderUI({HTML(texte1)})
    output$panel_droite_map_titre2 = renderUI({titre2})
    output$panel_droite_map_contenu2 = renderUI({HTML(texte2)})
  })
  
  
  # 4. Les sorties ... cas initialisation et sélection de variable
  output$panel_droite_map_titre1 = renderUI({titre1})
  output$panel_droite_map_contenu1 = renderUI({HTML(texte1)})
  output$panel_droite_map_titre2 = renderUI({titre2})
  output$panel_droite_map_contenu2 = renderUI({HTML(texte2)})
  
})