contenu_server = shinyServer(
    function(input, output, session) {
        # Sourcing de l'ensemble des fichiers R (coté serveur)
        source("./4_server_carto.R", local = T, encoding = "UTF-8")$value
        source("./4_server_stats_onglet1.R", local = T, encoding = "UTF-8")$value
        source("./4_server_stats_onglet2.R", local = T, encoding = "UTF-8")$value
        source("./4_server_stats_onglet3.R", local = T, encoding = "UTF-8")$value
        
    }
)
