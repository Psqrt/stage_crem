# == Update liste déroulante en fonction du NUTS =======================================================
# Liste de toutes les variables H retenues (avec leurs labels) pour alimenter les listes déroulantes en NUTS 1 ou 2
# car les variables R et P ne sont pas renseignées pour les régions NUTS 1 et 2
# c'est-à-dire qu'on ne connait pas la région d'un individu (contrairement à la région d'un ménage qui est renseignée)
observeEvent(input$choix_nuts_stats_scatter_plot, {
  if (input$choix_nuts_stats_scatter_plot == "NUTS 0"){
    updateSelectInput(session, "choix_var1_stats_scatter_plot", 
                      choices = c("Select a variable" = "XXXX", liste_deroulante_map),
                      selected = input$choix_var1_stats_scatter_plot)
  } else {
    updateSelectInput(session, "choix_var1_stats_scatter_plot", 
                      choices = c("Select a variable" = "XXXX", liste_reduite),
                      selected = if_else(input$choix_var1_stats_scatter_plot %in% liste_reduite,
                                         input$choix_var1_stats_scatter_plot,
                                         "XXXX"))
  }
})

observeEvent(input$choix_nuts_stats_scatter_plot, {
  if (input$choix_nuts_stats_scatter_plot == "NUTS 0"){
    updateSelectInput(session, "choix_var2_stats_scatter_plot", 
                      choices = c("Select a variable" = "XXXX", liste_deroulante_map),
                      selected = input$choix_var2_stats_scatter_plot)
  } else {
    updateSelectInput(session, "choix_var2_stats_scatter_plot", 
                      choices = c("Select a variable" = "XXXX", liste_reduite),
                      selected = if_else(input$choix_var2_stats_scatter_plot %in% liste_reduite,
                                         input$choix_var2_stats_scatter_plot,
                                         "XXXX"))
  }
})




# == Sortie table pour scatter plot  ======================================================================
observe({
  label_var1_stats_scatter_plot = names(liste_deroulante_map_applatie[liste_deroulante_map_applatie == input$choix_var1_stats_scatter_plot])
  label_var2_stats_scatter_plot = names(liste_deroulante_map_applatie[liste_deroulante_map_applatie == input$choix_var2_stats_scatter_plot])

  
  if (input$choix_var1_stats_scatter_plot != "XXXX" | input$choix_var2_stats_scatter_plot != "XXXX"){
    filtre_df_scatter = moyenne_region_stat %>% 
      filter(NUTS == input$choix_nuts_stats_scatter_plot &
               ANNEE %in% input$choix_annee_scatterplot) %>%
      mutate(ANNEE = as.factor(ANNEE))
    
    if (input$choix_var1_stats_scatter_plot != "XXXX"){
      if (input$choix_var2_stats_scatter_plot != "XXXX"){
        filtre_df_scatter = filtre_df_scatter %>% 
          select(Country = NOM_PAYS, 
                 Region = NOM_REGION, 
                 Year = ANNEE, 
                 !!label_var1_stats_scatter_plot := input$choix_var1_stats_scatter_plot, 
                 !!label_var2_stats_scatter_plot := input$choix_var2_stats_scatter_plot)
      } else {
        filtre_df_scatter = filtre_df_scatter %>% 
          select(Country = NOM_PAYS, 
                 Region = NOM_REGION, 
                 Year = ANNEE, 
                 !!label_var1_stats_scatter_plot := input$choix_var1_stats_scatter_plot)
      }
    } else {
      if (input$choix_var2_stats_scatter_plot != "XXXX"){
        filtre_df_scatter = filtre_df_scatter %>% 
          select(Country = NOM_PAYS, 
                 Region = NOM_REGION, 
                 Year = ANNEE, 
                 !!label_var2_stats_scatter_plot := input$choix_var2_stats_scatter_plot)
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
    filter(NUTS == input$choix_nuts_stats_scatter_plot &
             ANNEE %in% input$choix_annee_scatterplot) %>%
    mutate(ANNEE = as.factor(ANNEE))
  
  # 2. Ne tracer le graphique que si les deux variables sont choisies
  if(input$choix_var1_stats_scatter_plot != 'XXXX' & input$choix_var2_stats_scatter_plot != 'XXXX'){
    # 2.1. Si on est en mode 2D ...
    if(input$switch_3d_stats_scatter_plot != 1){
      
      filtre_df_scatter %>% plot_ly(x = ~get(input$choix_var1_stats_scatter_plot),
                                    y = ~get(input$choix_var2_stats_scatter_plot),
                                    color = ~PAYS,
                                    # symbol = ~ANNEE,
                                    mode = "markers",
                                    # frame = ~ANNEE,
                                    colors = "Set3",
                                    type = 'scatter',
                                    # Constitution du pop-up (hover)
                                    text = ~paste("[", PAYS, "/", ANNEE, "] ", NOM_REGION, "\n", 
                                                  "Value variable 1: ", get(input$choix_var1_stats_scatter_plot), "\n", 
                                                  "Value variable 2: ", get(input$choix_var2_stats_scatter_plot), 
                                                  sep = ""),
                                    hoverinfo = "text") %>%
        # Renommage des noms des axes (utilisation du label plutot que le code)
        layout(xaxis = list(title = names(liste_deroulante_map_applatie[liste_deroulante_map_applatie == input$choix_var1_stats_scatter_plot])),
               yaxis = list(title = names(liste_deroulante_map_applatie[liste_deroulante_map_applatie == input$choix_var2_stats_scatter_plot])))
      
    } else {
      # 2.2. Sinon (mode 3D) ...
      filtre_df_scatter %>% plot_ly(x = ~ANNEE,
                                    y = ~get(input$choix_var1_stats_scatter_plot),
                                    z = ~get(input$choix_var2_stats_scatter_plot),
                                    color = ~PAYS,
                                    # frame = ~ANNEE,
                                    mode = "markers",
                                    colors = "Set3",
                                    size = 1,
                                    # Constitution du pop-up (hover)
                                    text = ~paste("[", PAYS, "/", ANNEE, "] ", NOM_REGION, "\n", 
                                                  "Value variable 1: ", get(input$choix_var1_stats_scatter_plot), "\n", 
                                                  "Value variable 2: ", get(input$choix_var2_stats_scatter_plot), 
                                                  sep = ""),
                                    hoverinfo = "text") %>%
        # Renommage des noms des axes (utilisation du label plutot que le code)
        layout(scene = list(yaxis = list(title = names(liste_deroulante_map_applatie[liste_deroulante_map_applatie == input$choix_var1_stats_scatter_plot])),
                            zaxis = list(title = names(liste_deroulante_map_applatie[liste_deroulante_map_applatie == input$choix_var2_stats_scatter_plot])),
                            xaxis = list(title = "Year")))
    }
  }
})


# == PDF 1 =============================================================================================
output$pdf1_stats_scatter_plot <- renderText({
  page = recode(substr(input$choix_var1_stats_scatter_plot, 1, 5), !!!dico_liste_variable_page)
  return(paste('<iframe style="height:500px; width:793px;" src="./pdf/', page, '.pdf', '"></iframe>', sep = ""))
})

# == PDF 2 =============================================================================================
output$pdf2_stats_scatter_plot <- renderText({
  page = recode(substr(input$choix_var2_stats_scatter_plot, 1, 5), !!!dico_liste_variable_page)
  return(paste('<iframe style="height:500px; width:793px;" src="./pdf/', page, '.pdf', '"></iframe>', sep = ""))
})

