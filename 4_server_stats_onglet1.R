# output$graph_timeseries = renderAmCharts({
#    data('data_stock_2')
#    amTimeSeries(data_stock_2, 'date', c('ts1', 'ts2'))
# })

observe({
    
    if (input$choix_nuts_ts1 == "NUTS 0"){
        choix_region_ts1 = input$choix_region_ts1a
    } else if (input$choix_nuts_ts1 == "NUTS 1"){
        choix_region_ts1 = input$choix_region_ts1b
    } else {
        choix_region_ts1 = input$choix_region_ts1c
    }
    if (input$choix_nuts_ts2 == "NUTS 0"){
        choix_region_ts2 = input$choix_region_ts2a
    } else if (input$choix_nuts_ts2 == "NUTS 1"){
        choix_region_ts2 = input$choix_region_ts2b
    } else {
        choix_region_ts2 = input$choix_region_ts2c
    }
    
    liste_deroulante_map_applatie = unlist(liste_deroulante_map)
    liste_deroulante_map_applatie = setNames(liste_deroulante_map_applatie,
                                             gsub(".*\\.\\[", "[", names(liste_deroulante_map_applatie), perl = T))
    
    label_region1_var1 = paste(names(liste_deroulante_map_applatie[liste_deroulante_map_applatie == input$choix_var_ts1]), " (", choix_region_ts1, ")", sep = "")
    label_region1_var2 = paste(names(liste_deroulante_map_applatie[liste_deroulante_map_applatie == input$choix_var_ts2]), " (", choix_region_ts1, ")", sep = "")
    label_region2_var1 = paste(names(liste_deroulante_map_applatie[liste_deroulante_map_applatie == input$choix_var_ts1]), " (", choix_region_ts2, ")", sep = "")
    label_region2_var2 = paste(names(liste_deroulante_map_applatie[liste_deroulante_map_applatie == input$choix_var_ts2]), " (", choix_region_ts2, ")", sep = "")
    print(paste("XXXXXXXXXXX : ", input$choix_var_ts1))
    
    print(choix_region_ts1)
    print(choix_region_ts2)
    
    range_date = c(min(moyenne_region_stat$ANNEE):max(moyenne_region_stat$ANNEE))
    
    df1 = data.frame(ANNEE = range_date) %>% 
        mutate(ANNEE = as.POSIXct(as.character(ANNEE), format = "%Y"))
    
    if (choix_region_ts1 != "XXXX"){
        if (input$choix_var_ts1 != "XXXX"){
            print("cas region 1 ok + var 1 ok")
            print(label_region1_var1)
            print(input$choix_var_ts1)
            df2 = moyenne_region_stat %>% 
                filter(REGION == choix_region_ts1) %>% 
                mutate(ANNEE = as.POSIXct(as.character(ANNEE), format = "%Y")) %>% 
                select(ANNEE, !!label_region1_var1 := input$choix_var_ts1)
            # print(df2)
        } else {
            print("cas region 1 ok + var 1 non")
            df2 = df1
        }
    } else {
        print("cas region 1 non + var 1 both")
        df2 = df1
    }
    
    if (choix_region_ts1 != "XXXX"){
        if (input$choix_var_ts2 != "XXXX"){
            print("cas region 1 ok + var 2 ok")
            df3 = moyenne_region_stat %>% 
                filter(REGION == choix_region_ts1) %>% 
                mutate(ANNEE = as.POSIXct(as.character(ANNEE), format = "%Y")) %>% 
                select(ANNEE, !!label_region1_var2 := input$choix_var_ts2)
        } else {
            print("cas region 1 ok + var 2 non")
            df3 = df1
        }
    } else {
        print("cas region 1 non + var 2 both")
        df3 = df1
    }
    
    if (choix_region_ts2 != "XXXX"){
        if (input$choix_var_ts1 != "XXXX"){
            print("cas region 2 ok + var 1 ok")
            df4 = moyenne_region_stat %>% 
                filter(REGION == choix_region_ts2) %>% 
                mutate(ANNEE = as.POSIXct(as.character(ANNEE), format = "%Y")) %>% 
                select(ANNEE, !!label_region2_var1 := input$choix_var_ts1)
        } else {
            print("cas region 2 ok + var 1 non")
            df4 = df1
        }
    } else {
        print("cas region 2 non + var 1 both")
        df4 = df1
    }
    
    if (choix_region_ts2 != "XXXX"){
        if (input$choix_var_ts2 != "XXXX"){
            print("cas region 2 ok + var 2 ok")
            df5 = moyenne_region_stat %>% 
                filter(REGION == choix_region_ts2) %>% 
                mutate(ANNEE = as.POSIXct(as.character(ANNEE), format = "%Y")) %>% 
                select(ANNEE, !!label_region2_var2 := input$choix_var_ts2)
        } else {
            print("cas region 2 ok + var 2 non")
            df5 = df1
        }
    } else {
        print("cas region 2 non + var 2 both")
        df5 = df1
    }
    
    # print(df1)
    # print(df2)
    # print(df3)
    # print(df4)
    # print(df5)
    df_final = df1 %>% 
        left_join(df2, by = c("ANNEE")) %>% 
        left_join(df3, by = c("ANNEE")) %>% 
        left_join(df4, by = c("ANNEE")) %>% 
        left_join(df5, by = c("ANNEE"))
    print(df_final)
    
    output$amchart = renderAmCharts({
        
        print("8888888888888888888888888888")
        if (!((choix_region_ts1 == "XXXX" & choix_region_ts2 == "XXXX") | (input$choix_var_ts1 == "XXXX" & input$choix_var_ts2 == "XXXX"))){
            amTimeSeries(df_final,
                         'ANNEE',
                         names(df_final)[2:length(names(df_final))],
                         color = c("blue", "red", "blue", "red"),
                         linetype = c(0, 0, 7, 7)
            )
        }
    })
    
    # output$amchart2 = renderAmCharts({
    #     if (!((choix_region_ts1 == "XXXX" & choix_region_ts2 == "XXXX") | (input$choix_var_ts1 == "XXXX" & input$choix_var_ts2 == "XXXX"))){
    #         amTimeSeries(df_final,
    #                      'ANNEE',
    #                      names(df_final)[2:length(names(df_final))],
    #                      color = c("blue", "blue", "red", "red"),
    #                      linetype = c(0, 7, 0, 7)
    #         )
    #     }
    # })
    
    df_tableau_central = df_final %>% 
        mutate(ANNEE = range_date) %>% 
        rename(Year = ANNEE)
    
    output$df_tableau_central = DT::renderDataTable(
        selection = list(mode = 'single'),
        options = list(searching = FALSE,
                       dom = 't'),
        if (ncol(df_tableau_central) == 1){        
            NULL
        } else {
            df_tableau_central
        }
    )
    
    df_init_1ligne = data.frame(Region = c("0"))
    df_init_2lignes = data.frame(Region = c("0", "0"))
    
    output$barplot = renderAmCharts({
        print("==========================================================")
        print(input$choix_var_ts1)
        print(input$choix_var_ts2)
        print(choix_region_ts1)
        print(choix_region_ts2)
        print("==========================================================")
        var1 = names(liste_deroulante_map_applatie[liste_deroulante_map_applatie == input$choix_var_ts1])
        region1 = names(liste_tout_nuts_stat[liste_tout_nuts_stat == choix_region_ts1])
        var2 = names(liste_deroulante_map_applatie[liste_deroulante_map_applatie == input$choix_var_ts2])
        region2 = names(liste_tout_nuts_stat[liste_tout_nuts_stat == choix_region_ts2])
        if (!is.null(input$df_tableau_central_row_last_clicked)){
            if (input$choix_var_ts1 != "XXXX" & input$choix_var_ts2 == "XXXX"){
                if (choix_region_ts1 != "XXXX" & choix_region_ts2 == "XXXX"){
                    
                    print("CAS 1 ROSE")
                    
                    df_barplot = df_init_1ligne %>% 
                        mutate(!!var1 := as.numeric(df_tableau_central %>% 
                                                        filter(Year == 2003 + input$df_tableau_central_row_last_clicked) %>% 
                                                        select(2)),
                               Region = region1)
                    
                    barplot_stat = amBarplot(x = "Region",
                                             y = c(var1), 
                                             data = df_barplot)
                } else if (choix_region_ts1 == "XXXX" & choix_region_ts2 != "XXXX"){
                    
                    print("CAS 2 ROSE")
                    
                    df_barplot = df_init_1ligne %>% 
                        mutate(!!var1 := as.numeric(df_tableau_central %>% 
                                                        filter(Year == 2003 + input$df_tableau_central_row_last_clicked) %>% 
                                                        select(2)),
                               Region = region2)
                    
                    barplot_stat = amBarplot(x = "Region",
                                             y = c(var1), 
                                             data = df_barplot)
                } else if (choix_region_ts1 != "XXXX" & choix_region_ts2 != "XXXX"){
                    
                    print("CAS 3 ROSE")
                    
                    df_barplot = df_init_2lignes %>% 
                        mutate(!!var1 := df_tableau_central %>% 
                                   filter(Year == 2003 + input$df_tableau_central_row_last_clicked) %>% 
                                   select(2, 3) %>% 
                                   t,
                               Region = c(region1, region2))
                    
                    barplot_stat = amBarplot(x = "Region",
                                             y = c(var1),
                                             data = df_barplot)
                } else {
                    print("CASE 4 ROSE")
                    
                    NULL
                }
            } else if (input$choix_var_ts1 == "XXXX" & input$choix_var_ts2 != "XXXX") {
                if (choix_region_ts1 != "XXXX" & choix_region_ts2 == "XXXX"){
                    print("CAS 1 VERT")
                    
                    df_barplot = df_init_1ligne %>% 
                        mutate(!!var2 := as.numeric(df_tableau_central %>% 
                                                        filter(Year == 2003 + input$df_tableau_central_row_last_clicked) %>% 
                                                        select(2)),
                               Region = region1)
                    
                    barplot_stat = amBarplot(x = "Region",
                                             y = c(var2), 
                                             data = df_barplot)
                    
                    
                    
                } else if (choix_region_ts1 == "XXXX" & choix_region_ts2 != "XXXX") {
                    print("CAS 2 VERT")
                    
                    df_barplot = df_init_1ligne %>% 
                        mutate(!!var2 := as.numeric(df_tableau_central %>% 
                                                        filter(Year == 2003 + input$df_tableau_central_row_last_clicked) %>% 
                                                        select(2)),
                               Region = region2)
                    
                    barplot_stat = amBarplot(x = "Region",
                                             y = c(var2), 
                                             data = df_barplot)
                    
                    
                    
                } else if (choix_region_ts1 != "XXXX" & choix_region_ts2 != "XXXX") {
                    print("CAS 3 VERT")
                    
                    df_barplot = df_init_2lignes %>% 
                        mutate(!!var2 := df_tableau_central %>% 
                                   filter(Year == 2003 + input$df_tableau_central_row_last_clicked) %>% 
                                   select(2, 3) %>% 
                                   t,
                               Region = c(region1, region2))
                    
                    barplot_stat = amBarplot(x = "Region",
                                             y = c(var2),
                                             data = df_barplot)
                    
                    
                    
                }
            } else if (input$choix_var_ts1 != "XXXX" & input$choix_var_ts2 != "XXXX") {
                if (choix_region_ts1 == "XXXX" & choix_region_ts2 != "XXXX"){
                    print("CAS 1 JAUNE")
                    
                    df_intermediaire <- (df_tableau_central %>% 
                                                      filter(Year == 2003 + input$df_tableau_central_row_last_clicked))
                    df_barplot = df_init_1ligne %>% 
                        mutate(!!var1 :=  df_intermediaire %>% 
                                   select(2) %>% 
                                   as.list %>% 
                                   as.numeric,
                               !!var2 :=  df_intermediaire %>%
                                   select(3) %>% 
                                   as.list %>% 
                                   as.numeric,
                               Region = region2
                               )
                    print(df_barplot)
                    
                    barplot_stat = amBarplot(x = "Region",
                                             y = c(var1, var2), 
                                             legend = T,
                                             legendPosition = "bottom",
                                             data = df_barplot)
                    
                    
                } else if (choix_region_ts1 != "XXXX" & choix_region_ts2 == "XXXX"){
                    print("CAS 2 JAUNE")
                    
                    df_intermediaire <- (df_tableau_central %>% 
                                                      filter(Year == 2003 + input$df_tableau_central_row_last_clicked))
                    df_barplot = df_init_1ligne %>% 
                        mutate(!!var1 :=  df_intermediaire %>% 
                                   select(2) %>% 
                                   as.list %>% 
                                   as.numeric,
                               !!var2 :=  df_intermediaire %>%
                                   select(3) %>% 
                                   as.list %>% 
                                   as.numeric,
                               Region = region1
                               )
                    print(df_barplot)
                    
                    barplot_stat = amBarplot(x = "Region",
                                             y = c(var1, var2), 
                                             legend = T,
                                             legendPosition = "bottom",
                                             data = df_barplot)
                } else if (choix_region_ts1 != "XXXX" & choix_region_ts2 != "XXXX"){
                    print("CAS 3 JAUNE")
                    
                    df_intermediaire <- (df_tableau_central %>% 
                                                      filter(Year == 2003 + input$df_tableau_central_row_last_clicked))
                    
                    print(df_intermediaire)
                    df_barplot = df_init_2lignes %>% 
                        mutate(!!var1 :=  df_intermediaire %>% 
                                   select(2, 4) %>%
                                   as.list %>% 
                                   as.numeric,
                               !!var2 :=  df_intermediaire %>%
                                   select(3, 5) %>% 
                                   as.list %>% 
                                   as.numeric,
                               Region = c(region1, region2)
                               )
                    print(df_barplot)
                    
                    barplot_stat = amBarplot(x = "Region",
                                             y = c(var1, var2), 
                                             legend = T,
                                             legendPosition = "bottom",
                                             data = df_barplot)
                }
            }
            
            # amBarplot(x = "REGION", y = c("V1", "V2"), data = qq)
            # barplot_stat
        } else {
            print("SELECTIONNER UNE LIGNE DU TABLEAU")
            NULL
        }
    })
    
})


