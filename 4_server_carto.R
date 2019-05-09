output$map <- renderLeaflet(
    {
        leaflet(mtcars,
                options = leafletOptions(zoomControl = FALSE)) %>% 
            addTiles(urlTemplate = "//{s}.api.cartocdn.com/base-light-nolabels/{z}/{x}/{y}.png") %>% 
            setView(lng = 9.9921, lat = 48.3453, zoom = 5)
            
    }
)

output$texte = renderText({
    "toto"
})