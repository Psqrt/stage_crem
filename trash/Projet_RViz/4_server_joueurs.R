###############################################################################################################################
############ TABLE PRINCIPALE #################################################################################################
###############################################################################################################################


output$tableau_joueurs_initial <- DT::renderDataTable({input$button_ok_characteristics # ISOLATION - Pour la 2eme partie du filtrage
    
    ### 1ERE PARTIE DU FILTRAGE : CARACTÉRISTIQUES STANDARDS DU PANEL DE BASE #################################################
    table_avant_char_filtre = donnees_joueurs %>%
    {if (input$club_filtre != "...") filter(., Club == input$club_filtre) else filter(.)} %>%
        filter(Age >= input$age_filtre[1] & Age <= input$age_filtre[2]) %>%
        {if (input$nationalite_filtre != "...") filter(., Nationality == input$nationalite_filtre) else filter(.)} %>%
        filter(Overall >= input$overall_filtre[1] & Overall <= input$overall_filtre[2]) %>%
        filter(Potential >= input$potential_filtre[1] & Potential <= input$potential_filtre[2]) %>%
        filter(Value >= input$value_filtre[1] & Value <= input$value_filtre[2]) %>%
        filter(Wage >= input$salaire_filtre[1] & Wage <= input$salaire_filtre[2]) %>%
        {if (input$foot_filtre != "...") filter(., Preferred.Foot == input$foot_filtre) else filter(.)}
    
    ### 2EME PARTIE DU FILTRAGE : CARACTÉRISTIQUES CHARACTERISTICS DU DROPDOWNBUTTON 1 ########################################
    table_apres_char_filtre = table_avant_char_filtre %>% 
    {if (isolate(input$chars_non_assignes) == TRUE) filter(., is.na(.$Crossing)) else filter(., Crossing >= isolate(input$crossing_char_filtre) &
                                                                                                 Finishing >= isolate(input$finishing_char_filtre) &
                                                                                                 HeadingAccuracy >= isolate(input$headingaccuracy_char_filtre) &
                                                                                                 ShortPassing >= isolate(input$shortpassing_char_filtre) &
                                                                                                 Volleys >= isolate(input$volleys_char_filtre) &
                                                                                                 Dribbling >= isolate(input$dribbling_char_filtre) &
                                                                                                 Curve >= isolate(input$curve_char_filtre) &
                                                                                                 FKAccuracy >= isolate(input$fkaccuracy_char_filtre) &
                                                                                                 LongPassing >= isolate(input$longpassing_char_filtre) &
                                                                                                 BallControl >= isolate(input$ballcontrol_char_filtre) &
                                                                                                 Acceleration >= isolate(input$acceleration_char_filtre) &
                                                                                                 SprintSpeed >= isolate(input$sprintspeed_char_filtre) &
                                                                                                 Agility >= isolate(input$agility_char_filtre) &
                                                                                                 Reactions >= isolate(input$reactions_char_filtre) &
                                                                                                 Balance >= isolate(input$balance_char_filtre) &
                                                                                                 ShotPower >= isolate(input$shotpower_char_filtre) &
                                                                                                 Jumping >= isolate(input$jumping_char_filtre) &
                                                                                                 Stamina >= isolate(input$stamina_char_filtre) &
                                                                                                 Strength >= isolate(input$strength_char_filtre) &
                                                                                                 LongShots >= isolate(input$longshots_char_filtre) &
                                                                                                 Aggression >= isolate(input$aggression_char_filtre) &
                                                                                                 Interceptions >= isolate(input$interceptions_char_filtre) &
                                                                                                 Positioning >= isolate(input$positioning_char_filtre) &
                                                                                                 Vision >= isolate(input$vision_char_filtre) &
                                                                                                 Penalties >= isolate(input$penalties_char_filtre) &
                                                                                                 Composure >= isolate(input$composure_char_filtre) &
                                                                                                 Marking >= isolate(input$marking_char_filtre) &
                                                                                                 StandingTackle >= isolate(input$standingtackle_char_filtre) &
                                                                                                 SlidingTackle >= isolate(input$slidingtackle_char_filtre) &
                                                                                                 GKDiving >= isolate(input$gkdiving_char_filtre) &
                                                                                                 GKHandling >= isolate(input$gkhandling_char_filtre) &
                                                                                                 GKKicking >= isolate(input$gkkicking_char_filtre) &
                                                                                                 GKPositioning >= isolate(input$gkpositioning_char_filtre) &
                                                                                                 GKReflexes >= isolate(input$gkreflexes_char_filtre))
    }
    
    ### 3EME PARTIE DU FILTRAGE : CARACTÉRISTIQUES POSITIONING DU DROPDOWNBUTTON 2 ############################################
    # liste de toutes les positions sélectionnées
    liste_pos_selection = c(input$positions_ligne1,
                            input$positions_ligne2,
                            input$positions_ligne3,
                            input$positions_ligne4,
                            input$positions_ligne5,
                            input$positions_ligne6,
                            input$positions_ligne7)
    
    # si box cochée, alors on rajoute les non assignés.
    {if (input$postes_non_assignes) {liste_pos_selection = c(liste_pos_selection, "UNKNOWN")}}
    
    # filtrage element dans liste
    table_apres_pos_filtre = table_apres_char_filtre %>%
        filter(Position %in% liste_pos_selection)
    
    table_apres_pos_filtre_donnees <<- table_apres_pos_filtre 
    # choix de colonnes à afficher
    liste_infos_de_base = c("ID", "Photo", "Name", "Age", "Nationality", "Overall", "Potential", "Position", "Club", "Value", "Wage")
    
    table_apres_pos_filtre %>%
        mutate(Nationality = paste0(Nationality, " ", Flag), # espace optionnel puisque float:right sur l'image
               Club = paste0(Club, " ", Club.Logo)) %>% # espace optionnel puisque float:right sur l'image
        select(liste_infos_de_base)
    # rename("Rank" = ".Rank") 
},
escape = FALSE, # FALSE pour afficher les images dans les balises HTML
options = list(stateSave = TRUE, columnDefs = list(list(width = "150px", targets = 9))),
selection = "single") # largeur arbitraire pour la colonne des Clubs







