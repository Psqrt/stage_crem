# == TIME SERIES NUTS 0 ================================================================================
output$plotly_ts_nuts0 <- renderPlotly({
  
  # 1. Filtrage de la base à représenter (inputs considérés : aucun, en supposant qu'on est en NUTS 0)
  filtre_df = moyenne_region_stat %>% 
    filter(NUTS == 'NUTS 0') %>% 
    mutate(ANNEE =as.numeric(ANNEE)) %>% 
    arrange(ANNEE)
  
  # 2. Si la variable est choisie ...
  if(input$choix_var_onglet2 != 'XXXX'){
    
    filtre_df %>% plot_ly(x = ~ANNEE,
                          y = ~get(input$choix_var_onglet2),
                          type = 'scatter',
                          mode = 'lines',
                          color = ~REGION,
                          # Constitution du pop-up (hover)
                          text = ~paste("[", REGION, "] ", NOM_REGION, "\n", "Value : ", get(input$choix_var_onglet2), sep = ""),
                          hoverinfo = "text") %>% 
      # Renommage des noms des axes (label de la variable plutôt que le code)
      layout(xaxis = list(title = "Year"),
             yaxis = list(title = names(liste_deroulante_map_applatie[liste_deroulante_map_applatie == input$choix_var_onglet2])))
  }
})



# == TIME SERIES NUTS 1 ou 2 ===========================================================================
output$plotly_ts_nuts12 <- renderPlotly({
  
  # 1. Filtrage de la base à représenter (inputs considérés : choix du NUTS)
  filtre_df = moyenne_region_stat %>% 
    filter(NUTS == input$choix_nuts_onglet2 & PAYS == input$choix_pays_onglet2) %>% 
    mutate(ANNEE =as.numeric(ANNEE)) %>% 
    arrange(ANNEE)
  
  # 2. Si la variable est choisie ...
  if(input$choix_var_onglet2 != 'XXXX'){
    
    filtre_df %>% plot_ly(x = ~ANNEE,
                          y = ~get(input$choix_var_onglet2),
                          type = 'scatter',
                          mode = 'lines',
                          color = ~REGION,
                          # Constitution du pop-up (hover)
                          text = ~paste("[", REGION, "] ", NOM_REGION, "\n", "Value : ", get(input$choix_var_onglet2), sep = ""),
                          hoverinfo = "text") %>% 
      # Renommage des noms des axes (label de la variable plutôt que le code)
      layout(xaxis = list(title = "Year"),
             yaxis = list(title = names(liste_deroulante_map_applatie[liste_deroulante_map_applatie == input$choix_var_onglet2])))
  }
})


# == PDF 1 =============================================================================================

output$pdf1_onglet2 <- renderText({
  page = recode(substr(input$choix_var_onglet2, 1, 5), !!!dico_liste_variable_page)
  return(paste('<iframe style="height:500px; width:793px;" src="./pdf/', page, '.pdf', '"></iframe>', sep = ""))
})



