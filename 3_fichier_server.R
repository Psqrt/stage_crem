fichiers_source = list.files("./server")                        # 1. Obtention de la liste des fichiers ...
fichiers_source = paste("./server/", fichiers_source, sep = '') # 2. Construction des chemins ...

contenu_server = shinyServer(
    function(input, output, session) {
        # Sourcing de l'ensemble des fichiers R (coté serveur)
        for (fichier in fichiers_source){
            source(fichier, local = T, encoding = "UTF-8")$value
        }
        
        
        
        observeEvent(input$sidebar, {
            shinyjs::toggleClass(selector = "body", class = "css_carto",
                                 condition = (input$sidebar == 'tab_carto'))
            
            shinyjs::toggleClass(selector = "body", class = "css_autre",
                                 condition = (input$sidebar != 'tab_carto'))
        })
    }
    
)