###############################################################################################################################
############ BOUTONS D'ACTIVATION #############################################################################################
###############################################################################################################################
# Bouton reset des characteristics
observeEvent(input$button_reset_characteristics,
             {
                 shinyjs::reset("menu_char_select1")
                 shinyjs::reset("menu_char_select2")
                 shinyjs::reset("menu_char_select3")
                 shinyjs::reset("menu_char_select4")
                 shinyjs::reset("menu_char_select5")
                 shinyjs::reset("menu_char_select6")
                 shinyjs::reset("menu_char_select7")
                 updateCheckboxInput(session, "chars_non_assignes", value = FALSE)
             }) 

# Bouton selectall des positionings
observeEvent(input$positions_selectall_button,
             {
                 # Sys.sleep(10) # utile pour tester le gif
                 updateCheckboxGroupButtons(session, "positions_ligne1", selected = liste_positions_ordre_terrain[1:3])
                 updateCheckboxGroupButtons(session, "positions_ligne2", selected = liste_positions_ordre_terrain[4:6])
                 updateCheckboxGroupButtons(session, "positions_ligne3", selected = liste_positions_ordre_terrain[7:11])
                 updateCheckboxGroupButtons(session, "positions_ligne4", selected = liste_positions_ordre_terrain[12:16])
                 updateCheckboxGroupButtons(session, "positions_ligne5", selected = liste_positions_ordre_terrain[17:21])
                 updateCheckboxGroupButtons(session, "positions_ligne6", selected = liste_positions_ordre_terrain[22:26])
                 updateCheckboxGroupButtons(session, "positions_ligne7", selected = liste_positions_ordre_terrain[27])
             })        

