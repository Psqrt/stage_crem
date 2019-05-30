# == SCATTER PLOT ======================================================================================
output$plotly_scatter <- renderPlotly({
  
  # 1. Filtrage de la base à représenter (inputs considérés : choix niveaux NUTS)
  filtre_df_scatter = moyenne_region_stat %>% 
    filter(NUTS == input$choix_nuts_onglet3) %>% 
    mutate(ANNEE = as.factor(ANNEE))
  
  # 2. Ne tracer le graphique que si les deux variables sont choisies
  if(input$choix_var1_onglet3 != 'XXXX' & input$choix_var2_onglet3 != 'XXXX'){
    # 2.1. Si on est en mode 2D ...
    if(input$switch_3d_onglet3 != 1){
      
      filtre_df_scatter %>% plot_ly(x = ~get(input$choix_var1_onglet3),
                                    y = ~get(input$choix_var2_onglet3),
                                    color = ~PAYS,
                                    symbol = ~ANNEE,
                                    mode = "markers",
                                    colors = "Set3",
                                    type = 'scatter',
                                    # Constitution du pop-up (hover)
                                    text = ~paste("[", PAYS, "/", ANNEE, "] ", NOM_REGION, "\n", 
                                                  "Value variable 1: ", get(input$choix_var1_onglet3), "\n", 
                                                  "Value variable 2: ", get(input$choix_var2_onglet3), 
                                                  sep = ""),
                                    hoverinfo = "text") %>%
        # Renommage des noms des axes (utilisation du label plutôt que le code)
        layout(xaxis = list(title = names(liste_deroulante_map_applatie[liste_deroulante_map_applatie == input$choix_var1_onglet3])),
               yaxis = list(title = names(liste_deroulante_map_applatie[liste_deroulante_map_applatie == input$choix_var2_onglet3])))
      
    } else {
      # 2.2. Sinon (mode 3D) ...
      filtre_df_scatter %>% plot_ly(x = ~get(input$choix_var1_onglet3),
                                    y = ~get(input$choix_var2_onglet3),
                                    z = ~ANNEE,
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
        # Renommage des noms des axes (utilisation du label plutôt que le code)
        layout(scene = list(xaxis = list(title = names(liste_deroulante_map_applatie[liste_deroulante_map_applatie == input$choix_var1_onglet3])),
                            yaxis = list(title = names(liste_deroulante_map_applatie[liste_deroulante_map_applatie == input$choix_var2_onglet3])),
                            zaxis = list(title = "Year")))
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

