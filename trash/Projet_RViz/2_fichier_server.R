contenu_server = shinyServer(
    function(input, output, session) {
        
        source("./4_server_joueurs.R", local = T)$value
        source("./4_server_reseau.R", local = T)$value
        source("./4_server_carto.R", local = T)$value
        
    }
)
