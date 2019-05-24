# Carte leaflet
output$ggplot_all_countries <- renderPlotly({
    filtre_df = moyenne_region_stat %>% 
        filter(NUTS == 'NUTS 0') %>% 
        mutate(ANNEE =as.numeric(ANNEE)) %>% 
        arrange(ANNEE)
    
    if(input$choix_var_onglet2 != 'XXXX'){
        # (ggplot(filtre_df, aes(x=ANNEE, y=get(input$choix_var_onglet2), color=REGION)) + geom_line()) %>% ggplotly
        filtre_df %>% plot_ly(x = ~ANNEE,
                              y = ~get(input$choix_var_onglet2),
                              type = 'scatter',
                              mode = 'lines',
                              color = ~REGION,
                              text = ~paste("[", REGION, "] ", NOM_REGION, "\n", "Value : ", get(input$choix_var_onglet2), sep = ""),
                              hoverinfo = "text") %>% 
            layout(xaxis = list(title = "Year"),
                   yaxis = list(title = names(liste_deroulante_map_applatie[liste_deroulante_map_applatie == input$choix_var_onglet2])))
    }
})




output$ggplot_country_regions <- renderPlotly({
    filtre_df = moyenne_region_stat %>% 
        filter(NUTS == input$choix_nuts_onglet2 & PAYS == input$choix_pays_onglet2) %>% 
        mutate(ANNEE =as.numeric(ANNEE)) %>% 
        arrange(ANNEE)
    
    if(input$choix_var_onglet2 != 'XXXX'){
        
        filtre_df %>% plot_ly(x = ~ANNEE,
                              y = ~get(input$choix_var_onglet2),
                              type = 'scatter',
                              mode = 'lines',
                              color = ~REGION,
                              text = ~paste("[", REGION, "] ", NOM_REGION, "\n", "Value : ", get(input$choix_var_onglet2), sep = ""),
                              hoverinfo = "text") %>% 
            layout(xaxis = list(title = "Year"),
                   yaxis = list(title = names(liste_deroulante_map_applatie[liste_deroulante_map_applatie == input$choix_var_onglet2])))
    }
    # (ggplot(filtre_df, aes(x=ANNEE, y=get(input$choix_var_onglet2), color=REGION)) + geom_line()) %>%  ggplotly
})


### PDF ###############################################################################################

output$pdf1_onglet2 <- renderText({
  page = recode(substr(input$choix_var_onglet2, 1, 5), !!!dico_liste_variable_page)
  return(paste('<iframe style="height:500px; width:793px;" src="./pdf/', page, '.pdf', '"></iframe>', sep = ""))
})



