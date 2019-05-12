fichiers_source = list.files("./tab")
fichiers_source = paste("./tab/", fichiers_source, sep = '')
sapply(fichiers_source, source)




contenu_UI <- shinyUI(
    dashboardPage(
        dashboardHeader(),
        dashboardSidebar(
            sidebarMenu(
                menuItem("CARTO", 
                         tabName = "tab_carto", 
                         icon = icon("globe-americas")
                ),
                menuItem("STATS", 
                         tabName = "tab_stats", 
                         icon = icon("chart-bar")
                )
            )
        ),
        dashboardBody(
            includeCSS("./extra/styles.css", encoding = "UTF-8"),
            tabItems(
                tabItem(
                    tabName = "tab_carto",
                    tab_carto),
                tabItem(
                    tabName = "tab_stats",
                    textOutput("texte2"),
                    
                    DT::dataTableOutput("df_a_afficher")
                )
            )
        )
    )
)
