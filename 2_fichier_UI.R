fichiers_source = list.files("./tab")
fichiers_source = paste("./tab/", fichiers_source, sep = '')
sapply(fichiers_source, source)




contenu_UI <- shinyUI(
    dashboardPagePlus(
        dashboardHeaderPlus(
            title = tagList(
                span(class = "logo-lg", "Fuel Poverty"),
                icon("fas fa-home"))
        ),
        dashboardSidebar(
            sidebarMenu(id="sidebar",
                        menuItem("MAP", 
                                 tabName = "tab_carto", 
                                 icon = icon("globe-americas")
                        ),
                        menuItem("STATISTICS", 
                                 tabName = "tab_stats",
                                 icon = icon("chart-bar"),
                                 menuSubItem("Time series",
                                             tabName = "subtab_onglet2"
                                 ),
                                 menuSubItem("Scatter plot",
                                             tabName = "subtab_onglet3"
                                 ),
                                 menuSubItem("(Extra)",
                                             tabName = "subtab_onglet1")
                        ),
                        conditionalPanel(
                            "input.sidebar == 'subtab_onglet2'",
                            radioGroupButtons(
                                inputId = "choix_nuts_onglet2",
                                label = "NUTS LEVEL",
                                choices = c("0" = "NUTS 0",
                                            "1" = "NUTS 1",
                                            "2" = "NUTS 2"),
                                selected = "NUTS 0",
                                checkIcon = list(
                                    yes = tags$i(class = "fa fa-circle",
                                                 style = "color: steelblue"),
                                    no = tags$i(class = "fa fa-circle-o",
                                                style = "color: steelblue"))
                            ),
                            
                            conditionalPanel(
                                "input.choix_nuts_onglet2 == 'NUTS 1' | input.choix_nuts_onglet2 == 'NUTS 2'",
                                selectInput(
                                    inputId = "choix_pays_onglet2",
                                    label = "COUNTRY",
                                    choices = c("Choose a country" = "XXXX", liste_nuts0_stat),
                                    # selected = "FR",
                                    width = "410px"
                                )
                            ),
                            selectInput(
                                inputId = "choix_var_onglet2",
                                label = "VARIABLE",
                                choices = c("Choose a variable" = "XXXX", liste_deroulante_map),
                                # selected = "FR",
                                width = "410px"
                            )
                        ),
                        
                        conditionalPanel(
                            "input.sidebar == 'subtab_onglet3'",
                            
                            selectInput(
                                inputId = "choix_var1_onglet3",
                                label = "VARIABLE 1",
                                choices = c("Choose a variable" = "XXXX", liste_deroulante_map),
                                selected = "XXXX",
                                width = "410px"),
                            
                            # conditionalPanel(
                            #     "input.choix_var1_onglet3 != 'XXXX'",
                            #     
                            #     dropdownButton(
                            #         htmlOutput('pdf1_onglet3'),
                            #         circle = TRUE,
                            #         status = 'danger',
                            #         label = "Documentation",
                            #         size = "sm",
                            #         icon = icon("file-pdf"),
                            #         width = "795px",
                            #         margin = "0px",
                            #         up = T
                            #     )
                            # ),
                            
                            selectInput(
                                inputId = "choix_var2_onglet3",
                                label = "VARIABLE 2",
                                choices = c("Choose a variable" = "XXXX", liste_deroulante_map),
                                selected = "XXXX",
                                width = "410px"),
                            
                            
                            # conditionalPanel(
                            #     "input.choix_var2_onglet3 != 'XXXX'",
                            #     
                            #     dropdownButton(
                            #         htmlOutput('pdf2_onglet3'),
                            #         circle = TRUE,
                            #         status = 'danger',
                            #         label = "Documentation",
                            #         size = "sm",
                            #         icon = icon("file-pdf"),
                            #         width = "795px",
                            #         margin = "0px",
                            #         up = T
                            #     )
                            # ),
                            
                            radioGroupButtons(
                                inputId = "choix_nuts_onglet3",
                                label = "NUTS LEVEL",
                                choices = c("0" = "NUTS 0",
                                            "1" = "NUTS 1",
                                            "2" = "NUTS 2"),
                                selected = "NUTS 0",
                                checkIcon = list(
                                    yes = tags$i(class = "fa fa-circle",
                                                 style = "color: steelblue"),
                                    no = tags$i(class = "fa fa-circle-o",
                                                style = "color: steelblue"))
                            ),
                            
                            materialSwitch(
                                inputId = "switch_3d_onglet3",
                                label = "3D CHART", 
                                value = FALSE,
                                right = TRUE,
                                status = "success"
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
                    tabName = "subtab_onglet1",
                    subtab_onglet1),
                tabItem(
                    tabName = "subtab_onglet2",
                    subtab_onglet2),
                tabItem(
                    tabName = "subtab_onglet3",
                    subtab_onglet3
                )
            )
        )
    )
)
