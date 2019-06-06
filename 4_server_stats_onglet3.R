# == Update liste déroulante en fonction du NUTS =======================================================
# Liste de toutes les variables H retenues (avec leurs labels) pour alimenter les listes déroulantes en NUTS 1 ou 2
# car les variables R et P ne sont pas renseignées pour les régions NUTS 1 et 2
# c'est-à-dire qu'on ne connait pas la région d'un individu (contrairement à la région d'un ménage qui est renseignée)
observeEvent(input$choix_nuts_onglet3, {
  if (input$choix_nuts_onglet3 == "NUTS 0"){
    updateSelectInput(session, "choix_var1_onglet3", 
                      choices = c("Select a variable" = "XXXX", liste_deroulante_map),
                      selected = input$choix_var1_onglet3)
  } else {
    updateSelectInput(session, "choix_var1_onglet3", 
                      choices = c("Select a variable" = "XXXX", liste_reduite),
                      selected = if_else(input$choix_var1_onglet3 %in% liste_reduite,
                                         input$choix_var1_onglet3,
                                         "XXXX"))
  }
})

observeEvent(input$choix_nuts_onglet3, {
  if (input$choix_nuts_onglet3 == "NUTS 0"){
    updateSelectInput(session, "choix_var2_onglet3", 
                      choices = c("Select a variable" = "XXXX", liste_deroulante_map),
                      selected = input$choix_var2_onglet3)
  } else {
    updateSelectInput(session, "choix_var2_onglet3", 
                      choices = c("Select a variable" = "XXXX", liste_reduite),
                      selected = if_else(input$choix_var2_onglet3 %in% liste_reduite,
                                         input$choix_var2_onglet3,
                                         "XXXX"))
  }
})




# == Sortie table pour scatter plot (onglet 3) ==========================================================
observe({
  
  if (input$choix_var1_onglet3 != "XXXX" | input$choix_var2_onglet3 != "XXXX"){
    filtre_df_scatter = moyenne_region_stat %>% 
      filter(NUTS == input$choix_nuts_onglet3 &
               ANNEE %in% input$choix_annee_scatterplot) %>%
      mutate(ANNEE = as.factor(ANNEE))
    
    if (input$choix_var1_onglet3 != "XXXX"){
      if (input$choix_var2_onglet3 != "XXXX"){
        filtre_df_scatter = filtre_df_scatter %>% 
          select(NOM_PAYS, NOM_REGION, ANNEE, input$choix_var1_onglet3, input$choix_var2_onglet3)
      } else {
        filtre_df_scatter = filtre_df_scatter %>% 
          select(NOM_PAYS, NOM_REGION, ANNEE, input$choix_var1_onglet3)
      }
    } else {
      if (input$choix_var2_onglet3 != "XXXX"){
        filtre_df_scatter = filtre_df_scatter %>% 
          select(NOM_PAYS, NOM_REGION, ANNEE, input$choix_var2_onglet3)
      } else {
        filtre_df_scatter = data.frame()
      }
    }
  } else {
    filtre_df_scatter = data.frame()
  }
  
  output$table_scatter = renderDataTable(
    selection = list(mode = 'single'),
    options = list(searching = FALSE), filtre_df_scatter
  )
})


# == SCATTER PLOT ======================================================================================
output$plotly_scatter <- renderPlotly({
  
  # 1. Filtrage de la base à représenter (inputs considérés : choix niveaux NUTS)
  filtre_df_scatter = moyenne_region_stat %>% 
    filter(NUTS == input$choix_nuts_onglet3 &
             ANNEE %in% input$choix_annee_scatterplot) %>%
    mutate(ANNEE = as.factor(ANNEE))
  
  # 2. Ne tracer le graphique que si les deux variables sont choisies
  if(input$choix_var1_onglet3 != 'XXXX' & input$choix_var2_onglet3 != 'XXXX'){
    # 2.1. Si on est en mode 2D ...
    if(input$switch_3d_onglet3 != 1){
      
      filtre_df_scatter %>% plot_ly(x = ~get(input$choix_var1_onglet3),
                                    y = ~get(input$choix_var2_onglet3),
                                    color = ~PAYS,
                                    # symbol = ~ANNEE,
                                    mode = "markers",
                                    colors = "Set3",
                                    type = 'scatter',
                                    # Constitution du pop-up (hover)
                                    text = ~paste("[", PAYS, "/", ANNEE, "] ", NOM_REGION, "\n", 
                                                  "Value variable 1: ", get(input$choix_var1_onglet3), "\n", 
                                                  "Value variable 2: ", get(input$choix_var2_onglet3), 
                                                  sep = ""),
                                    hoverinfo = "text") %>%
        # Renommage des noms des axes (utilisation du label plutot que le code)
        layout(xaxis = list(title = names(liste_deroulante_map_applatie[liste_deroulante_map_applatie == input$choix_var1_onglet3])),
               yaxis = list(title = names(liste_deroulante_map_applatie[liste_deroulante_map_applatie == input$choix_var2_onglet3])))
      
    } else {
      # 2.2. Sinon (mode 3D) ...
      filtre_df_scatter %>% plot_ly(x = ~ANNEE,
                                    y = ~get(input$choix_var1_onglet3),
                                    z = ~get(input$choix_var2_onglet3),
                                    color = ~PAYS,
                                    mode = "markers",
                                    colors = "Set3",
                                    size = 1,
                                    # Constitution du pop-up (hover)
                                    text = ~paste("[", PAYS, "/", ANNEE, "] ", NOM_REGION, "\n", 
                                                  "Value variable 1: ", get(input$choix_var1_onglet3), "\n", 
                                                  "Value variable 2: ", get(input$choix_var2_onglet3), 
                                                  sep = ""),
                                    hoverinfo = "text") %>%
        # Renommage des noms des axes (utilisation du label plutot que le code)
        layout(scene = list(yaxis = list(title = names(liste_deroulante_map_applatie[liste_deroulante_map_applatie == input$choix_var1_onglet3])),
                            zaxis = list(title = names(liste_deroulante_map_applatie[liste_deroulante_map_applatie == input$choix_var2_onglet3])),
                            xaxis = list(title = "Year")))
    }
  }
})


# == PDF 1 =============================================================================================
output$pdf1_onglet3 <- renderText({
  page = recode(substr(input$choix_var1_onglet3, 1, 5), !!!dico_liste_variable_page)
  return(paste('<iframe style="height:500px; width:793px;" src="./pdf/', page, '.pdf', '"></iframe>', sep = ""))
})

# == PDF 2 =============================================================================================
output$pdf2_onglet3 <- renderText({
  page = recode(substr(input$choix_var2_onglet3, 1, 5), !!!dico_liste_variable_page)
  return(paste('<iframe style="height:500px; width:793px;" src="./pdf/', page, '.pdf', '"></iframe>', sep = ""))
})

