options(encoding = "UTF-8")
if (Sys.info()[1] == "Windows"){
    Sys.setlocale("LC_ALL","English")
}

source('2_importations.R', encoding = "UTF-8")
source('3_fichier_UI.R', encoding = "UTF-8", local = TRUE)
source('3_fichier_server.R', encoding = "UTF-8")

shinyApp(
    ui = contenu_UI,
    server = contenu_server
)
