# output$graph_timeseries = renderAmCharts({
#    data('data_stock_2')
#    amTimeSeries(data_stock_2, 'date', c('ts1', 'ts2'))
# })

observe({
    output$amchart = renderAmCharts({
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
        
        label_region1_var1 = paste(names(liste_deroulante_map[liste_deroulante_map == input$choix_var_ts1]), " (", choix_region_ts1, ")", sep = "")
        label_region1_var2 = paste(names(liste_deroulante_map[liste_deroulante_map == input$choix_var_ts2]), " (", choix_region_ts1, ")", sep = "")
        label_region2_var1 = paste(names(liste_deroulante_map[liste_deroulante_map == input$choix_var_ts1]), " (", choix_region_ts2, ")", sep = "")
        label_region2_var2 = paste(names(liste_deroulante_map[liste_deroulante_map == input$choix_var_ts2]), " (", choix_region_ts2, ")", sep = "")
        
        print(choix_region_ts1)
        print(choix_region_ts2)
        
        df1 = data.frame(ANNEE = c(min(moyenne_region_stat$ANNEE):max(moyenne_region_stat$ANNEE))) %>% 
                    mutate(ANNEE = as.POSIXct(as.character(ANNEE), format = "%Y"))
        
        if (choix_region_ts1 != "XXXX"){
            if (input$choix_var_ts1 != "XXXX"){
                print("cas region 1 ok + var 1 ok")
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
        
        if (!((choix_region_ts1 == "XXXX" & choix_region_ts2 == "XXXX") | (input$choix_var_ts1 == "XXXX" & input$choix_var_ts2 == "XXXX"))){
        amTimeSeries(df_final,
                     'ANNEE',
                     names(df_final)[2:length(names(df_final))],
                     color = c("blue", "blue", "red", "red"),
                     linetype = c(0, 7, 0, 7))
}
        # if (input$switch_variable_stat == 1){
        #     
        #     if(input$choix_var_ts1 != "XXXX"){
        #         
        #         if(input$choix_var_ts2 != "XXXX"){
        #             
        #             if(input$choix_region_ts1 != "XXXX"){
        #             mon_df_1 = moyenne_region_stat %>% 
        #                 filter(REGION == choix_region_ts1 & !is.na(ANNEE)) %>% 
        #                 mutate(ANNEE = as.POSIXct(as.character(ANNEE), format = "%Y")) %>% 
        #                 select(REGION, ANNEE, input$choix_var_ts1, input$choix_var_ts2)
        #             
        #             mon_df_2 = moyenne_region_stat %>% 
        #                 filter(REGION == choix_region_ts2 & !is.na(ANNEE)) %>% 
        #                 mutate(ANNEE = as.POSIXct(as.character(ANNEE), format = "%Y")) %>% 
        #                 select(ANNEE, input$choix_var_ts1, input$choix_var_ts2)
        #             
        #             mon_df = mon_df_1 %>% 
        #                 left_join(mon_df_2, by = "ANNEE")
        #             
        #             
        #             amTimeSeries(mon_df, 
        #                          'ANNEE', 
        #                          names(mon_df)[3:length(names(mon_df))],
        #                          color = c("blue", "blue", "red", "red"),
        #                          linetype = c(0, 7, 0, 7))
        #             } else {
        #             mon_df_2 = moyenne_region_stat %>% 
        #                 filter(REGION == choix_region_ts2 & !is.na(ANNEE)) %>% 
        #                 mutate(ANNEE = as.POSIXct(as.character(ANNEE), format = "%Y")) %>% 
        #                 select(REGION, ANNEE, input$choix_var_ts1, input$choix_var_ts2)
        #             
        #             amTimeSeries(mon_df_2, 
        #                          'ANNEE', 
        #                          names(mon_df)[3:length(names(mon_df))],
        #                          color = c("red", "red"),
        #                          linetype = c(0, 7))
        #             }
        #         } else {
        #             mon_df_1 = moyenne_region_stat %>% 
        #                 filter(REGION == choix_region_ts1 & !is.na(ANNEE)) %>% 
        #                 mutate(ANNEE = as.POSIXct(as.character(ANNEE), format = "%Y")) %>% 
        #                 select(REGION, ANNEE, input$choix_var_ts1)
        #             
        #             mon_df_2 = moyenne_region_stat %>% 
        #                 filter(REGION == choix_region_ts2 & !is.na(ANNEE)) %>% 
        #                 mutate(ANNEE = as.POSIXct(as.character(ANNEE), format = "%Y")) %>% 
        #                 select(ANNEE, input$choix_var_ts1)
        #             
        #             mon_df = mon_df_1 %>% 
        #                 left_join(mon_df_2, by = "ANNEE")
        #             
        #             
        #             amTimeSeries(mon_df, 
        #                          'ANNEE', 
        #                          names(mon_df)[3:length(names(mon_df))],
        #                          color = c("blue", "red"),
        #                          linetype = c(0, 0))
        #         }
        #     }
        # } else {
        #     if(input$choix_var_ts1 != "XXXX"){
        #         mon_df_1 = moyenne_region_stat %>% 
        #             filter(REGION == choix_region_ts1 & !is.na(ANNEE)) %>% 
        #             mutate(ANNEE = as.POSIXct(as.character(ANNEE), format = "%Y")) %>% 
        #             select(REGION, ANNEE, input$choix_var_ts1)
        #         
        #         mon_df_2 = moyenne_region_stat %>% 
        #             filter(REGION == choix_region_ts2 & !is.na(ANNEE)) %>% 
        #             mutate(ANNEE = as.POSIXct(as.character(ANNEE), format = "%Y")) %>% 
        #             select(ANNEE, input$choix_var_ts1)
        #         
        #         mon_df = mon_df_1 %>% 
        #             left_join(mon_df_2, by = "ANNEE")
        #         
        #         
        #         amTimeSeries(mon_df, 
        #                      'ANNEE', 
        #                      names(mon_df)[3:length(names(mon_df))],
        #                      color = c("blue", "red"),
        #                      linetype = c(0, 0))
        #     }
        # }
        
    })
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

# output$plot_test = renderPlot({
#   plot(1)
# })