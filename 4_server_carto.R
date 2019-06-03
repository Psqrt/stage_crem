# == Mise en commun des deux sources indiquant la dimension temporelle =================================
#        - Soit l'année, soit la période
#        - dans tous les cas, le résultat sera une liste (même une liste d'un élément)
liste_annee = reactive({
  if (input$switch_periode == TRUE){
    if (is.null(input$choix_periode)){
      c(0)
    } else {
      print(input$choix_periode)
      c(as.numeric(substr(input$choix_periode, 1, 4)):as.numeric(substr(input$choix_periode, 6, 9)))
    }
  } else {
    print(input$choix_periode)
    c(as.numeric(input$choix_annee))
  }
})

# == Filtrage de la base ===============================================================================
# ... selon les inputs de l'utilisateur (niveau nuts, et année/période)
moyenne_region_filtre = reactive({
  if (input$switch_periode){
    moyenne_region %>% 
      filter(NUTS == input$choix_nuts &
               PERIODE == input$choix_periode)
  } else {
    moyenne_region %>%
      filter(NUTS == input$choix_nuts &
               ANNEE == input$choix_annee)
  }
})


# == PDF ===============================================================================================
output$pdf_doc_var1_map <- renderText({
  page = recode(substr(input$choix_variable_map, 1, 5), !!!dico_liste_variable_page)
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
  variable_choisie = input$choix_variable_map
  
  leafletProxy('map') %>% 
    clearShapes() %>% # on supprime les anciens tracés ...
    addPolygons(data = get(choix_carte()), # ... pour en retracer d'autres
                layerId = ~NUTS_ID,
                color = "black",
                weight = 0.3,
                smoothFactor = 0,
                popup = ~sprintf("<b> %s : </b> %s", moyenne_region_filtre()$NOM_REGION, round(moyenne_region_filtre()[, variable_choisie], 2)),
                fillOpacity = 0.6,
                fillColor = ~pal(moyenne_region_filtre()[, variable_choisie]),
                highlightOptions = highlightOptions(color = "white", weight = 2, bringToFront = T)) %>% 
    addPolylines(data = get(choix_carte_front()), # frontières des pays
                 weight = 2,
                 color = "black",
                 opacity = 0.8) %>% 
    clearControls() %>% # reset de la légende ...
    addLegend(pal = pal, # ... pour en remettre une à jour
              values = moyenne_region_filtre()[, variable_choisie], 
              title = "LEGEND",
              opacity = 2.0,
              na.label = "NA")
})


