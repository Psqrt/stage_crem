source(file = "./extra/fct_trace.R") # utile pour le traçage des flux sur carte

# output$tab_trans<- renderDataTable(donnees_trans)

player = reactiveValues(Name = "")
Club = reactiveValues(Name = "",
                      Season = "",
                      Price = "")
Mercatos = reactiveValues(Name = "",
                          Price = "")


output$ligne0_titre_liste = renderText("Please select a club and a season!")
output$titre_graphique_player = renderText("Please select a player!")
output$evol = renderPlot(NULL,
                         width = 10,
                         height = 10)

# observeEvent(input$recalc,
#              {
#                  player$Name <- input$player_name
#                  Club$Name <- input$Club_name
#                  Club$Season = input$season_pour_club
#                  Club$Price = input$price_pour_club
#                  Mercatos$Name <- input$Mercatos_choices
#                  Mercatos$Price = input$price_pour_season
#              }
# )

# Club <- reactiveValues(Name = "")
# player <- reactiveValues(Name = "")
# Mercatos <- reactiveValues(Name = "")


observeEvent(input$player_or_club_or_season,
             {
                 if(input$player_or_club_or_season == "Player"){
                     updatePickerInput(
                         session,
                         inputId = "Club_name",
                         selected = NA
                     )
                     updatePickerInput(
                         session,
                         inputId = "Mercatos_choices",
                         selected = NA
                     )
                     updatePickerInput(
                         session,
                         inputId = "season_pour_club",
                         selected = NA
                     )
                     updateSliderInput(
                         session,
                         inputId = "price_pour_club",
                         value = c(0, max(donnees_trans$Transfer_fee))
                     )
                     updateSliderInput(
                         session,
                         inputId = "price_pour_season",
                         value = c(0, max(donnees_trans$Transfer_fee))
                     )
                     
                     output$ligne0_titre_liste = renderText("Please select a club and a season!")
                     output$ligne1_titre_liste = renderText(NULL)
                     output$ligne2_titre_liste = renderText(NULL)
                     output$ligne3_titre_liste = renderText(NULL)
                     output$top_player = renderTable(NULL)
                     
                     # club_tab = data.frame(c())
                     # mercato_tab = data.frame(c())
                     leafletProxy("map") %>% 
                         clearMarkers() %>% 
                         clearShapes() %>%
                         setView(lng = -1.553621, lat = 47.218371, zoom = 6) %>% 
                         removeLayersControl()
                 } else if(input$player_or_club_or_season == "Club") {
                     updatePickerInput(
                         session,
                         inputId = "player_name",
                         selected = NA
                     )
                     updatePickerInput(
                         session,
                         inputId = "Mercatos_choices",
                         selected = NA
                     )
                     updateSliderInput(
                         session,
                         inputId = "price_pour_season",
                         value = c(0, max(donnees_trans$Transfer_fee))
                     )
                     
                     output$ligne0_titre_liste = renderText("Please select a club and a season!")
                     output$ligne1_titre_liste = renderText(NULL)
                     output$ligne2_titre_liste = renderText(NULL)
                     output$ligne3_titre_liste = renderText(NULL)
                     output$top_player = renderTable(NULL)
                     output$titre_graphique_player = renderText("Please select a player!")
                     output$evol = renderPlot(NULL,
                                              height = 10,
                                              width = 10)
                     
                     # joueur_tab = data.frame(c())
                     # mercato_tab = data.frame(c())
                     leafletProxy("map") %>% 
                         clearMarkers() %>% 
                         clearShapes() %>%
                         setView(lng = -1.553621, lat = 47.218371, zoom = 6) %>% 
                         removeLayersControl()
                 } else {
                     updatePickerInput(
                         session,
                         inputId = "player_name",
                         selected = NA
                     )
                     updatePickerInput(
                         session,
                         inputId = "Club_name",
                         selected = NA
                     )
                     updatePickerInput(
                         session,
                         inputId = "season_pour_club",
                         selected = NA
                     )
                     updateSliderInput(
                         session,
                         inputId = "price_pour_club",
                         value = c(0, max(donnees_trans$Transfer_fee))
                     )
                     
                     output$ligne0_titre_liste = renderText("Please select a club and a season!")
                     output$ligne1_titre_liste = renderText(NULL)
                     output$ligne2_titre_liste = renderText(NULL)
                     output$ligne3_titre_liste = renderText(NULL)
                     output$top_player = renderTable(NULL)
                     output$titre_graphique_player = renderText("Please select a player!")
                     output$evol = renderPlot(NULL,
                                              height = 10,
                                              width = 10)
                     
                     # joueur_tab = data.frame(c())
                     # club_tab = data.frame(c())
                     leafletProxy("map") %>% 
                         clearMarkers() %>% 
                         clearShapes() %>%
                         setView(lng = -1.553621, lat = 47.218371, zoom = 6) %>% 
                         removeLayersControl()
                 }
             }
)





