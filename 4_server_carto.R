### REACTIVE LISTE ANNEE ##############################################################################
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

### REACTIVE BASE FILTREE #############################################################################
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

observe({
  output$df_a_afficher = DT::renderDataTable({
    moyenne_region_filtre()
  })
})



### PDF ###############################################################################################

output$pdfviewer <- renderText({
  page = recode(substr(input$choix_variable_map, 1, 5), !!!dico_liste_variable_page)
  return(paste('<iframe style="height:500px; width:793px;" src="./pdf/', page, '.pdf', '"></iframe>', sep = ""))
})


#######################################################################################################
# Cartographie
#######################################################################################################

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

# choix_carte_noms = reactive({
#   paste("LISTE ANNEE DANS CHOIX CARTE : ", liste_annee()[1])
#   annee_enquete = liste_annee()[1]
#   if (annee_enquete < 2006){
#     annee_carte = 2003
#   } else if (annee_enquete >= 2006 & annee_enquete < 2010){
#     annee_carte = 2006
#   } else if (annee_enquete >= 2010 & annee_enquete < 2013){
#     annee_carte = 2010
#   } else if (annee_enquete >= 2013 & annee_enquete < 2016){
#     annee_carte = 2013
#   } else {
#     annee_carte = 2016
#   }
#   paste0("data_map", annee_carte, "_nuts0_noms", sep = "")
# })

# Choix de la palette
pal <- colorNumeric("YlOrRd", NULL, na.color = "#F0F0F0", alpha = T)


# Carte leaflet
output$map <- renderLeaflet({
  leaflet(options = leafletOptions(zoomControl = FALSE)) %>% 
    # addTiles(urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png") %>%
    addTiles(urlTemplate = "//{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png") %>%
    # addTiles(urlTemplate = "//server.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Light_Gray_Base/MapServer/tile/{z}/{y}/{x}") %>%
    setView(lng = 7.2231853, lat = 49.6014421, zoom = 5)
  # addLabelOnlyMarkers(data = get(choix_carte_noms()))
  
})


observe({
  variable_choisie = input$choix_variable_map
  print(variable_choisie)
  leafletProxy('map') %>% 
    clearShapes() %>% 
    addPolygons(data = get(choix_carte()),
                layerId = ~NUTS_ID,
                color = "black",
                weight = 0.3,
                smoothFactor = 0,
                popup = ~sprintf("<b> %s : </b> %s", moyenne_region_filtre()$NOM_REGION, round(moyenne_region_filtre()[, variable_choisie], 2)),
                # label = ~paste0(strong(moyenne_region_filtre()$NOM_REGION), " : ", round(moyenne_region_filtre()[, variable_choisie], 2)),
                # label = lapply(xx, FUN = HTML),
                fillOpacity = 0.6,
                fillColor = ~pal(moyenne_region_filtre()[, variable_choisie]),
                highlightOptions = highlightOptions(color = "white", weight = 2, bringToFront = T)) %>% 
    addPolylines(data = get(choix_carte_front()),
                 weight = 2,
                 color = "black",
                 opacity = 0.8) %>% 
    clearControls() %>% 
    addLegend(pal = pal, 
              values = moyenne_region_filtre()[, variable_choisie], 
              title = "LEGEND",
              opacity = 2.0,
              na.label = "NA")
})


### PANEL INFO DE DROITE ##############################################################################
observeEvent(input$map_shape_click, {
  click <<- input$map_shape_click
  
  ligne_click = moyenne_region_filtre() %>% 
    filter(REGION == click$id)
  
  if (input$choix_nuts == "NUTS 2"){
    texte1 = paste("Une région NUTS 2 a été selectionnée : donner infos sur cette région NUTS2 : ", ligne_click$HH050_moy)
    texte2 = paste("Une région NUTS 2 a été selectionnée : donner infos sur la région NUTS1 : ", ligne_click$HH040_moy)
    titre2 = tags$h4(substr(ligne_click$REGION, 1, 3))
  } else if (input$choix_nuts == "NUTS 1"){
    texte1 = paste("Une région NUTS 1 a été selectionnée : donner infos sur cette région NUTS1 : ", ligne_click$HH050_moy)
    texte2 = paste("Une région NUTS 1 a été selectionnée : donner infos sur le pays NUTS0 : ", ligne_click$HH040_moy)
    titre2 = tags$h4(substr(ligne_click$REGION, 1, 2))
  } else if (input$choix_nuts == "NUTS 0"){
    texte1 = paste("Une région NUTS 0 a été selectionnée : donner infos sur cette région NUTS0 : ", ligne_click$HH050_moy)
    texte2 = paste("Une région NUTS 0 a été selectionnée : donner infos sur l'Europe : ", ligne_click$HH040_moy)
    titre2 = tags$h4("Europe")
  }
  output$sortie_click_titre1 = renderUI({
    tags$h4(ligne_click$NOM_REGION)
  })
  output$sortie_click_texte1 = renderUI({
    texte1
  })
  output$sortie_click_titre2 = renderUI({
    titre2
  })
  output$sortie_click_texte2 = renderUI({
    texte2
  })
})























# garbage

output$texte2 = renderText({
  paste("toto",
        input$choix_nuts,
        input$choix_variable_map,
        input$choix_modalite_map,
        input$switch_periode,
        input$choix_annee,
        input$choix_periode,
        input$colorblind_safe,
        input$na_proportion,
        sep = "\n")
})

output$texte = renderText({
  paste0("toto",
         input$choix_nuts,
         input$choix_variable_map,
         input$choix_modalite_map,
         input$switch_periode,
         input$choix_annee,
         input$choix_periode,
         input$colorblind_safe,
         input$na_proportion,
         sep = " - ")
})