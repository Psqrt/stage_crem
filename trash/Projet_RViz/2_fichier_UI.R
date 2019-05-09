fichiers_source = list.files("./tab")
fichiers_source = paste("./tab/", fichiers_source, sep = '')
sapply(fichiers_source, source)




contenu_UI <- shinyUI(
    
    fluidPage(
        # Modifications de style css
        includeCSS("./extra/styles.css", encoding = "UTF-8"),
        
        # Ballon loading (top-right corner)
        add_busy_gif(src = "http://obviotalentos.com.br/wp-content/uploads/2018/08/loading.gif",
                     height = 70,
                     width = 70,
                     timeout = 0),
        
        # Choix du theme de l'application
        theme = shinytheme("sandstone"),
        
        # Listing des onglets
        tags$div(class = "grandtitre",
                 titlePanel(
                     title = "Football Tracking Dashboard"
                 )
        ),
        navbarPage(title = "",
                   tab_joueurs,
                   tab_reseau,
                   tab_carto
        )
    )
)
