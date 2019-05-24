
# 
# # POUR DEMAIN
# (moyenne_region_stat %>% 
#     filter(NUTS == "NUTS 0") %>% 
#     ggplot() +
#     aes(x = HH050_moy,
#         y = HH040_moy,
#         color = PAYS,
#         shape = as.factor(ANNEE)) +
#     geom_point() +
#     scale_shape_manual(values = seq(0, 10)) +
#     theme_bw()) %>% 
#     ggplotly
# 
# 
# 
# (moyenne_region_stat %>%
#         filter(NUTS == "NUTS 2") %>%
#         plot_ly(x = ~HH050_moy,
#                 y = ~HH050_moy,
#                 frame = ~ANNEE,
#                 # z = ~ANNEE,
#                 size = 1,
#                 color = ~PAYS))
# 
# 



output$ggplot_scatter <- renderPlotly({
  
  filtre_df_scatter = moyenne_region_stat %>% 
    filter(NUTS == input$choix_nuts_onglet3) %>% 
    mutate(ANNEE = as.factor(ANNEE))
  
  if(input$choix_var1_onglet3 != 'XXXX' & input$choix_var2_onglet3 != 'XXXX'){
    if(input$switch_3d_onglet3 != 1){
      
      xx <<- filtre_df_scatter
      print(filtre_df_scatter)
      filtre_df_scatter %>% plot_ly(x = ~get(input$choix_var1_onglet3),
                                    y = ~get(input$choix_var2_onglet3),
                                    color = ~PAYS,
                                    symbol = ~ANNEE,
                                    mode = "markers",
                                    colors = "Set3",
                                    type = 'scatter',
                                    text = ~paste("[", PAYS, "/", ANNEE, "] ", NOM_REGION, "\n", 
                                                  "Value variable 1: ", get(input$choix_var1_onglet3), "\n", 
                                                  "Value variable 2: ", get(input$choix_var2_onglet3), 
                                                  sep = ""),
                                    hoverinfo = "text") %>%
        layout(xaxis = list(title = names(liste_deroulante_map_applatie[liste_deroulante_map_applatie == input$choix_var1_onglet3])),
               yaxis = list(title = names(liste_deroulante_map_applatie[liste_deroulante_map_applatie == input$choix_var2_onglet3])))
      
    } else {
      filtre_df_scatter %>% plot_ly(x = ~get(input$choix_var1_onglet3),
                                    y = ~get(input$choix_var2_onglet3),
                                    z = ~ANNEE,
                                    color = ~PAYS,
                                    mode = "markers",
                                    colors = "Set3",
                                    size = 1,
                                    # type = 'scatter',
                                    text = ~paste("[", PAYS, "/", ANNEE, "] ", NOM_REGION, "\n", 
                                                  "Value variable 1: ", get(input$choix_var1_onglet3), "\n", 
                                                  "Value variable 2: ", get(input$choix_var2_onglet3), 
                                                  sep = ""),
                                    hoverinfo = "text") %>%
        layout(scene = list(xaxis = list(title = names(liste_deroulante_map_applatie[liste_deroulante_map_applatie == input$choix_var1_onglet3])),
                            yaxis = list(title = names(liste_deroulante_map_applatie[liste_deroulante_map_applatie == input$choix_var2_onglet3])),
                            zaxis = list(title = "Year")))
      # layout(xaxis = list(title = names(liste_deroulante_map_applatie[liste_deroulante_map_applatie == input$choix_var1_onglet3])),
      #        yaxis = list(title = names(liste_deroulante_map_applatie[liste_deroulante_map_applatie == input$choix_var2_onglet3])))
      
    }
    # (ggplot(filtre_df, aes(x=ANNEE, y=get(input$choix_var_onglet2), color=REGION)) + geom_line()) %>% ggplotly
  }
})


### PDF ###############################################################################################

output$pdf1_onglet3 <- renderText({
  page = recode(substr(input$choix_var1_onglet3, 1, 5), !!!dico_liste_variable_page)
  return(paste('<iframe style="height:500px; width:793px;" src="./pdf/', page, '.pdf', '"></iframe>', sep = ""))
})

### PDF ###############################################################################################

output$pdf2_onglet3 <- renderText({
  page = recode(substr(input$choix_var2_onglet3, 1, 5), !!!dico_liste_variable_page)
  return(paste('<iframe style="height:500px; width:793px;" src="./pdf/', page, '.pdf', '"></iframe>', sep = ""))
})