# == Panel informations de droite ======================================================================
observeEvent(input$map_shape_click, {
  
  # 1. Récupération de l'information du clic : quelle région a été pointée par l'utilisateur
  info_click <- input$map_shape_click
  
  if (!is.null(info_click$id)){
    # 2. Filtrage de la base pour récupérer l'ensemble des données pour cette région à l'année T ou période P
    ligne_click = moyenne_region_filtre() %>% 
      filter(REGION == info_click$id)
    
    print(ligne_click)
    
    # liste_noms = c("POPULATION", # (1)
    #            "DENSITE", # (2)
    #            "PIBH", # (3)
    #            "EDUC_JEUNE", # (4)
    #            "RISQUE_PAUVR_NB", # (5)
    #            "RISQUE_PAUVR_TX", # (6)
    #            "CHOMAGE_TX", # (7)
    #            "DEGRES_JOUR_COLD", # (8)
    #            "DEGRES_JOUR_HOT") # (9)
    
    
    # 3. Affichage conditionnel en fonction de l'échelle actuelle
    if (input$choix_nuts == "NUTS 2"){
      
      ligne_donnees_2 = moyenne_region %>% 
        filter(ANNEE == ligne_click$ANNEE & 
                 REGION == substr(ligne_click$REGION, 1, 3))
      
      # En NUTS 2, donner des informations sur la région choisie et sur la région NUTS 1 qui l'englobe
      texte1 = paste("<table>",
                     "<tr><td><strong>Population</strong></td><td style = 'text-align: right'>", ligne_click$POPULATION, "habitants</td></tr>",
                     "<tr><td><strong>Densité</strong></td><td style = 'text-align: right'>", ligne_click$DENSITE, "habitants/km²</td></tr>",
                     "<tr><td><strong>PIB par habitant</strong></td><td style = 'text-align: right'>", ligne_click$PIBH, "€/habitant/an</td></tr>",
                     "<tr><td><strong>Jeunes ayant quitté prématurément l'éducation</strong></td><td style = 'text-align: right'>", ligne_click$EDUC_JEUNE, "%</td></tr>",
                     "<tr><td><strong>Personnes en risque de pauvreté ou d'exclusion sociale</strong></td><td style = 'text-align: right'>", ligne_click$RISQUE_PAUVR_NB, "%</td></tr>",
                     "<tr><td><strong>Taux de risque de pauvreté</strong></td><td style = 'text-align: right'>", ligne_click$RISQUE_PAUVR_TX, "%</td></tr>",
                     "<tr><td><strong>Taux de chômage</strong></td><td style = 'text-align: right'>", ligne_click$CHOMAGE_TX, "%</td></tr>",
                     "<tr><td><strong>Degré-jours de refroidissement</strong></td><td style = 'text-align: right'>", ligne_click$DEGRES_JOUR_COLD, "</td></tr>",
                     "<tr><td><strong>Degré-jours de chauffage</strong></td><td style = 'text-align: right'>", ligne_click$DEGRES_JOUR_HOT, "</td></tr>",
                     "</table>")
      
      texte2 = paste("<table>",
                     "<tr><td><strong>Population</strong></td><td style = 'text-align: right'>", ligne_donnees_2$POPULATION, "habitants</td></tr>",
                     "<tr><td><strong>Densité</strong></td><td style = 'text-align: right'>", ligne_donnees_2$DENSITE, "habitants/km²</td></tr>",
                     "<tr><td><strong>PIB par habitant</strong></td><td style = 'text-align: right'>", ligne_donnees_2$PIBH, "€/habitant/an</td></tr>",
                     "<tr><td><strong>Jeunes ayant quitté prématurément l'éducation</strong></td><td style = 'text-align: right'>", ligne_donnees_2$EDUC_JEUNE, "%</td></tr>",
                     "<tr><td><strong>Personnes en risque de pauvreté ou d'exclusion sociale</strong></td><td style = 'text-align: right'>", ligne_donnees_2$RISQUE_PAUVR_NB, "%</td></tr>",
                     "<tr><td><strong>Taux de risque de pauvreté</strong></td><td style = 'text-align: right'>", ligne_donnees_2$RISQUE_PAUVR_TX, "%</td></tr>",
                     "<tr><td><strong>Taux de chômage</strong></td><td style = 'text-align: right'>", ligne_donnees_2$CHOMAGE_TX, "%</td></tr>",
                     "<tr><td><strong>Degré-jours de refroidissement</strong></td><td style = 'text-align: right'>", ligne_donnees_2$DEGRES_JOUR_COLD, "</td></tr>",
                     "<tr><td><strong>Degré-jours de chauffage</strong></td><td style = 'text-align: right'>", ligne_donnees_2$DEGRES_JOUR_HOT, "</td></tr>",
                     "</table>")
      
      titre1 = tags$h4(ligne_click$NOM_REGION)
      titre2 = tags$h4(ligne_donnees_2$NOM_REGION)
    } else if (input$choix_nuts == "NUTS 1"){
      # En NUTS 1, donner des informations sur la région choisie et sur le pays qui l'englobe
      
      
      ligne_donnees_2 = moyenne_region %>% 
        filter(ANNEE == ligne_click$ANNEE & 
                 REGION == substr(ligne_click$REGION, 1, 2))
      
      texte1 = paste("<table>",
                     "<tr><td><strong>Population</strong></td><td style = 'text-align: right'>", ligne_click$POPULATION, "habitants</td></tr>",
                     "<tr><td><strong>Densité</strong></td><td style = 'text-align: right'>", ligne_click$DENSITE, "habitants/km²</td></tr>",
                     "<tr><td><strong>PIB par habitant</strong></td><td style = 'text-align: right'>", ligne_click$PIBH, "€/habitant/an</td></tr>",
                     "<tr><td><strong>Jeunes ayant quitté prématurément l'éducation</strong></td><td style = 'text-align: right'>", ligne_click$EDUC_JEUNE, "%</td></tr>",
                     "<tr><td><strong>Personnes en risque de pauvreté ou d'exclusion sociale</strong></td><td style = 'text-align: right'>", ligne_click$RISQUE_PAUVR_NB, "%</td></tr>",
                     "<tr><td><strong>Taux de risque de pauvreté</strong></td><td style = 'text-align: right'>", ligne_click$RISQUE_PAUVR_TX, "%</td></tr>",
                     "<tr><td><strong>Taux de chômage</strong></td><td style = 'text-align: right'>", ligne_click$CHOMAGE_TX, "%</td></tr>",
                     "<tr><td><strong>Degré-jours de refroidissement</strong></td><td style = 'text-align: right'>", ligne_click$DEGRES_JOUR_COLD, "</td></tr>",
                     "<tr><td><strong>Degré-jours de chauffage</strong></td><td style = 'text-align: right'>", ligne_click$DEGRES_JOUR_HOT, "</td></tr>",
                     "</table>")
      
      texte2 = paste("<table>",
                     "<tr><td><strong>Population</strong></td><td style = 'text-align: right'>", ligne_donnees_2$POPULATION, "habitants</td></tr>",
                     "<tr><td><strong>Densité</strong></td><td style = 'text-align: right'>", ligne_donnees_2$DENSITE, "habitants/km²</td></tr>",
                     "<tr><td><strong>PIB par habitant</strong></td><td style = 'text-align: right'>", ligne_donnees_2$PIBH, "€/habitant/an</td></tr>",
                     "<tr><td><strong>Jeunes ayant quitté prématurément l'éducation</strong></td><td style = 'text-align: right'>", ligne_donnees_2$EDUC_JEUNE, "%</td></tr>",
                     "<tr><td><strong>Personnes en risque de pauvreté ou d'exclusion sociale</strong></td><td style = 'text-align: right'>", ligne_donnees_2$RISQUE_PAUVR_NB, "%</td></tr>",
                     "<tr><td><strong>Taux de risque de pauvreté</strong></td><td style = 'text-align: right'>", ligne_donnees_2$RISQUE_PAUVR_TX, "%</td></tr>",
                     "<tr><td><strong>Taux de chômage</strong></td><td style = 'text-align: right'>", ligne_donnees_2$CHOMAGE_TX, "%</td></tr>",
                     "<tr><td><strong>Degré-jours de refroidissement</strong></td><td style = 'text-align: right'>", ligne_donnees_2$DEGRES_JOUR_COLD, "</td></tr>",
                     "<tr><td><strong>Degré-jours de chauffage</strong></td><td style = 'text-align: right'>", ligne_donnees_2$DEGRES_JOUR_HOT, "</td></tr>",
                     "</table>")
      
      titre1 = tags$h4(ligne_click$NOM_REGION)
      titre2 = tags$h4(ligne_donnees_2$NOM_REGION)
      
    } else if (input$choix_nuts == "NUTS 0"){
      # En NUTS 0, donner des informations sur le pays choisi et sur l'Europe
      
      moyenne_region_eu28_filtre = moyenne_region_eu28 %>% 
        filter(ANNEE == ligne_click$ANNEE)
      
      texte1 = paste("<table>",
                     "<tr><td><strong>Population</strong></td><td style = 'text-align: right'>", ligne_click$POPULATION, "habitants</td></tr>",
                     "<tr><td><strong>Densité</strong></td><td style = 'text-align: right'>", ligne_click$DENSITE, "habitants/km²</td></tr>",
                     "<tr><td><strong>PIB par habitant</strong></td><td style = 'text-align: right'>", ligne_click$PIBH, "€/habitant/an</td></tr>",
                     "<tr><td><strong>Jeunes ayant quitté prématurément l'éducation</strong></td><td style = 'text-align: right'>", ligne_click$EDUC_JEUNE, "%</td></tr>",
                     "<tr><td><strong>Personnes en risque de pauvreté ou d'exclusion sociale</strong></td><td style = 'text-align: right'>", ligne_click$RISQUE_PAUVR_NB, "%</td></tr>",
                     "<tr><td><strong>Taux de risque de pauvreté</strong></td><td style = 'text-align: right'>", ligne_click$RISQUE_PAUVR_TX, "%</td></tr>",
                     "<tr><td><strong>Taux de chômage</strong></td><td style = 'text-align: right'>", ligne_click$CHOMAGE_TX, "%</td></tr>",
                     "<tr><td><strong>Degré-jours de refroidissement</strong></td><td style = 'text-align: right'>", ligne_click$DEGRES_JOUR_COLD, "</td></tr>",
                     "<tr><td><strong>Degré-jours de chauffage</strong></td><td style = 'text-align: right'>", ligne_click$DEGRES_JOUR_HOT, "</td></tr>",
                     "</table>")
      
      texte2 = paste("<table>",
                     "<tr><td><strong>Population</strong></td><td style = 'text-align: right'>", moyenne_region_eu28_filtre$POPULATION, "habitants</td></tr>",
                     "<tr><td><strong>Densité</strong></td><td style = 'text-align: right'>", moyenne_region_eu28_filtre$DENSITE, "habitants/km²</td></tr>",
                     "<tr><td><strong>PIB par habitant</strong></td><td style = 'text-align: right'>", moyenne_region_eu28_filtre$PIBH, "€/habitant/an</td></tr>",
                     "<tr><td><strong>Jeunes ayant quitté prématurément l'éducation</strong></td><td style = 'text-align: right'>", moyenne_region_eu28_filtre$EDUC_JEUNE, "%</td></tr>",
                     "<tr><td><strong>Personnes en risque de pauvreté ou d'exclusion sociale</strong></td><td style = 'text-align: right'>", moyenne_region_eu28_filtre$RISQUE_PAUVR_NB, "%</td></tr>",
                     "<tr><td><strong>Taux de risque de pauvreté</strong></td><td style = 'text-align: right'>", moyenne_region_eu28_filtre$RISQUE_PAUVR_TX, "%</td></tr>",
                     "<tr><td><strong>Taux de chômage</strong></td><td style = 'text-align: right'>", moyenne_region_eu28_filtre$CHOMAGE_TX, "%</td></tr>",
                     "<tr><td><strong>Degré-jours de refroidissement</strong></td><td style = 'text-align: right'>", moyenne_region_eu28_filtre$DEGRES_JOUR_COLD, "</td></tr>",
                     "<tr><td><strong>Degré-jours de chauffage</strong></td><td style = 'text-align: right'>", moyenne_region_eu28_filtre$DEGRES_JOUR_HOT, "</td></tr>",
                     "</table>")
      
      titre1 = tags$h4(ligne_click$NOM_REGION)
      titre2 = tags$h4("Europe")
      
      
      
    }
    
    # 4. Les sorties ...
    output$panel_droite_map_titre1 = renderUI({titre1})
    output$panel_droite_map_contenu1 = renderUI({HTML(texte1)})
    output$panel_droite_map_titre2 = renderUI({titre2})
    output$panel_droite_map_contenu2 = renderUI({HTML(texte2)})
  }
})