seasons <- sort(unique(donnees_trans$Season))

pal = colorNumeric(c(rev(heat.colors(200)), rep("red", 200)), 
                   donnees_trans$Transfer_fee)
# pal_sup = colorNumeric(heat.colors(1),
#                        donnees_trans$Transfer_fee[donnees_trans$Transfer_fee >= 100000000])


# output$p_trans <- DT::renderDataTable(donnees_trans[donnees_trans$Name == player$Name][order(Age)])

# colorpal <- reactive({colorNumeric(input$colors,min(clubs_trans$VolumeCash))})

output$map <- renderLeaflet(
    {
        # Partie fixe de leaflet
        leaflet(clubs_trans) %>% 
            setView(lng = -1.553621, lat = 47.218371, zoom = 6) %>% 
            addTiles(urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png") %>% 
            addLegend(position = "bottomright",
                      pal = pal,
                      bins = 5,
                      values = ~donnees_trans$Transfer_fee,
                      title = "Transfer fee",
                      labFormat = labelFormat(prefix = "€")
            )
    }
)


observeEvent(input$recalc_player,
             {
                 player$Name <- input$player_name
                 
                 joueur_tab <- donnees_trans[donnees_trans$Name == player$Name][order(Age)]
                 if (nrow(joueur_tab) == 0 & input$player_or_club_or_season == "Player"){ # cas inutile avec des pickers au lieu des selects (pas de fausse orthographe possible)
                     # print("Vérifiez l'orthographe du joueur")
                     sendSweetAlert(
                         session = session,
                         title = "Information",
                         text = "No transfer found according to the current selection choices. Please try something else.",
                         type = "info"
                     )
                 } else if (nrow(joueur_tab) != 0 & input$player_or_club_or_season == "Player") {
                     tab_aug <- joueur_tab %>%
                         left_join(clubs_trans[, c(1,12)], 
                                   by = c('Team_from' = "Clubs")
                         ) %>% 
                         rename(Pays_from = Pays) %>% 
                         left_join(clubs_trans[, c(1,12)], 
                                   by = c('Team_to' = "Clubs")) %>% 
                         rename(Pays_to = Pays) %>% 
                         left_join(clubs_trans[, c(1,14,15)], 
                                   by = c('Team_from' = "Clubs")) %>%
                         left_join(clubs_trans[, c(1,14,15)], 
                                   by = c('Team_to'="Clubs"))
                     # print(tab_aug)
                     tab_aug2 = tab_aug[complete.cases(tab_aug[, 15:18]),]
                     Clubs_played = data.frame(Clubs_j = unique(c(tab_aug2$Team_from,tab_aug2$Team_to))) %>% 
                         left_join(clubs_trans[, c(1,14,15)], 
                                   by = c('Clubs_j' = "Clubs")) %>% 
                         left_join(tab_conversion_clubs,
                                   by = c('Clubs_j' = "tab_Transferts"))
                     # print(Clubs_played)
                     list_url = c()
                     for (i in Clubs_played$tab_Fifa){
                         list_url = c(list_url,
                                      ifelse(identical(df_avec_logos[i == Club.y,Club.Logo1], character(0)),
                                             "no_logo_leaflet.png", 
                                             df_avec_logos[i==Club.y,Club.Logo1])
                         )
                     }
                     Clubs_played$url = list_url
                     # print(Clubs_played$url)
                     Icons <- icons(
                         iconUrl = Clubs_played$url,
                         iconWidth = 25, iconHeight = 25,
                         iconAnchorX = 20, iconAnchorY = 20)
                     
                     flows <- gcIntermediate(tab_aug2[, 15:16], 
                                             tab_aug2[,17:18], 
                                             sp = T, 
                                             addStartEnd = TRUE)
                     
                     flows$counts <- tab_aug2$Transfer_fee/1000000
                     flows$origins <- tab_aug2$Team_from
                     flows$destinations <- tab_aug2$Team_to
                     flows$Pays_to = tab_aug2$Pays_to
                     
                     
                     
                     hover2 = c()
                     for (i in 1:length(flows$counts)){
                         hover2=c(hover2,
                                  HTML(
                                      as.character(
                                          tagList(
                                              
                                              tags$h5(HTML(paste(flows$origins[i], " to ", 
                                                                 flows$destinations[i]))),
                                              
                                              tags$strong(HTML(sprintf(" Price: %s%sM","&euro;",
                                                                       as.character(flows$counts[i]))
                                                               
                                              )), tags$br(),
                                              
                                              sprintf("Season: %s", tab_aug2$Season[i]), tags$br(),
                                              
                                              sprintf("Age: %s ", as.integer(tab_aug2$Age[i])), tags$br(),
                                              
                                              ifelse(is.na(tab_aug2$ROI[i]), sprintf(""), sprintf("ROI: %s%%", 100*round(as.numeric(tab_aug2$ROI[i]), 2))), tags$br(),
                                              
                                              HTML(
                                                  ifelse(is.na(tab_aug2$ROI[i]), 
                                                         sprintf(""), 
                                                         ifelse(
                                                             abs(tab_aug2$Market_value[i]/1000000) >= 1, 
                                                             sprintf("Market Value: %s%sM", "&euro;", 
                                                                     tab_aug2$Market_value[i]/1000000),
                                                             sprintf("Market Value: %s%sk","&euro;",
                                                                     tab_aug2$Market_value[i]/1000)
                                                         )
                                                  )
                                              ),
                                              tags$br(),
                                              
                                              HTML(
                                                  ifelse(is.na(tab_aug2$ROI[i]),
                                                         sprintf(""),
                                                         ifelse(abs(tab_aug2$PV[i]/1000000) >= 1,
                                                                ifelse(tab_aug2$PV[i] >= 0,
                                                                       sprintf("Realised Gain: %s%sM","&euro;", tab_aug2$PV[i]/1000000),
                                                                       sprintf("Realised Gain: -%s%sM","&euro;", -tab_aug2$PV[i]/1000000)),
                                                                ifelse(tab_aug2$PV[i] >= 0,
                                                                       sprintf("Realised Gain: %s%sk","&euro;",
                                                                               tab_aug2$PV[i]/1000),
                                                                       sprintf("Realised Gain: -%s%sk","&euro;",
                                                                               -tab_aug2$PV[i]/1000)
                                                                )
                                                         )
                                                  )
                                              )
                                              
                                          )
                                      )
                                  )
                         )
                     }
                     
                     # print(hover2)
                     
                     lng_bar <- sum(Clubs_played$lon)/nrow(Clubs_played)
                     lat_bar <- sum(Clubs_played$lat)/nrow(Clubs_played)
                     Names_Icon = Clubs_played$tab_Fifa
                     if(sum(is.na(Names_Icon)>0)){
                         Names_Icon[which(is.na(Names_Icon))] = Clubs_played$Clubs_j[which(is.na(Names_Icon))]
                     }
                     
                     
                     
                     leafletProxy("map") %>% 
                         clearMarkers() %>% 
                         clearShapes() %>% 
                         addPolylines(data = flows, 
                                      weight = 4.5, 
                                      label = lapply(hover2, FUN=HTML), 
                                      group = ~destinations,
                                      color = ~pal(counts*1000000),
                                      smoothFactor = 0.8, 
                                      fillOpacity = 0.7) %>% 
                         # addPolylines(data = flows[flows$counts*1000000 < 100000000, ], 
                         #              weight = 4.5, 
                         #              label = lapply(hover2, FUN=HTML), 
                         #              group = ~destinations,
                         #              color= ~pal(counts*1000000),
                         #              smoothFactor = 0.8, 
                         #              fillOpacity = 0.7) %>% 
                         addMarkers(Clubs_played$lon, 
                                    Clubs_played$lat, 
                                    icon = Icons,
                                    label = Names_Icon,
                                    options = markerOptions(draggable = T)) %>% 
                         addLayersControl(overlayGroups = unique(flows$destinations),
                                          options = layersControlOptions(collapsed = FALSE)) %>% 
                         setView(lng = lng_bar,
                                 lat = lat_bar, 
                                 zoom = if(abs(lat_bar-min(Clubs_played$lat)) < 3 & abs(lng_bar-min(Clubs_played$lon)) < 2.5){
                                     7
                                 } else if(abs(lat_bar-min(Clubs_played$lat)) < 7.5 & abs(lng_bar-min(Clubs_played$lon)) < 4){
                                     5
                                 } else if(abs(lat_bar-min(Clubs_played$lat)) < 7 & abs(lng_bar-min(Clubs_played$lon)) < 6){4} else if(abs(lat_bar-min(Clubs_played$lat)) > 10 | abs(lng_bar-min(Clubs_played$lon)) > 10){
                                     2 # auparavant 1
                                 } else{
                                     3.5
                                 }) #%>% 
                     # addFullscreenControl()
                     
                     evol <- ggplot(data = tab_aug2, 
                                    aes(x = tab_aug2$Season, 
                                        y = tab_aug2$Transfer_fee, 
                                        group = 1,
                                        fill = Team_to)) + 
                         aes(x = tab_aug2$Season, 
                             y = tab_aug2$Transfer_fee) +
                         geom_point() + 
                         geom_line() + 
                         theme(axis.text.x = element_text(angle = 45, hjust = 1),
                               panel.grid.major = element_blank(),
                               panel.grid.minor = element_blank(),
                               legend.position = "none") +
                         scale_y_continuous(name = "Transfer fees") +
                         scale_x_discrete(name = "Season")
                     
                     output$evol <- renderPlot({evol},
                                               height = 400,
                                               width = 400)
                     
                     titre_graphique = paste("Transfers Fees Evolution [", input$player_name, "]")
                     
                     output$titre_graphique_player = renderText({titre_graphique})
                 }
             }
)












#clubs




observeEvent(input$recalc_club,
             {
                 Club$Name <- input$Club_name
                 Club$Season = input$season_pour_club
                 Club$Price = input$price_pour_club
                 
                 club_tab <- donnees_trans[(donnees_trans$Team_from == Club$Name | donnees_trans$Team_to == Club$Name) & 
                                               donnees_trans$Season %in% Club$Season &
                                               donnees_trans$Transfer_fee >= Club$Price[1] &
                                               donnees_trans$Transfer_fee <= Club$Price[2]]
                 # print(club_tab)
                 
                 if (nrow(club_tab) == 0 & input$player_or_club_or_season == "Club"){
                     # print("Please check the spelling")
                     sendSweetAlert(
                         session = session,
                         title = "Information",
                         text = "No transfer found according to the current selection choices. Please try something else.",
                         type = "info"
                     )
                     
                     
                     output$ligne1_titre_liste = renderText(NULL)
                     output$ligne2_titre_liste = renderText(NULL)
                     output$ligne3_titre_liste = renderText(NULL)
                     
                     leafletProxy("map") %>% 
                         clearMarkers() %>% 
                         clearShapes() %>%
                         setView(lng = -1.553621, lat = 47.218371, zoom = 6) %>% 
                         removeLayersControl()
                 } else if (nrow(club_tab) != 0 & input$player_or_club_or_season == "Club"){
                     club_aug <- club_tab %>%
                         left_join(clubs_trans[, c(1,12)], 
                                   by = c('Team_from' = "Clubs")) %>% 
                         rename(Pays_from = Pays) %>% 
                         left_join(clubs_trans[, c(1,12)], 
                                   by = c('Team_to' = "Clubs")) %>% 
                         rename(Pays_to = Pays) %>% 
                         left_join(clubs_trans[, c(1,14,15)], 
                                   by = c('Team_from' = "Clubs")) %>%
                         left_join(clubs_trans[, c(1,14,15)], 
                                   by = c('Team_to' = "Clubs"))
                     nb_trajets <- club_aug %>%
                         group_by(Team_from, Team_to) %>%
                         summarize(counts = n()) %>%
                         ungroup() %>%
                         arrange(desc(counts))
                     # print(nb_trajets)
                     
                     
                     club_aug2 = club_aug[complete.cases(club_aug[, 15:18]),]
                     Clubs_played = data.frame(Clubs_j = unique(c(club_aug2$Team_from, club_aug2$Team_to))) %>% 
                         left_join(clubs_trans[, c(1,14,15)], 
                                   by = c('Clubs_j' = "Clubs")) %>% 
                         left_join(tab_conversion_clubs, 
                                   by = c('Clubs_j'="tab_Transferts"))
                     # print(Clubs_played)
                     partners <- unlist(list(filter(Clubs_played, Clubs_j != Club$Name)[1]))
                     # print(partners)
                     list_url = c()
                     for (i in Clubs_played$tab_Fifa){
                         list_url = c(list_url,
                                      ifelse(identical(df_avec_logos[i == Club.y, Club.Logo1], character(0)),
                                             "no_logo_leaflet.png",
                                             df_avec_logos[i == Club.y, Club.Logo1]))}
                     Clubs_played$url = list_url
                     #print(Clubs_played$url)
                     Icons <- icons(
                         iconUrl = Clubs_played$url,
                         iconWidth = 25, iconHeight = 25,
                         iconAnchorX = 20, iconAnchorY = 20)
                     # print(partners[1])
                     n_club_aug <- filter(club_aug2,
                                          Team_from == partners[1] | Team_to == partners[1])
                     # print(n_club_aug)
                     # print(nrow(n_club_aug))
                     b <- as.numeric(filter(clubs_trans,Clubs == Club$Name)[14:15])
                     c <- as.numeric(filter(clubs_trans,Clubs == partners[1])[14:15])
                     n_flows <- N_flows_OD(b, c, N=nrow(n_club_aug))
                     #print(n_flows)
                     if(length(partners) > 1){
                         for(i in 2:length(partners)){
                             # print(partners[i])
                             
                             filtr_partn <- filter(club_aug2,
                                                   Team_from == partners[i] | Team_to == partners[i])
                             # print(nrow(filtr_partn))
                             # print(filtr_partn)
                             n_club_aug <- rbind(n_club_aug,
                                                 filtr_partn)
                             d <- as.numeric(filter(clubs_trans,
                                                    Clubs == partners[i])[14:15])
                             n_flows <- rbind(n_flows,
                                              N_flows_OD(b, d, N = nrow(filtr_partn)))
                             # print(length(N_flows_OD(b, d, N = nrow(filtr_partn))))
                         }
                     }
                     
                     
                     
                     #flows <- gcIntermediate(club_aug2[,15:16],club_aug2[,17:18], sp = F, addStartEnd = TRUE)
                     # print(length(n_flows))
                     # print(nrow(n_club_aug))
                     #print(n_flows)
                     
                     n_flows$counts <- n_club_aug$Transfer_fee/1000000
                     n_flows$origins <- n_club_aug$Team_from
                     n_flows$destinations <- n_club_aug$Team_to
                     n_flows$Pays_to = n_club_aug$Pays_to
                     
                     
                     
                     hover2 = c()
                     for (i in 1:length(n_flows$counts)){
                         hover2 = c(hover2,
                                    HTML(as.character(tagList(
                                        
                                        tags$h5(tags$strong(HTML(sprintf(paste("<center>", (as.character(n_club_aug$Name[i])), "</center>"))))),
                                        
                                        tags$h5(HTML(paste(n_flows$origins[i], " to ", 
                                                           n_flows$destinations[i]))),
                                        
                                        tags$strong(HTML(sprintf(" Price: %s%sM","&euro;",
                                                                 as.character(n_flows$counts[i]))
                                                         
                                        )), 
                                        
                                        tags$br(),
                                        
                                        sprintf("Season: %s", 
                                                n_club_aug$Season[i]), 
                                        
                                        tags$br(),
                                        
                                        sprintf("Age: %s ", 
                                                as.integer(n_club_aug$Age[i])), 
                                        
                                        tags$br(),
                                        
                                        ifelse(is.na(n_club_aug$ROI[i]),
                                               sprintf(""),
                                               sprintf("Seller ROI: %s%%", 100*round(as.numeric(n_club_aug$ROI[i]), 2))), tags$br(),
                                        
                                        HTML(ifelse(is.na(n_club_aug$ROI[i]),
                                                    sprintf(""),
                                                    ifelse(abs(n_club_aug$Market_value[i]/1000000) >= 1, sprintf("Market Value: %s%sM",
                                                                                                                 "&euro;",
                                                                                                                 n_club_aug$Market_value[i]/1000000),
                                                           sprintf("Market Value: %s%sk", "&euro;", n_club_aug$Market_value[i]/1000)))),
                                        
                                        tags$br(),
                                        
                                        HTML(ifelse(is.na(n_club_aug$ROI[i]),
                                                    sprintf(""),
                                                    ifelse(abs(n_club_aug$PV[i]/1000000)>=1,
                                                           ifelse(n_club_aug$PV[i] >= 0,
                                                                  sprintf("Realised Gain: %s%sM", "&euro;",
                                                                          n_club_aug$PV[i]/1000000),
                                                                  sprintf("Realised Gain: -%s%sM","&euro;",
                                                                          -n_club_aug$PV[i]/1000000)),
                                                           ifelse(n_club_aug$PV[i] >= 0,
                                                                  sprintf("Realised Gain: %s%sk", 
                                                                          "&euro;",
                                                                          n_club_aug$PV[i]/1000),
                                                                  sprintf("Realised Gain: -%s%sk","&euro;",
                                                                          -n_club_aug$PV[i]/1000)))))
                                        
                                        
                                    ))))
                     }
                     
                     lng_bar <- sum(Clubs_played$lon) / nrow(Clubs_played)
                     lat_bar <- sum(Clubs_played$lat) / nrow(Clubs_played)
                     Names_Icon = Clubs_played$tab_Fifa
                     if(sum(is.na(Names_Icon) > 0)){
                         Names_Icon[which(is.na(Names_Icon))] = Clubs_played$Clubs_j[which(is.na(Names_Icon))]
                     }
                     
                     
                     
                     leafletProxy("map") %>% 
                         clearMarkers() %>% 
                         clearShapes() %>% 
                         addPolylines(data = n_flows, 
                                      weight = 4, 
                                      label = lapply(hover2, FUN = HTML), 
                                      group = ~destinations,
                                      color=~pal(counts*1000000),
                                      smoothFactor = 0.8, 
                                      fillOpacity = 0.7) %>%
                         addMarkers(Clubs_played$lon,
                                    Clubs_played$lat, 
                                    icon = Icons,
                                    label=Names_Icon,
                                    options = markerOptions(draggable = T)) %>% 
                         addLayersControl(overlayGroups = unique(n_flows$destinations),
                                          options = layersControlOptions(collapsed = FALSE)) %>% 
                         setView(lng = lng_bar,
                                 lat = lat_bar,
                                 zoom = if(abs(lat_bar-min(Clubs_played$lat)) < 3 & abs(lng_bar-min(Clubs_played$lon)) < 2.5){
                                     7
                                 } else if(abs(lat_bar-min(Clubs_played$lat)) < 7.5 & abs(lng_bar-min(Clubs_played$lon)) < 4){
                                     5
                                 } else if(abs(lat_bar-min(Clubs_played$lat)) < 7 & abs(lng_bar-min(Clubs_played$lon)) < 6){
                                     4
                                 } else if(abs(lat_bar-min(Clubs_played$lat)) > 10 | abs(lng_bar-min(Clubs_played$lon)) > 10){
                                     2 # auparavant 1
                                 } else {
                                     3.5
                                 } #%>% addFullscreenControl()
                         )
                     
                     
                     D = na.omit(filter(club_aug2,
                                        Name == club_aug2[order("Transfer_fee")])[1:10, c(1,4,6,10)])
                     top_player <- D[, c(1,4)]
                     top_player$Transfer_fee = paste0("€", as.character(top_player$Transfer_fee/1000000), " M")
                     top_player$Direction = ifelse(D$Team_from != Club$Name,
                                                   paste0("from ", as.character(D$Team_from)),
                                                   paste0("to ", as.character(D$Team_to)))
                     output$top_player <- renderTable({top_player})
                     
                     ligne1_titre_liste_club = paste("Club:", input$Club_name)
                     ligne2_titre_liste_club = ifelse(length(input$season_pour_club) == length(seasons),
                                                      paste("Seasons: All [ from", seasons[1], "to", seasons[length(seasons)], "]"),
                                                      paste("Seasons: ", paste(unlist(input$season_pour_club), collapse = ", "), collapse = ""))
                     ligne3_titre_liste_club = paste("Fees range: from €", input$price_pour_club[1], " to €", input$price_pour_club[2],
                                                     collapse = "")
                     
                     output$ligne0_titre_liste = renderText("Most Expensive Transfers:")
                     output$ligne1_titre_liste = renderText({ligne1_titre_liste_club})
                     output$ligne2_titre_liste = renderText({ligne2_titre_liste_club})
                     output$ligne3_titre_liste = renderText({ligne3_titre_liste_club})
                 }
             }
)



#mercato

observeEvent(input$recalc_season,
             {
                 
                 Mercatos$Name <- input$Mercatos_choices
                 Mercatos$Price = input$price_pour_season
                 
                 mercato_tab <- donnees_trans[donnees_trans$Season %in% Mercatos$Name &
                                                  donnees_trans$Transfer_fee >= Mercatos$Price[1] &
                                                  donnees_trans$Transfer_fee <= Mercatos$Price[2]][order(-Transfer_fee)]
                 if (nrow(mercato_tab) == 0 & input$player_or_club_or_season == "Mercato"){
                     # print("Please check the spelling")
                     sendSweetAlert(
                         session = session,
                         title = "Information",
                         text = "No transfer found according to the current selection choices. Please try something else.",
                         type = "info"
                     )
                     
                     
                     output$ligne1_titre_liste = renderText(NULL)
                     output$ligne2_titre_liste = renderText(NULL)
                     output$ligne3_titre_liste = renderText(NULL)
                     
                     leafletProxy("map") %>% 
                         clearMarkers() %>% 
                         clearShapes() %>%
                         setView(lng = -1.553621, lat = 47.218371, zoom = 6) %>% 
                         removeLayersControl()
                 } else if (nrow(mercato_tab) != 0 & input$player_or_club_or_season == "Mercato"){
                     tab_mercato_aug <- mercato_tab %>%
                         left_join(clubs_trans[, c(1,12)], 
                                   by = c('Team_from' = "Clubs")) %>% 
                         rename(Pays_from = Pays) %>% 
                         left_join(clubs_trans[, c(1,12)], 
                                   by = c('Team_to' = "Clubs")) %>% 
                         rename(Pays_to = Pays) %>% 
                         left_join(clubs_trans[, c(1,14,15)], 
                                   by = c('Team_from' = "Clubs")) %>%
                         left_join(clubs_trans[, c(1,14,15)], 
                                   by = c('Team_to' = "Clubs"))
                     # print(tab_mercato_aug)
                     mercato_aug2 = tab_mercato_aug[complete.cases(tab_mercato_aug[, 15:18]),]
                     Clubs_played = data.frame(Clubs_j = unique(c(mercato_aug2$Team_from, mercato_aug2$Team_to))) %>% 
                         left_join(clubs_trans[, c(1,14,15)], 
                                   by = c('Clubs_j' = "Clubs")) %>% 
                         left_join(tab_conversion_clubs,
                                   by = c('Clubs_j' = "tab_Transferts"))
                     #print(Clubs_played)
                     list_url = c()
                     for (i in Clubs_played$tab_Fifa){
                         list_url = c(list_url,
                                      ifelse(identical(df_avec_logos[i == Club.y, Club.Logo1], character(0)),
                                             "no_logo_leaflet.png",
                                             df_avec_logos[i == Club.y, Club.Logo1]))
                     }
                     Clubs_played$url = list_url
                     #print(Clubs_played$url)
                     Icons <- icons(
                         iconUrl = Clubs_played$url,
                         iconWidth = 25, iconHeight = 25,
                         iconAnchorX = 20, iconAnchorY = 20)
                     
                     flows <- gcIntermediate(mercato_aug2[, 15:16], mercato_aug2[, 17:18], sp = T, addStartEnd = TRUE)
                     flows$counts <- mercato_aug2$Transfer_fee/1000000
                     flows$origins <- mercato_aug2$Team_from
                     flows$destinations <- mercato_aug2$Team_to
                     flows$Pays_to = mercato_aug2$Pays_to
                     
                     
                     
                     hover2 = c()
                     for (i in 1:length(flows$counts)){
                         hover2 = c(hover2,
                                    HTML(as.character(tagList(
                                        tags$h5(tags$strong(HTML(
                                            sprintf(paste("<center>", (as.character(mercato_aug2$Name[i])), "</center>"))))),
                                        
                                        tags$h5(HTML(
                                            paste(flows$origins[i], " to ", flows$destinations[i]))),
                                        
                                        tags$strong(HTML(
                                            sprintf(" for : %s%sM","&euro;", as.character(flows$counts[i]))
                                            
                                        )), 
                                        tags$br(),
                                        
                                        sprintf("Season: %s", mercato_aug2$Season[i]), tags$br(),
                                        
                                        sprintf("Age: %s ", as.integer(mercato_aug2$Age[i])), tags$br(),
                                        
                                        ifelse(is.na(mercato_aug2$ROI[i]),
                                               sprintf(""),
                                               sprintf("Seller ROI: %s%%", 100*round(as.numeric(mercato_aug2$ROI[i]), 2))),
                                        
                                        tags$br(),
                                        
                                        HTML(ifelse(is.na(mercato_aug2$ROI[i]),
                                                    sprintf(""),
                                                    ifelse(abs(mercato_aug2$Market_value[i]/1000000) >= 1,
                                                           sprintf("Market Value: %s%sM","&euro;", mercato_aug2$Market_value[i]/1000000),
                                                           sprintf("Market Value: %s%sk","&euro;", mercato_aug2$Market_value[i]/1000)))),
                                        
                                        tags$br(),
                                        
                                        HTML(ifelse(is.na(mercato_aug2$ROI[i]),
                                                    sprintf(""),
                                                    ifelse(abs(mercato_aug2$PV[i]/1000000) >= 1,
                                                           ifelse(mercato_aug2$PV[i] >= 0,
                                                                  sprintf("Realised Gain: %s%sM","&euro;", mercato_aug2$PV[i]/1000000),
                                                                  sprintf("Realised Gain: -%s%sM","&euro;", -mercato_aug2$PV[i]/1000000)), 
                                                           ifelse(mercato_aug2$PV[i] >= 0,
                                                                  sprintf("Realised Gain: %s%sk","&euro;",
                                                                          mercato_aug2$PV[i]/1000),
                                                                  sprintf("Realised Gain: -%s%sk","&euro;", -mercato_aug2$PV[i]/1000)))))
                                    ))))
                     }
                     
                     
                     lng_bar <- sum(Clubs_played$lon)/nrow(Clubs_played)
                     lat_bar <- sum(Clubs_played$lat)/nrow(Clubs_played)
                     Names_Icon = Clubs_played$tab_Fifa
                     if(sum(is.na(Names_Icon) > 0)){
                         Names_Icon[which(is.na(Names_Icon))] = Clubs_played$Clubs_j[which(is.na(Names_Icon))]
                     }
                     
                     
                     
                     leafletProxy("map") %>% 
                         clearMarkers() %>% 
                         clearShapes() %>% 
                         addPolylines(data = flows, 
                                      weight = 3.5, 
                                      label = lapply(hover2, FUN = HTML), 
                                      group = ~destinations,
                                      color= ~pal(counts*1000000),
                                      smoothFactor = 0.8, 
                                      fillOpacity = 0.7) %>% 
                         addMarkers(Clubs_played$lon,
                                    Clubs_played$lat, 
                                    icon = Icons,
                                    label = Names_Icon,
                                    options = markerOptions(draggable = T)) %>% 
                         addLayersControl(overlayGroups = unique(flows$destinations),
                                          options = layersControlOptions(collapsed = FALSE)) %>% 
                         setView(lng = lng_bar ,
                                 lat = lat_bar,
                                 zoom = if(abs(lat_bar-min(Clubs_played$lat)) < 3 & abs(lng_bar-min(Clubs_played$lon)) < 2.5){
                                     7
                                 } else if (abs(lat_bar-min(Clubs_played$lat)) < 7.5 & abs(lng_bar-min(Clubs_played$lon)) < 4){
                                     5
                                 } else if (abs(lat_bar-min(Clubs_played$lat)) < 7 & abs(lng_bar-min(Clubs_played$lon)) < 6){
                                     4
                                 } else if (abs(lat_bar-min(Clubs_played$lat)) > 10 | abs(lng_bar-min(Clubs_played$lon)) > 10){
                                     2 # auparavant 1
                                 } else{
                                     3.5
                                 }
                         ) #%>% 
                     #addFullscreenControl()
                     
                     
                     D <- na.omit(filter(mercato_aug2,
                                          Name == mercato_aug2[order("Transfer_fee")])[1:10, c(1,4,6,10)])
                     top_player <- D[ ,c(1,4)]
                     top_player$Transfer_fee = paste0("€", as.character(top_player$Transfer_fee/1000000), " M")
                     top_player$Direction = ifelse(D$Team_from != Club$Name,
                                                   paste0("from ", as.character(D$Team_from)),
                                                   paste0("to ", as.character(D$Team_to)))
                     output$top_player <- renderTable({top_player}) 
                     
                     
                     ligne1_titre_liste_mercato = ifelse(length(input$Mercatos_choices) == length(seasons),
                                                      paste("Seasons: All [ from", seasons[1], "to", seasons[length(seasons)], "]"),
                                                      paste("Seasons: ", paste(unlist(input$Mercatos_choices), collapse = ", "), collapse = ""))
                     ligne2_titre_liste_mercato = paste("Fees range: from €", input$price_pour_season[1], " to €", input$price_pour_season[2],
                                                        collapse = "")
                     
                     output$ligne0_titre_liste = renderText("Most Expensive Transfers:")
                     output$ligne1_titre_liste = renderText({ligne1_titre_liste_mercato})
                     output$ligne2_titre_liste = renderText({ligne2_titre_liste_mercato})
                     output$ligne3_titre_liste = renderText({NULL})
                 }
             }
)