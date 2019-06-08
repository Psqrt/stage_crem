# == Update liste déroulante en fonction du NUTS =======================================================
# Liste de toutes les variables H retenues (avec leurs labels) pour alimenter les listes déroulantes en NUTS 1 ou 2
# car les variables R et P ne sont pas renseignées pour les régions NUTS 1 et 2
# c'est-à-dire qu'on ne connait pas la région d'un individu (contrairement à la région d'un ménage qui est renseignée)
observeEvent(input$choix_nuts_stats_time_series, {
  if (input$choix_nuts_stats_time_series == "NUTS 0"){
    updateSelectInput(session, "choix_var_stats_time_series", 
                      choices = c("Select a variable" = "XXXX", liste_deroulante_map),
                      selected = input$choix_var_stats_time_series)
  } else {
    updateSelectInput(session, "choix_var_stats_time_series", 
                      choices = c("Select a variable" = "XXXX", liste_reduite),
                      selected = if_else(input$choix_var_stats_time_series %in% liste_reduite,
                                         input$choix_var_stats_time_series,
                                         "XXXX"))
  }
  
  # update de la liste des régions après modification sélection nuts
  
  dico_region_update_stats_time_series = moyenne_region_stat %>% 
    filter(PAYS == input$choix_pays_stats_time_series_nuts_1_2,
           NUTS == input$choix_nuts_stats_time_series) %>% 
    select(REGION, NOM_REGION) %>%
    distinct(REGION, .keep_all = T)
  
  liste_region_update_stats_time_series = setNames(dico_region_update_stats_time_series[, "REGION"],
                                         dico_region_update_stats_time_series[, "NOM_REGION"])
  
  
  if (input$choix_pays_stats_time_series_nuts_1_2 != "XXXX"){
    updatePickerInput(session, "choix_region_stats_time_series", 
                      choices = liste_region_update_stats_time_series,
                      selected = liste_region_update_stats_time_series)
  }
})





# == Update liste déroulante des régions en fonction du pays sélectionné ===============================
observeEvent(input$choix_pays_stats_time_series_nuts_1_2, {
  
  dico_region_update_stats_time_series = moyenne_region_stat %>% 
    filter(PAYS == input$choix_pays_stats_time_series_nuts_1_2,
           NUTS == input$choix_nuts_stats_time_series) %>% 
    select(REGION, NOM_REGION) %>%
    distinct(REGION, .keep_all = T) # supprression des doublons de noms de regions (1)
  # (1) La clé est le code REGION parce c'est l'identifiant commun entre deux région "Bourgogne" et "BOURGOGNE"
  
  liste_region_update_stats_time_series = setNames(dico_region_update_stats_time_series[, "REGION"],
                                         dico_region_update_stats_time_series[, "NOM_REGION"])
  
  
  if (input$choix_pays_stats_time_series_nuts_1_2 != "XXXX"){
    updatePickerInput(session, "choix_region_stats_time_series", 
                      choices = liste_region_update_stats_time_series,
                      selected = liste_region_update_stats_time_series)
  }
  
})



# == Sortie table pour time series =============================================================================
observe({
  label_var1_stats_time_series = names(liste_deroulante_map_applatie[liste_deroulante_map_applatie == input$choix_var_stats_time_series])
  
  if (input$choix_nuts_stats_time_series != "NUTS 0"){
    if (input$choix_var_stats_time_series != "XXXX"){
      filtre_df = moyenne_region_stat %>% 
        filter(NUTS == input$choix_nuts_stats_time_series &
                 PAYS == input$choix_pays_stats_time_series_nuts_1_2) %>% 
        mutate(ANNEE =as.numeric(ANNEE)) %>%
        select(Country = NOM_PAYS, 
               Region = NOM_REGION, 
               Year = ANNEE, 
               !!label_var1_stats_time_series := input$choix_var_stats_time_series) %>% 
        arrange(Year)
    } else {
      filtre_df = data.frame()
    }
  } else {
    if (input$choix_var_stats_time_series != "XXXX"){
      filtre_df = moyenne_region_stat %>% 
        filter(NUTS == input$choix_nuts_stats_time_series &
                 PAYS %in% input$choix_pays_stats_time_series_nuts_0) %>% 
        mutate(ANNEE = as.numeric(ANNEE)) %>%
        select(Country = NOM_PAYS, 
               Region = NOM_REGION, 
               Year = ANNEE, 
               !!label_var1_stats_time_series := input$choix_var_stats_time_series) %>% 
        arrange(Year)
    } else {
      filtre_df = data.frame()
    }
  }
  
  output$table_ts = renderDataTable(
    selection = list(mode = 'single'),
    options = list(searching = FALSE), filtre_df
  )
})







