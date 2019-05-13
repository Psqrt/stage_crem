moyenne_region = read.csv(file = "./data/finaux/donnees.csv",
                          sep = ",",
                          header = T,
                          stringsAsFactors = F)



### REACTIVE LISTE ANNEE ##############################################################################
liste_annee = reactive({
    if (input$switch_periode == TRUE){
        if (is.null(input$choix_periode)){
            c(0)
        } else {
            print(input$choix_periode)
            c(as.numeric(substr(input$choix_periode, 1, 4)):as.numeric(substr(input$choix_periode, 6, 9)))
            # c(as.numeric(input$choix_annee))
        }
    } else {
        print(input$choix_periode)
        c(as.numeric(input$choix_annee))
    }
})

moyenne_region_filtre = reactive({
    if (input$switch_periode){
        moyenne_region %>% 
            filter(NUTS == input$choix_nuts &
                       PERIODE == input$choix_periode)
    } else {
        moyenne_region %>%
            filter(NUTS == input$choix_nuts &
                       ANNEE == input$choix_annee) #liste_annee()
    }
})

observe({
    output$df_a_afficher = DT::renderDataTable({
        # invalidateLater(2000)
        moyenne_region_filtre()

        # print(moyenne_region_filtre)
    })
})

# observeEvent(input$switch_periode, {
#     if (input$switch_periode == TRUE){
#         print("QQQQQQQQQQQQQQQQQQQQQQQQ")
#         insertUI(
#             selector = "#switch_periode",
#             where = "beforeBegin",
#             # immediate = T,
#             ui =  selectInput(
#                 inputId = "choix_periode",
#                 label = "PERIOD",
#                 selected = "2006-2009",
#                 choices = c("2004-2005",
#                             "2006-2009",
#                             "2010-2012",
#                             "2013-2015")
#             )
#         )
#     } else {
#         removeUI(selector = "switch_periode")
#     }
# })

###################################################################################################
# Cartographie
###################################################################################################

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

# Choix de la palette
pal <- colorNumeric("YlOrRd", NULL, na.color = "#F0F0F0", alpha = T)
# base-light-nolabels
# Carte leaflet


output$map <- renderLeaflet({
            leaflet(options = leafletOptions(zoomControl = FALSE)) %>% 
                addTiles(urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png") %>%
                setView(lng = 9.9921, lat = 48.3453, zoom = 5)
})

observe({
    leafletProxy('map') %>% 
        clearShapes() %>% 
        addPolygons(data = get(choix_carte()),
                    color = "black",
                    weight = 1,
                    smoothFactor = 0,
                    label = ~paste0(moyenne_region_filtre()$REGION, " : ", round(moyenne_region_filtre()$warm_moy, 2)),
                    fillOpacity = 0.5,
                    fillColor = ~pal(moyenne_region_filtre()$warm_moy),
                    highlightOptions = highlightOptions(color = "white", weight = 2, bringToFront = T)) %>% 
        clearControls() %>% 
        addLegend(pal = pal, values = moyenne_region_filtre()$warm_moy, opacity = 1.0)
})





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