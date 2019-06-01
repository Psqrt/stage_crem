options(encoding = "UTF-8")

source('3_importations.R')
source('2_fichier_UI.R', local = TRUE)
source('2_fichier_server.R')

shinyApp(
    ui = contenu_UI,
    server = contenu_server
)