# == TIME SERIES NUTS 0 ================================================================================
output$plotly_ts_nuts0 <- renderPlotly({
  
  # 1. Filtrage de la base à représenter (inputs considérés : aucun, en supposant qu'on est en NUTS 0)
  filtre_df_plotly = moyenne_region_stat %>% 
    filter(NUTS == 'NUTS 0' &
             PAYS %in% input$choix_pays_stats_time_series_nuts_0) %>% 
    mutate(ANNEE = as.numeric(ANNEE)) %>% 
    arrange(ANNEE)
  
  # 2. Si la variable est choisie ...
  if(input$choix_var_stats_time_series != 'XXXX'){
    
    filtre_df_plotly %>% plot_ly(x = ~ANNEE,
                          y = ~get(input$choix_var_stats_time_series),
                          type = 'scatter',
                          mode = 'lines',
                          color = ~REGION,
                          # Constitution du pop-up (hover)
                          text = ~paste("[", REGION, "] ", NOM_REGION, "\n", "Value : ", get(input$choix_var_stats_time_series), sep = ""),
                          hoverinfo = "text") %>% 
      # Renommage des noms des axes (label de la variable plutot que le code)
      layout(xaxis = list(title = "Year"),
             yaxis = list(title = names(liste_deroulante_map_applatie[liste_deroulante_map_applatie == input$choix_var_stats_time_series])))
  }
})



# == TIME SERIES NUTS 1 ou 2 ===========================================================================
output$plotly_ts_nuts12 <- renderPlotly({
  
  # 1. Filtrage de la base à représenter (inputs considérés : choix du NUTS)
  filtre_df_plotly = moyenne_region_stat %>% 
    filter(NUTS == input$choix_nuts_stats_time_series & 
             PAYS == input$choix_pays_stats_time_series_nuts_1_2 &
             REGION %in% input$choix_region_stats_time_series) %>% 
    mutate(ANNEE = as.numeric(ANNEE)) %>% 
    arrange(ANNEE)
  
  # 2. Si la variable est choisie ...
  if(input$choix_var_stats_time_series != 'XXXX'){
    
    
    filtre_df_plotly %>% plot_ly(x = ~ANNEE,
                          y = ~get(input$choix_var_stats_time_series),
                          type = 'scatter',
                          mode = 'lines',
                          color = ~REGION,
                          # Constitution du pop-up (hover)
                          text = ~paste("[", REGION, "] ", NOM_REGION, "\n", "Value : ", get(input$choix_var_stats_time_series), sep = ""),
                          hoverinfo = "text") %>%
      # Renommage des noms des axes (label de la variable plutot que le code)
      layout(xaxis = list(title = "Year"),
             yaxis = list(title = names(liste_deroulante_map_applatie[liste_deroulante_map_applatie == input$choix_var_stats_time_series])))
  }
})


# == PDF 1 =============================================================================================

output$pdf1_stats_time_series <- renderText({
  page = recode(substr(input$choix_var_stats_time_series, 1, 5), !!!dico_liste_variable_page)
  return(paste('<iframe style="height:500px; width:793px;" src="./pdf/', page, '.pdf', '"></iframe>', sep = ""))
})



