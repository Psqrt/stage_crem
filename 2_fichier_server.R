contenu_server = shinyServer(
    function(input, output, session) {
        
        source("./4_server_carto.R", local = T)$value
        source("./4_server_stats_onglet1.R", local = T)$value
        source("./4_server_stats_onglet2.R", local = T)$value
        source("./4_server_stats_onglet3.R", local = T)$value
        
    }
)