observeEvent(input$df_tableau_central_row_last_clicked, {
    print(input$df_tableau_central_row_last_clicked)
})

observeEvent(input$switch_region_stat, {
    # print("cc")
    reset("choix_region_ts2a")
    reset("choix_region_ts2b")
    reset("choix_region_ts2c")
})

observeEvent(input$switch_variable_stat, {
    # print("cc")
    reset("choix_var_ts2")
    reset("choix_var_ts2")
    reset("choix_var_ts2")
})

observe({
    if (input$choix_nuts_ts1 == "NUTS 0"){
        code_region = moyenne_region %>% 
            filter(nchar(REGION) == 2) %>% 
            select(REGION) %>% 
            unique()
        
        association_region = code_region %>% 
            left_join(moyenne_region %>% 
                          select(REGION, NOM_REGION),
                      by = c("REGION")) %>% 
            group_by(REGION) %>% 
            summarise(NOM_REGION = first(NOM_REGION))
        
        liste_region1 = setNames(association_region$REGION, 
                                 association_region$NOM_REGION)
    } else if (input$choix_nuts_ts1 == "NUTS 1"){
        
    } else {
        
    }
    
    
})


### PDF ###############################################################################################

output$pdf1_onglet1 <- renderText({
  page = recode(substr(input$choix_var_ts1, 1, 5), !!!dico_liste_variable_page)
  return(paste('<iframe style="height:500px; width:793px;" src="./pdf/', page, '.pdf', '"></iframe>', sep = ""))
})

output$pdf2_onglet1 <- renderText({
  page = recode(substr(input$choix_var_ts2, 1, 5), !!!dico_liste_variable_page)
  return(paste('<iframe style="height:500px; width:793px;" src="./pdf/', page, '.pdf', '"></iframe>', sep = ""))
})