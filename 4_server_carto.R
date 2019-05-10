# nuts = 2
# annee_enquete = 2013


moyenne_region = read.csv(file = "./data/finaux/donnees.csv",
                          sep = ",",
                          header = T,
                          stringsAsFactors = F)



moyenne_region_filtre = reactive({
    
    if (input$switch_periode == TRUE){
        liste_annee = c(as.numeric(substr(input$choix_periode, 1, 4)):as.numeric(substr(input$choix_periode, 6: 9)))
    } else {
        liste_annee = c(as.numeric(input$choix_annee))
    }
    
    moyenne_region %>%
        filter(NUTS == input$choix_nuts &
                   ANNEE %in% liste_annee)})


observe({
    output$df_a_afficher = DT::renderDataTable({
        # invalidateLater(2000)
        moyenne_region_filtre()
        
        # print(moyenne_region_filtre)
    })
})

###################################################################################################
# Cartographie
###################################################################################################
annee_enquete = 2010
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


# Choix de la palette
pal <- colorNumeric("YlOrRd", NULL, na.color = "#F0F0F0", alpha = T)
# base-light-nolabels
# Carte leaflet
output$map <- renderLeaflet(
    {
        nuts = substr(input$choix_nuts, 6, 6)
        choix_carte = paste0("data_map", annee_carte, "_nuts", nuts, sep = "")

        leaflet(get(choix_carte),
                options = leafletOptions(zoomControl = FALSE)) %>%
            addTiles(urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png") %>%
            addPolygons(color = "black",
                        weight = 1,
                        smoothFactor = 0,
                        # label = ~paste0(moyenne_region_filtre$REGION, " : ", round(moyenne_region_filtre$warm, 2)),
                        fillOpacity = 0.8,
                        fillColor = ~pal(moyenne_region_filtre()$warm),
                        highlightOptions = highlightOptions(color = "white", weight = 2, bringToFront = T)) %>%
            # addLegend(pal = pal,
            #           values = moyenne_region_filtre$warm,
            #           opacity = 1.0) %>%
            setView(lng = 9.9921, lat = 48.3453, zoom = 5)
    })
#              fillColor = ~pal(1-moyenne_region$warm)) %>%
#    addLegend(pal = pal, values = 1-moyenne_region$warm, opacity = 1.0)
#                fillColor = ~pal(1-moyenne_region$arrears)) %>%
#    addLegend(pal = pal, values = 1-moyenne_region$arrears, opacity = 1.0)






























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