# Bouton unselectall des positionings
observeEvent(input$positions_unselectall_button,
             {
                 updateCheckboxGroupButtons(session, "positions_ligne1", selected = "999a") # n'accepte pas des NA ou vide, donc bricolage
                 updateCheckboxGroupButtons(session = session, "positions_ligne2", selected = "999b")
                 updateCheckboxGroupButtons(session = session, "positions_ligne3", selected = "999c")
                 updateCheckboxGroupButtons(session = session, "positions_ligne4", selected = "999d")
                 updateCheckboxGroupButtons(session = session, "positions_ligne5", selected = "999e")
                 updateCheckboxGroupButtons(session, "positions_ligne6", selected = "999f")
                 updateCheckboxGroupButtons(session, "positions_ligne7", selected = "999g")
             })





###############################################################################################################################
############ POP-UP FICHE JOUEUR ##############################################################################################
###############################################################################################################################
observeEvent(input$fichejoueur, # tableau_joueurs_initial_rows_selected
             {
                 updateSelectInput(
                     session,
                     inputId = "goalkeeper_comparaison",
                     selected = "..."
                 )
                 updateSelectInput(
                     session,
                     inputId = "field_comparaison",
                     selected = "..."
                 )})

observeEvent(input$tableau_joueurs_initial_row_last_clicked,{
    
    # print(input$tableau_joueurs_initial_row_last_clicked)
    ############ Récupération données #############################################################################################
    stats_cible <<- table_apres_pos_filtre_donnees[input$tableau_joueurs_initial_row_last_clicked, ]
    
    
    ############ Préparation des sorties chiffrées ################################################################################
    # PANEL TOP
    output$fiche_joueur_photo = renderText({stats_cible$Photo0})
    output$fiche_joueur_nom = renderText({stats_cible$Name})
    output$fiche_joueur_id = renderText({paste("ID: ", stats_cible$ID)})
    output$fiche_joueur_nationalite = renderText({paste(stats_cible$Flag0, stats_cible$Nationality)})
    output$fiche_joueur_age = renderText({paste("Age: ", stats_cible$Age)})
    output$fiche_joueur_hauteur = renderText({paste("Height (cm):", stats_cible$Height)})
    output$fiche_joueur_poids = renderText({paste("Weight (kg):", stats_cible$Weight)})
    output$fiche_joueur_pied_fav = renderText({paste("Preferred Foot:", stats_cible$Preferred.Foot)})
    output$fiche_joueur_club_seul = renderText({paste("Club:", stats_cible$Club)})
    # PANEL SUBTOP
    output$fiche_joueur_overall = renderText({paste("Overall: ", stats_cible$Overall)})
    output$fiche_joueur_potential = renderText({paste("Potential: ", stats_cible$Potential)})
    output$fiche_joueur_value = renderText({paste("Value (millions): ", stats_cible$Value)})
    etoiles_international = paste(rep(etoile, as.integer(stats_cible$International.Reputation)), collapse = "")
    etoiles_weakfoot = paste(rep(etoile, as.integer(stats_cible$Weak.Foot)), collapse = "")
    etoiles_skillmoves = paste(rep(etoile, as.integer(stats_cible$Skill.Moves)), collapse = "")
    output$fiche_joueur_international = renderText({paste("International Reputation: ", etoiles_international)})
    output$fiche_joueur_weakfoot = renderText({paste("Weak Foot: ", etoiles_weakfoot)})
    output$fiche_joueur_skillmoves = renderText({paste("Skill Moves: ", etoiles_skillmoves)})
    output$fiche_joueur_workrate = renderText({paste("Field Work Rate: ", stats_cible$Work.Rate)})
    output$fiche_joueur_bodytype = renderText({paste("Body Type: ", stats_cible$Body.Type)})
    # PANEL MID
    output$fiche_joueur_club_double = renderText({paste(stats_cible$Club.Logo0, stats_cible$Club)})
    output$fiche_joueur_position = renderText({paste("Position: ", stats_cible$Position)})
    output$fiche_joueur_jersey = renderText({paste("Jersey: ", stats_cible$Jersey.Number)})
    output$fiche_joueur_salaire = renderText({paste("Wage: €", stats_cible$Wage, "k", collapse = "")})
    stats_cible$Joined2 = round(as.integer(unclass(Sys.Date() - mdy(stats_cible$Joined))[1]) / 365) # années d'ancienneté dans le club
    output$fiche_joueur_joined = {if (stats_cible$Joined != "") renderText({paste("Joined: ", stats_cible$Joined, " (", stats_cible$Joined2, " year(s) ago)", sep = "")}) else renderText({paste("Joined: NA (loaned from ", stats_cible$Loaned.From, ")", sep = "")})}
    output$fiche_joueur_until = renderText({paste("Contract until: ", stats_cible$Contract.Valid.Until)})
    output$fiche_joueur_release = {if (!is.na(stats_cible$Release.Clause)) renderText({paste("Release Clause: €", stats_cible$Release.Clause, "M")}) else renderText({paste("Release Clause : Unavailable for this player")})}
    
    ############ Préparation graphique terrain ################################################################################
    
    position_first_stat_placement <<- which(colnames(stats_cible) == "LS")
    position_last_stat_placement <<- which(colnames(stats_cible) == "RB")
    
    stats_cible_scores_placement <<- apply(stats_cible[1, position_first_stat_placement:position_last_stat_placement],
                                           MARGIN = 2,
                                           str_split_fixed, "\\+", n = 2)[1, ]
    stats_cible_scores_placement <<- as.data.frame(stats_cible_scores_placement, stringsAsFactors = F)
    stats_cible_scores_placement$stats_cible_scores_placement <<- as.integer(stats_cible_scores_placement$stats_cible_scores_placement)
    stats_cible_scores_placement = postes_coordonnees %>% mutate(score = stats_cible_scores_placement$stats_cible_scores_placement)
    
    q = ggplot(stats_cible_scores_placement) +
        aes(x = x, y = y, col = score) +
        annotation_custom(bg_terrain, xmin = -Inf, ymin = 0, xmax = +Inf, ymax = 10) +
        geom_point(size = 20, alpha = 0.5) +
        scale_color_continuous(low = "yellow", high = "red") +
        scale_x_continuous(limits = c(-20, 20)) +
        scale_y_continuous(limits = c(0, 10)) +
        geom_text(label = stats_cible_scores_placement$score, alpha = 1, color = "white", size = 5) +
        coord_fixed(ratio = 1, xlim = c(0, 20), y = c(0, 10)) + 
        theme_void() +
        theme(legend.position = "none") +
        geom_text(label = ifelse(stats_cible$Position == "GK", "No score available for goalkeepers", ""), x = 10, y = 5, col = "red", size = 8)
    
    output$graph_terrain = renderPlot({q},
                                      bg = "transparent")
    
    ############ Préparation radar ############################################################################################
    position_first_stat_pos <<- which(colnames(stats_cible) == "Crossing")
    position_last_stat_pos <<- which(colnames(stats_cible) == "GKReflexes")
    
    
    stats_cible_scores_char <<- apply(stats_cible[1, position_first_stat_pos:position_last_stat_pos],
                                      MARGIN = 2,
                                      str_split_fixed, "\\+", n = 2)[1, ]
    stats_cible_scores_char <<- as.data.frame(stats_cible_scores_char, stringsAsFactors = F)
    stats_cible_scores_char$stats_cible_scores_char <<- as.integer(stats_cible_scores_char$stats_cible_scores_char)
    stats_cible_scores_char <<- as.data.frame(t(stats_cible_scores_char), stringsAsFactors = F)
    rownames(stats_cible_scores_char) <<- c(stats_cible$Name[1])
    stats_cible_scores_char <<- rownames_to_column(stats_cible_scores_char, var = "group")
    
    #### GOAL KEEPER RADAR ####
    if (stats_cible$Position[1] == "GK"){
        updateSelectInput(
            session,
            inputId = "invisible",
            selected = "GK"
        )
        
        
        deb_goalkeeping <<- which(colnames(stats_cible_scores_char) == "GKDiving")
        fin_goalkeeping <<- which(colnames(stats_cible_scores_char) == "GKReflexes")
        
        
        radarly4 <<- plot_ly(
            type = "scatterpolar",
            fill = "toself",
            hoverinfo = "text"
        ) %>% add_trace(
            r = as.integer(stats_cible_scores_char[1, deb_goalkeeping:fin_goalkeeping]),
            theta = colnames(stats_cible_scores_char)[deb_goalkeeping:fin_goalkeeping],
            name = stats_cible_scores_char[1, 1],
            text = paste("Score :", stats_cible_scores_char[31:35])
        ) %>% layout(
            polar = list(
                radialaxis = list(
                    visible = T,
                    range = c(0, 100)
                )
            )
        ) %>% 
            layout(
                plot_bgcolor = "transparent"
            ) %>% 
            layout(
                paper_bgcolor = "transparent"
            )
        
        
        
        
        
    } else {
        #### FIELD RADAR ####
        updateSelectInput(
            session,
            inputId = "invisible",
            selected = "Field"
        )
        
        
        deb_attacking <<- which(colnames(stats_cible_scores_char) == "Crossing")
        fin_attacking <<- which(colnames(stats_cible_scores_char) == "Volleys")
        deb_skill <<- which(colnames(stats_cible_scores_char) == "Dribbling")
        fin_skill <<- which(colnames(stats_cible_scores_char) == "BallControl")
        deb_movement <<- which(colnames(stats_cible_scores_char) == "Acceleration")
        fin_movement <<- which(colnames(stats_cible_scores_char) == "Balance")
        deb_power <<- which(colnames(stats_cible_scores_char) == "ShotPower")
        fin_power <<- which(colnames(stats_cible_scores_char) == "LongShots")
        deb_mentality <<- which(colnames(stats_cible_scores_char) == "Aggression")
        fin_mentality <<- which(colnames(stats_cible_scores_char) == "Composure")
        deb_defending <<- which(colnames(stats_cible_scores_char) == "Marking")
        fin_defending <<- which(colnames(stats_cible_scores_char) == "SlidingTackle")
        deb_goalkeeping <<- which(colnames(stats_cible_scores_char) == "GKDiving")
        fin_goalkeeping <<- which(colnames(stats_cible_scores_char) == "GKReflexes")
        stats_cible_scores_char$attacking <<- round(sum(stats_cible_scores_char[1, deb_attacking:fin_attacking])/(fin_attacking - deb_attacking + 1))
        stats_cible_scores_char$skill <<- round(sum(stats_cible_scores_char[1, deb_skill:fin_skill])/(fin_skill - deb_skill + 1))
        stats_cible_scores_char$movement <<- round(sum(stats_cible_scores_char[1, deb_movement:fin_movement])/(fin_movement - deb_movement + 1))
        stats_cible_scores_char$power <<- round(sum(stats_cible_scores_char[1, deb_power:fin_power])/(fin_power - deb_power + 1))
        stats_cible_scores_char$mentality <<- round(sum(stats_cible_scores_char[1, deb_mentality:fin_mentality])/(fin_mentality - deb_mentality + 1))
        stats_cible_scores_char$defending <<- round(sum(stats_cible_scores_char[1, deb_defending:fin_defending])/(fin_defending - deb_defending + 1))
        stats_cible_scores_char$goalkeeping <<- round(sum(stats_cible_scores_char[1, deb_goalkeeping:fin_goalkeeping])/(fin_goalkeeping - deb_goalkeeping + 1))
        deb_fieldplayer <<- which(colnames(stats_cible_scores_char) == "attacking")
        fin_fieldplayer <<- which(colnames(stats_cible_scores_char) == "goalkeeping")
        
        ###
        
        radarly4 <<- plot_ly(
            type = "scatterpolar",
            fill = "toself",
            hoverinfo = "text"
        ) %>% add_trace(
            r = as.integer(stats_cible_scores_char[1, deb_fieldplayer:fin_fieldplayer]),
            theta = colnames(stats_cible_scores_char)[deb_fieldplayer:fin_fieldplayer],
            name = stats_cible_scores_char[1, 1],
            text = paste("Score :", stats_cible_scores_char[36:42])
        ) %>% layout(
            polar = list(
                radialaxis = list(
                    visible = T,
                    range = c(0, 100)
                )
            )
        ) %>% 
            layout(
                plot_bgcolor = "transparent"
            ) %>% 
            layout(
                paper_bgcolor = "transparent"
            )
        
    }
    
    #### Radar par défaut (pas de comparaison) ####
    output$fiche_joueur_radar4 = renderPlotly({radarly4})
    
    ########
    
    ############ Préparation radar comparaison GK #############################################################################
    observeEvent(input$goalkeeper_comparaison,
                 {
                     if (input$goalkeeper_comparaison == "..."){
                         updateSelectInput(
                             session,
                             inputId = "invisible2",
                             selected = "Solo"
                         )
                         
                         
                         radarly5 = radarly4
                     } else {
                         updateSelectInput(
                             session,
                             inputId = "invisible2",
                             selected = "Double"
                         )
                         
                         stats_cible_2 = donnees_joueurs[donnees_joueurs$ID == input$goalkeeper_comparaison, ]
                         
                         stats_cible_scores_char_2 = apply(stats_cible_2[1, position_first_stat_pos:position_last_stat_pos],
                                                           MARGIN = 2,
                                                           str_split_fixed, "\\+", n = 2)[1, ]
                         stats_cible_scores_char_2 = as.data.frame(stats_cible_scores_char_2, stringsAsFactors = F)
                         stats_cible_scores_char_2$stats_cible_scores_char_2 = as.integer(stats_cible_scores_char_2$stats_cible_scores_char_2)
                         stats_cible_scores_char_2 = as.data.frame(t(stats_cible_scores_char_2), stringsAsFactors = F)
                         rownames(stats_cible_scores_char_2) = c(stats_cible_2$Name[1])
                         stats_cible_scores_char_2 = rownames_to_column(stats_cible_scores_char_2, var = "group")
                         deb_goalkeeping = which(colnames(stats_cible_scores_char_2) == "GKDiving")
                         fin_goalkeeping = which(colnames(stats_cible_scores_char_2) == "GKReflexes")
                         
                         radarly5 = radarly4 %>% add_trace(
                             r = as.integer(stats_cible_scores_char_2[1, deb_goalkeeping:fin_goalkeeping]),
                             theta = colnames(stats_cible_scores_char_2)[deb_goalkeeping:fin_goalkeeping],
                             name = stats_cible_scores_char_2[1, 1],
                             text = paste("Score :", stats_cible_scores_char_2[31:35]),
                             opacity = 0.6
                         ) %>% 
                             layout(
                                 plot_bgcolor = "transparent"
                             ) %>% 
                             layout(
                                 paper_bgcolor = "transparent"
                             )
                         
                         output$fiche_joueur_radar5 = renderPlotly({radarly5})
                         
                     }
                     
                     ###
                 }
    )
    
    
    
    ############ Préparation radar comparaison !GK ############################################################################
    observeEvent(input$field_comparaison,
                 
                 {
                     ###
                     
                     if (input$field_comparaison == "..."){
                         updateSelectInput(
                             session,
                             inputId = "invisible3",
                             selected = "Solo"
                         )
                     } else {
                         updateSelectInput(
                             session,
                             inputId = "invisible3",
                             selected = "Double"
                         )
                         
                         stats_cible_3 = donnees_joueurs[donnees_joueurs$ID == input$field_comparaison, ]
                         
                         
                         stats_cible_scores_char_3 = apply(stats_cible_3[1, position_first_stat_pos:position_last_stat_pos],
                                                           MARGIN = 2,
                                                           str_split_fixed, "\\+", n = 2)[1, ]
                         stats_cible_scores_char_3 = as.data.frame(stats_cible_scores_char_3, stringsAsFactors = F)
                         stats_cible_scores_char_3$stats_cible_scores_char_3 = as.integer(stats_cible_scores_char_3$stats_cible_scores_char_3)
                         stats_cible_scores_char_3 = as.data.frame(t(stats_cible_scores_char_3), stringsAsFactors = F)
                         rownames(stats_cible_scores_char_3) = c(stats_cible_3$Name[1])
                         stats_cible_scores_char_3 = rownames_to_column(stats_cible_scores_char_3, var = "group")
                         
                         
                         stats_cible_scores_char_3$attacking = round(sum(stats_cible_scores_char_3[1, deb_attacking:fin_attacking])/(fin_attacking - deb_attacking + 1))
                         stats_cible_scores_char_3$skill = round(sum(stats_cible_scores_char_3[1, deb_skill:fin_skill])/(fin_skill - deb_skill + 1))
                         stats_cible_scores_char_3$movement = round(sum(stats_cible_scores_char_3[1, deb_movement:fin_movement])/(fin_movement - deb_movement + 1))
                         stats_cible_scores_char_3$power = round(sum(stats_cible_scores_char_3[1, deb_power:fin_power])/(fin_power - deb_power + 1))
                         stats_cible_scores_char_3$mentality = round(sum(stats_cible_scores_char_3[1, deb_mentality:fin_mentality])/(fin_mentality - deb_mentality + 1))
                         stats_cible_scores_char_3$defending = round(sum(stats_cible_scores_char_3[1, deb_defending:fin_defending])/(fin_defending - deb_defending + 1))
                         stats_cible_scores_char_3$goalkeeping = round(sum(stats_cible_scores_char_3[1, deb_goalkeeping:fin_goalkeeping])/(fin_goalkeeping - deb_goalkeeping + 1))
                         
                         
                         radarly6 = radarly4 %>% add_trace(
                             r = as.integer(stats_cible_scores_char_3[1, deb_fieldplayer:fin_fieldplayer]),
                             theta = colnames(stats_cible_scores_char_3)[deb_fieldplayer:fin_fieldplayer],
                             name = stats_cible_scores_char_3[1, 1],
                             text = paste("Score :", stats_cible_scores_char_3[36:42]),
                             opacity = 0.6
                         ) %>% 
                             layout(
                                 plot_bgcolor = "transparent"
                             ) %>% 
                             layout(
                                 paper_bgcolor = "transparent"
                             )
                         
                         output$fiche_joueur_radar6 = renderPlotly({radarly6})
                         
                     }
                 }
    )
    
    
    #### Apparition du pop-up fichejoueur ####
    toggleModal(session, "fichejoueur", toggle = "toggle")
    
    #### Bouton reset choix second gk ####
    observeEvent(input$reset_gk_comparaison,
                 {
                     updatePickerInput(session,
                                       inputId = "goalkeeper_comparaison",
                                       selected = "...")
                 }
    )
    
    #### Bouton reset choix second field ####
    observeEvent(input$reset_field_comparaison,
                 {
                     updatePickerInput(session,
                                       inputId = "field_comparaison",
                                       selected = "...")
                 }
    )
}
)
