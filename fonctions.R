### Fichier servant à gérer le clic sur les markers ou polygones de la carte, permettant d'afficher 
#   les informations dans le panel en bas à droite.
#########################################################################################################################"

if (!is.null(info_click$id)){
    # 2. Filtrage de la base pour récupérer l'ensemble des données pour cette région à l'année T ou période P
    ligne_click = moyenne_region_filtre() %>% 
        filter(REGION == info_click$id)
    
    # 3. Affichage conditionnel en fonction de l'échelle actuelle
    if (input$choix_nuts == "NUTS 2"){
        
        ligne_donnees_2 = moyenne_region %>% 
            filter(ANNEE == ligne_click$ANNEE & 
                       REGION == substr(ligne_click$REGION, 1, 3))
        
        # En NUTS 2, donner des informations sur la région choisie et sur la région NUTS 1 qui l'englobe
        texte1 = paste("<table>",
                       "<tr><td><strong>Population</strong></td><td style = 'text-align: right'>", format(ligne_click$POPULATION, big.mark = ","), "inhabitants</td></tr>",
                       "<tr><td><strong>Density</strong></td><td style = 'text-align: right'>", format(round(ligne_click$DENSITE), big.mark = ","), "inhabitants/km²</td></tr>",
                       "<tr><td><strong>PIB par habitant</strong></td><td style = 'text-align: right'>", format(ligne_click$PIBH, big.mark = ","), "€/inhabitant/year</td></tr>",
                       "<tr><td><strong>Young people who permaturely left education</strong></td><td style = 'text-align: right'>", ligne_click$EDUC_JEUNE, "%</td></tr>",
                       "<tr><td><strong>People at risk of poverty or social exclusion</strong></td><td style = 'text-align: right'>", ligne_click$RISQUE_PAUVR_NB, "%</td></tr>",
                       "<tr><td><strong>Risk of poverty rate</strong></td><td style = 'text-align: right'>", ligne_click$RISQUE_PAUVR_TX, "%</td></tr>",
                       "<tr><td><strong>Unemployment rate</strong></td><td style = 'text-align: right'>", ligne_click$CHOMAGE_TX, "%</td></tr>",
                       "<tr><td><strong>Cooling degree days</strong></td><td style = 'text-align: right'>", ligne_click$DEGRES_JOUR_COLD, "</td></tr>",
                       "<tr><td><strong>Heating degree days</strong></td><td style = 'text-align: right'>", ligne_click$DEGRES_JOUR_HOT, "</td></tr>",
                       "</table>")
        
        texte2 = paste("<table>",
                       "<tr><td><strong>Population</strong></td><td style = 'text-align: right'>", format(ligne_donnees_2$POPULATION, big.mark = ","), "inhabitants</td></tr>",
                       "<tr><td><strong>Density</strong></td><td style = 'text-align: right'>", format(round(ligne_donnees_2$DENSITE), big.mark = ","), "inhabitants/km²</td></tr>",
                       "<tr><td><strong>PIB par habitant</strong></td><td style = 'text-align: right'>", format(ligne_donnees_2$PIBH, big.mark = ","), "€/inhabitant/year</td></tr>",
                       "<tr><td><strong>Young people who permaturely left education</strong></td><td style = 'text-align: right'>", ligne_donnees_2$EDUC_JEUNE, "%</td></tr>",
                       "<tr><td><strong>People at risk of poverty or social exclusion</strong></td><td style = 'text-align: right'>", ligne_donnees_2$RISQUE_PAUVR_NB, "%</td></tr>",
                       "<tr><td><strong>Risk of poverty rate</strong></td><td style = 'text-align: right'>", ligne_donnees_2$RISQUE_PAUVR_TX, "%</td></tr>",
                       "<tr><td><strong>Unemployment rate</strong></td><td style = 'text-align: right'>", ligne_donnees_2$CHOMAGE_TX, "%</td></tr>",
                       "<tr><td><strong>Cooling degree days</strong></td><td style = 'text-align: right'>", ligne_donnees_2$DEGRES_JOUR_COLD, "</td></tr>",
                       "<tr><td><strong>Heating degree days</strong></td><td style = 'text-align: right'>", ligne_donnees_2$DEGRES_JOUR_HOT, "</td></tr>",
                       "</table>")
        
        titre1 = tags$h4(ligne_click$NOM_REGION)
        titre2 = tags$h4(ligne_donnees_2$NOM_REGION)
    } else if (input$choix_nuts == "NUTS 1"){
        # En NUTS 1, donner des informations sur la région choisie et sur le pays qui l'englobe
        
        
        ligne_donnees_2 = moyenne_region %>% 
            filter(ANNEE == ligne_click$ANNEE & 
                       REGION == substr(ligne_click$REGION, 1, 2))
        
        texte1 = paste("<table>",
                       "<tr><td><strong>Population</strong></td><td style = 'text-align: right'>", format(ligne_click$POPULATION, big.mark = ","), "inhabitants</td></tr>",
                       "<tr><td><strong>Density</strong></td><td style = 'text-align: right'>", format(round(ligne_click$DENSITE), big.mark = ","), "inhabitants/km²</td></tr>",
                       "<tr><td><strong>GDP per capita</strong></td><td style = 'text-align: right'>", format(ligne_click$PIBH, big.mark = ","), "€/inhabitant/year</td></tr>",
                       "<tr><td><strong>Young people who permaturely left education</strong></td><td style = 'text-align: right'>", ligne_click$EDUC_JEUNE, "%</td></tr>",
                       "<tr><td><strong>People at risk of poverty or social exclusion</strong></td><td style = 'text-align: right'>", ligne_click$RISQUE_PAUVR_NB, "%</td></tr>",
                       "<tr><td><strong>Risk of poverty rate</strong></td><td style = 'text-align: right'>", ligne_click$RISQUE_PAUVR_TX, "%</td></tr>",
                       "<tr><td><strong>Unemployment rate</strong></td><td style = 'text-align: right'>", ligne_click$CHOMAGE_TX, "%</td></tr>",
                       "<tr><td><strong>Cooling degree days</strong></td><td style = 'text-align: right'>", ligne_click$DEGRES_JOUR_COLD, "</td></tr>",
                       "<tr><td><strong>Heating degree days</strong></td><td style = 'text-align: right'>", ligne_click$DEGRES_JOUR_HOT, "</td></tr>",
                       "</table>")
        
        texte2 = paste("<table>",
                       "<tr><td><strong>Population</strong></td><td style = 'text-align: right'>", format(ligne_donnees_2$POPULATION, big.mark = ","), "inhabitants</td></tr>",
                       "<tr><td><strong>Density</strong></td><td style = 'text-align: right'>", format(round(ligne_donnees_2$DENSITE), big.mark = ","), "inhabitants/km²</td></tr>",
                       "<tr><td><strong>GDP per capita</strong></td><td style = 'text-align: right'>", format(ligne_donnees_2$PIBH, big.mark = ","), "€/inhabitant/year</td></tr>",
                       "<tr><td><strong>Young people who permaturely left education</strong></td><td style = 'text-align: right'>", ligne_donnees_2$EDUC_JEUNE, "%</td></tr>",
                       "<tr><td><strong>People at risk of poverty or social exclusion</strong></td><td style = 'text-align: right'>", ligne_donnees_2$RISQUE_PAUVR_NB, "%</td></tr>",
                       "<tr><td><strong>Risk of poverty rate</strong></td><td style = 'text-align: right'>", ligne_donnees_2$RISQUE_PAUVR_TX, "%</td></tr>",
                       "<tr><td><strong>Unemployment rate</strong></td><td style = 'text-align: right'>", ligne_donnees_2$CHOMAGE_TX, "%</td></tr>",
                       "<tr><td><strong>Cooling degree days</strong></td><td style = 'text-align: right'>", ligne_donnees_2$DEGRES_JOUR_COLD, "</td></tr>",
                       "<tr><td><strong>Heating degree days</strong></td><td style = 'text-align: right'>", ligne_donnees_2$DEGRES_JOUR_HOT, "</td></tr>",
                       "</table>")
        
        titre1 = tags$h4(ligne_click$NOM_REGION)
        titre2 = tags$h4(ligne_donnees_2$NOM_REGION)
        
    } else if (input$choix_nuts == "NUTS 0"){
        # En NUTS 0, donner des informations sur le pays choisi et sur l'Europe
        
        moyenne_region_eu28_filtre = moyenne_region_eu28 %>% 
            filter(ANNEE == ligne_click$ANNEE)
        
        texte1 = paste("<table>",
                       "<tr><td><strong>Population</strong></td><td style = 'text-align: right'>", format(ligne_click$POPULATION, big.mark = ","), "inhabitants</td></tr>",
                       "<tr><td><strong>Density</strong></td><td style = 'text-align: right'>", format(round(ligne_click$DENSITE), big.mark = ","), "inhabitants/km²</td></tr>",
                       "<tr><td><strong>GDP per capita</strong></td><td style = 'text-align: right'>", format(ligne_click$PIBH, big.mark = ","), "€/inhabitant/year</td></tr>",
                       "<tr><td><strong>Young people who permaturely left education</strong></td><td style = 'text-align: right'>", ligne_click$EDUC_JEUNE, "%</td></tr>",
                       "<tr><td><strong>People at risk of poverty or social exclusion</strong></td><td style = 'text-align: right'>", ligne_click$RISQUE_PAUVR_NB, "%</td></tr>",
                       "<tr><td><strong>Risk of poverty rate</strong></td><td style = 'text-align: right'>", ligne_click$RISQUE_PAUVR_TX, "%</td></tr>",
                       "<tr><td><strong>Unemployment rate</strong></td><td style = 'text-align: right'>", ligne_click$CHOMAGE_TX, "%</td></tr>",
                       "<tr><td><strong>Cooling degree days</strong></td><td style = 'text-align: right'>", ligne_click$DEGRES_JOUR_COLD, "</td></tr>",
                       "<tr><td><strong>Heating degree days</strong></td><td style = 'text-align: right'>", ligne_click$DEGRES_JOUR_HOT, "</td></tr>",
                       "</table>")
        
        texte2 = paste("<table>",
                       "<tr><td><strong>Population</strong></td><td style = 'text-align: right'>", format(moyenne_region_eu28_filtre$POPULATION, big.mark = ","), "inhabitants</td></tr>",
                       "<tr><td><strong>Density</strong></td><td style = 'text-align: right'>", format(round(moyenne_region_eu28_filtre$DENSITE), big.mark = ","), "inhabitants/km²</td></tr>",
                       "<tr><td><strong>GDP per capita</strong></td><td style = 'text-align: right'>", format(moyenne_region_eu28_filtre$PIBH, big.mark = ","), "€/inhabitant/year</td></tr>",
                       "<tr><td><strong>Young people who permaturely left education</strong></td><td style = 'text-align: right'>", moyenne_region_eu28_filtre$EDUC_JEUNE, "%</td></tr>",
                       "<tr><td><strong>People at risk of poverty or social exclusion</strong></td><td style = 'text-align: right'>", moyenne_region_eu28_filtre$RISQUE_PAUVR_NB, "%</td></tr>",
                       "<tr><td><strong>Risk of poverty rate</strong></td><td style = 'text-align: right'>", moyenne_region_eu28_filtre$RISQUE_PAUVR_TX, "%</td></tr>",
                       "<tr><td><strong>Unemployment rate</strong></td><td style = 'text-align: right'>", moyenne_region_eu28_filtre$CHOMAGE_TX, "%</td></tr>",
                       "<tr><td><strong>Cooling degree days</strong></td><td style = 'text-align: right'>", moyenne_region_eu28_filtre$DEGRES_JOUR_COLD, "</td></tr>",
                       "<tr><td><strong>Heating degree days</strong></td><td style = 'text-align: right'>", moyenne_region_eu28_filtre$DEGRES_JOUR_HOT, "</td></tr>",
                       "</table>")
        
        titre1 = tags$h4(ligne_click$NOM_REGION)
        titre2 = tags$h4("Europe")
        
        
        if (input$choix_variable_1_map == "XXXX" & input$choix_variable_2_map == "XXXX"){
            texte1 = "Select a variable ..."
            texte2 = "... then select a region."
            titre1 = ""
            titre2 = ""
        }
        
        
    }
    
}