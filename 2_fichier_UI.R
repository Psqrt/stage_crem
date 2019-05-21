fichiers_source = list.files("./tab")
fichiers_source = paste("./tab/", fichiers_source, sep = '')
sapply(fichiers_source, source)




contenu_UI <- shinyUI(
    dashboardPagePlus(
        dashboardHeaderPlus(),
        dashboardSidebar(
            sidebarMenu(
                menuItem("MAP", 
                         tabName = "tab_carto", 
                         icon = icon("globe-americas")
                ),
                menuItem("STATISTICS", 
                         tabName = "tab_stats",
                         icon = icon("chart-bar"),
                         menuSubItem("Time series",
                             tabName = "subtab_timeseries",
                             
                         )
                )
            )
        ),
        dashboardBody(
            useShinyjs(),
            includeCSS("./extra/styles.css", encoding = "UTF-8"),
            tabItems(
                tabItem(
                    tabName = "tab_carto",
                    tab_carto),
                tabItem(
                    tabName = "subtab_timeseries",
                    # textOutput("texte2"),
                    subtab_timeseries
                    
                    # DT::dataTableOutput("df_a_afficher")
                )
            )
        )
    )
)
