# == Update liste déroulante en fonction du NUTS =======================================================
# Liste de toutes les variables H retenues (avec leurs labels) pour alimenter les listes déroulantes en NUTS 1 ou 2
# car les variables R et P ne sont pas renseignées pour les régions NUTS 1 et 2
# c'est-à-dire qu'on ne connait pas la région d'un individu (contrairement à la région d'un ménage qui est renseignée)
observeEvent(input$choix_nuts_ts1, {
  if (input$choix_nuts_ts1 == "NUTS 0"){
    updateSelectInput(session, "choix_var_ts1", 
                      choices = c("Select a variable" = "XXXX", liste_deroulante_map),
                      selected = input$choix_var_ts1)
  } else {
    updateSelectInput(session, "choix_var_ts1", 
                      choices = c("Select a variable" = "XXXX", liste_reduite),
                      selected = if_else(input$choix_var_ts1 %in% liste_reduite,
                                         input$choix_var_ts1,
                                         "XXXX"))
  }
})

observeEvent(input$choix_nuts_ts1, {
  if (input$choix_nuts_ts1 == "NUTS 0"){
    updateSelectInput(session, "choix_var_ts2", 
                      choices = c("Select a variable" = "XXXX", liste_deroulante_map),
                      selected = input$choix_var_ts2)
  } else {
    updateSelectInput(session, "choix_var_ts2", 
                      choices = c("Select a variable" = "XXXX", liste_reduite),
                      selected = if_else(input$choix_var_ts2 %in% liste_reduite,
                                         input$choix_var_ts2,
                                         "XXXX"))
  }
})



observe({
  
  # 1. Trois sources peuvent fournir la région sélectionnée ...
  #    ... peu importe la source, on récupère la région dans une même variable ...
  #    ... pour n'avoir qu'une seule variable à appeler ensuite
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
  
  # 2. Construction des labels pour alimenter la légende du time series
  label_region1_var1 = paste(names(liste_deroulante_map_applatie[liste_deroulante_map_applatie == input$choix_var_ts1]), 
                             " (", 
                             choix_region_ts1, ")", 
                             sep = "")
  label_region1_var2 = paste(names(liste_deroulante_map_applatie[liste_deroulante_map_applatie == input$choix_var_ts2]), 
                             " (", 
                             choix_region_ts1, 
                             ")", 
                             sep = "")
  label_region2_var1 = paste(names(liste_deroulante_map_applatie[liste_deroulante_map_applatie == input$choix_var_ts1]), 
                             " (", 
                             choix_region_ts2, 
                             ")", 
                             sep = "")
  label_region2_var2 = paste(names(liste_deroulante_map_applatie[liste_deroulante_map_applatie == input$choix_var_ts2]), 
                             " (", 
                             choix_region_ts2, 
                             ")", 
                             sep = "")
  
  # 3. Plage des années à représenter
  range_date = c(min(moyenne_region_stat$ANNEE):max(moyenne_region_stat$ANNEE))
  
  # 4. Construction de la base de données à représenter
  # 4.1. df1 est le socle de départ : il ne contient qu'une colonne : celle des années
  df1 = data.frame(ANNEE = range_date) %>% 
    mutate(ANNEE = as.POSIXct(as.character(ANNEE), format = "%Y"))
  
  # 4.2. Le prolongement de la table se fait selon le cas.
  # La table finale est de taille variable (en particulier le nombre de colonnes) :
  #    - Le nombre de colonnes varie de 1 à 5
  #    - 1ere colonne : l'année
  #    - 2eme colonne : variable 1 pour la région 1 (si applicable)
  #    - 3eme colonne : variable 2 pour la région 1 (si applicable)
  #    - 4eme oclonne : variable 1 pour la région 2 (si applicable)
  #    - 5eme oclonne : variable 2 pour la région 2 (si applicable)
  if (choix_region_ts1 != "XXXX"){
    if (input$choix_var_ts1 != "XXXX"){
      # Cas si la région 1 et la variable 1 sont choisies
      # df2 contient l'année (nécessaire pour la jointure prochaine) et la variable choisie pour la région 1
      df2 = moyenne_region_stat %>% 
        filter(REGION == choix_region_ts1) %>% 
        mutate(ANNEE = as.POSIXct(as.character(ANNEE), format = "%Y")) %>% 
        select(ANNEE, !!label_region1_var1 := input$choix_var_ts1)
    } else {
      # Cas si la région 1 est choisie mais pas la variable 1
      # df2 : ne sert à rien (0 colonne supplémentaire dans la jointure prochaine)
      df2 = df1
    }
  } else {
    # Cas si la région 1 n'est pas choisie (et peu importe en ce qui concerne la variable 1)
    # df2 : ne sert à rien (0 colonne supplémentaire dans la jointure prochaine)
    df2 = df1
  }
  
  if (choix_region_ts1 != "XXXX"){
    if (input$choix_var_ts2 != "XXXX"){
      # Cas si la région 1 et la région 2 sont choisies
      # df3 contient l'année (colonne de jointure) et la variable 2 choisie pour la région 1
      df3 = moyenne_region_stat %>% 
        filter(REGION == choix_region_ts1) %>% 
        mutate(ANNEE = as.POSIXct(as.character(ANNEE), format = "%Y")) %>% 
        select(ANNEE, !!label_region1_var2 := input$choix_var_ts2)
    } else {
      # Cas si la région 1 est choisie mais pas la variable 2
      # df3 ne sert à rien dans ce cas 
      df3 = df1
    }
  } else {
    # Cas si la région 1 n'est pas choisie (et peu importe en ce qui concerne la variable 2)
    # df3 ne sert à rien dans ce cas
    df3 = df1
  }
  
  if (choix_region_ts2 != "XXXX"){
    if (input$choix_var_ts1 != "XXXX"){
      # Cas si la région 2 et la variable 1 sont choisies
      # df4 contient l'année (colonne de jointure) et la variable 1 pour la région 2
      df4 = moyenne_region_stat %>% 
        filter(REGION == choix_region_ts2) %>% 
        mutate(ANNEE = as.POSIXct(as.character(ANNEE), format = "%Y")) %>% 
        select(ANNEE, !!label_region2_var1 := input$choix_var_ts1)
    } else {
      # Cas si la région 2 est choisie mais pas la variable 1
      df4 = df1
    }
  } else {
    # Cas si la région 2 n'est pas choisie (et peu importe en ce qui concerne la variable 1)
    # df4 ne sert à rien dans ce cas
    df4 = df1
  }
  
  if (choix_region_ts2 != "XXXX"){
    if (input$choix_var_ts2 != "XXXX"){
      # Cas si la région 2 et la variable 2 sont choisies
      # df5 contient l'année (colonne de jointure) et la variable 2 pour la région 2
      df5 = moyenne_region_stat %>% 
        filter(REGION == choix_region_ts2) %>% 
        mutate(ANNEE = as.POSIXct(as.character(ANNEE), format = "%Y")) %>% 
        select(ANNEE, !!label_region2_var2 := input$choix_var_ts2)
    } else {
      # Cas si la région 2 est choisie mais pas la variable 2
      # df5 est inutile (jointure)
      df5 = df1
    }
  } else {
    # Cas si la région 2 n'est pas choisie (et peu importe pour la variable 2)
    # df5 est inutile (jointure)
    df5 = df1
  }

  
  # 4.3. Jointure de tous les data-frames "colonnes" construits en 4.2.
  df_final = df1 %>% 
    left_join(df2, by = c("ANNEE")) %>% 
    left_join(df3, by = c("ANNEE")) %>% 
    left_join(df4, by = c("ANNEE")) %>% 
    left_join(df5, by = c("ANNEE"))
  
  
  # 5. Graphique time series
  # == TIME SERIES =====================================================================================
  output$amchart_ts = renderAmCharts({
    
    # Si le graphique peut être tracé (équivaut à si df_final a au moins deux colonnes)
    # NOTE : Vérifier si cette grande condition peut être abrégée à if(ncol(df_final) != 1)
    if (!((choix_region_ts1 == "XXXX" & choix_region_ts2 == "XXXX") | (input$choix_var_ts1 == "XXXX" & input$choix_var_ts2 == "XXXX"))){
      amTimeSeries(data = df_final,
                   col_date = 'ANNEE',
                   col_series = names(df_final)[2:length(names(df_final))],
                   color = c("blue", "red", "blue", "red"),
                   linetype = c(0, 0, 7, 7)
      )
    }
  })
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  # GROSSE PARTIE PAS ENCORE COMMENTÉE (cas par cas)
  
  
  df_tableau_central = df_final %>% 
    mutate(ANNEE = range_date) %>% 
    rename(Year = ANNEE)
  
  output$df_tableau_central = renderDataTable(
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
    var1 = names(liste_deroulante_map_applatie[liste_deroulante_map_applatie == input$choix_var_ts1])
    region1 = names(liste_tout_nuts_stat[liste_tout_nuts_stat == choix_region_ts1])
    var2 = names(liste_deroulante_map_applatie[liste_deroulante_map_applatie == input$choix_var_ts2])
    region2 = names(liste_tout_nuts_stat[liste_tout_nuts_stat == choix_region_ts2])
    
    
    
    # Liste des cas de figures possibles lors de la construction du barplot
    # |---------------------------------------------------|
    # |     CAS     | VAR 1 | VAR 2 | REGION 1 | REGION 2 |
    # |-------------+-------+-------+----------+----------|
    # | CAS 1 ROSE  | OUI   | NON   | OUI      | NON      |
    # | CAS 1 VERT  | NON   | OUI   | OUI      | NON      |
    # | CAS 2 ROSE  | OUI   | NON   | NON      | OUI      |
    # | CAS 2 VERT  | NON   | OUI   | NON      | OUI      |
    # | CAS 1 JAUNE | OUI   | OUI   | NON      | OUI      |
    # | CAS 2 JAUNE | OUI   | OUI   | OUI      | NON      |
    # | CAS 3 ROSE  | OUI   | NON   | OUI      | OUI      |
    # | CAS 3 VERT  | NON   | OUI   | OUI      | OUI      |
    # | CAS 3 JAUNE | OUI   | OUI   | OUI      | OUI      |
    # | CAS NOIR    | OUI   | NON   | NON      | NON      |
    # | CAS NOIR    | OUI   | OUI   | NON      | NON      |
    # | CAS NOIR    | NON   | NON   | OUI      | OUI      |
    # | CAS NOIR    | NON   | OUI   | NON      | NON      |
    # |---------------------------------------------------|

    
    if (!is.null(input$df_tableau_central_row_last_clicked)){
      if (input$choix_var_ts1 != "XXXX" & input$choix_var_ts2 == "XXXX"){
        if (choix_region_ts1 != "XXXX" & choix_region_ts2 == "XXXX"){
          
          # print("CAS 1 ROSE")
          
          df_barplot = df_init_1ligne %>% 
            mutate(!!var1 := as.numeric(df_tableau_central %>% 
                                          filter(Year == 2003 + input$df_tableau_central_row_last_clicked) %>% 
                                          select(2)),
                   Region = region1)
          
          barplot_stat = amBarplot(x = "Region",
                                   y = c(var1), 
                                   data = df_barplot)
        } else if (choix_region_ts1 == "XXXX" & choix_region_ts2 != "XXXX"){
          
          # print("CAS 2 ROSE")
          
          df_barplot = df_init_1ligne %>% 
            mutate(!!var1 := as.numeric(df_tableau_central %>% 
                                          filter(Year == 2003 + input$df_tableau_central_row_last_clicked) %>% 
                                          select(2)),
                   Region = region2)
          
          barplot_stat = amBarplot(x = "Region",
                                   y = c(var1), 
                                   data = df_barplot)
        } else if (choix_region_ts1 != "XXXX" & choix_region_ts2 != "XXXX"){
          
          # print("CAS 3 ROSE")
          
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
          # print("CAS NOIR")
          
          NULL
        }
      } else if (input$choix_var_ts1 == "XXXX" & input$choix_var_ts2 != "XXXX") {
        if (choix_region_ts1 != "XXXX" & choix_region_ts2 == "XXXX"){
          # print("CAS 1 VERT")
          
          df_barplot = df_init_1ligne %>% 
            mutate(!!var2 := as.numeric(df_tableau_central %>% 
                                          filter(Year == 2003 + input$df_tableau_central_row_last_clicked) %>% 
                                          select(2)),
                   Region = region1)
          
          barplot_stat = amBarplot(x = "Region",
                                   y = c(var2), 
                                   data = df_barplot)
          
          
          
        } else if (choix_region_ts1 == "XXXX" & choix_region_ts2 != "XXXX") {
          # print("CAS 2 VERT")
          
          df_barplot = df_init_1ligne %>% 
            mutate(!!var2 := as.numeric(df_tableau_central %>% 
                                          filter(Year == 2003 + input$df_tableau_central_row_last_clicked) %>% 
                                          select(2)),
                   Region = region2)
          
          barplot_stat = amBarplot(x = "Region",
                                   y = c(var2), 
                                   data = df_barplot)
          
          
          
        } else if (choix_region_ts1 != "XXXX" & choix_region_ts2 != "XXXX") {
          # print("CAS 3 VERT")
          
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
          # print("CAS 1 JAUNE")
          
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
          
          barplot_stat = amBarplot(x = "Region",
                                   y = c(var1, var2), 
                                   legend = T,
                                   legendPosition = "bottom",
                                   data = df_barplot)
          
          
        } else if (choix_region_ts1 != "XXXX" & choix_region_ts2 == "XXXX"){
          # print("CAS 2 JAUNE")
          
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
          
          barplot_stat = amBarplot(x = "Region",
                                   y = c(var1, var2), 
                                   legend = T,
                                   legendPosition = "bottom",
                                   data = df_barplot)
        } else if (choix_region_ts1 != "XXXX" & choix_region_ts2 != "XXXX"){
          # print("CAS 3 JAUNE")
          
          df_intermediaire <- (df_tableau_central %>% 
                                 filter(Year == 2003 + input$df_tableau_central_row_last_clicked))
          
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
      # CAS NOIR
      # print("SELECTIONNER UNE LIGNE DU TABLEAU")
      NULL
    }
  })
  
})


# # Réactivité lorsque l'utilisateur sélectionne une ligne dans le tableau
# observeEvent(input$df_tableau_central_row_last_clicked, {
#   print(input$df_tableau_central_row_last_clicked)
# })

# Réactivité lorsque l'utilisateur actionne le switch pour la seconde région
observeEvent(input$switch_region_stat, {
  reset("choix_region_ts2a")
  reset("choix_region_ts2b")
  reset("choix_region_ts2c")
})

# Réactivité lorsque l'utilisateur actionne le switch pour la seconde variable
observeEvent(input$switch_variable_stat, {
  reset("choix_var_ts2")
  reset("choix_var_ts2")
  reset("choix_var_ts2")
})



# == PDF 1 =============================================================================================

output$pdf1_onglet1 <- renderText({
  page = recode(substr(input$choix_var_ts1, 1, 5), !!!dico_liste_variable_page)
  return(paste('<iframe style="height:500px; width:793px;" src="./pdf/', page, '.pdf', '"></iframe>', sep = ""))
})

# == PDF 2 =============================================================================================

output$pdf2_onglet1 <- renderText({
  page = recode(substr(input$choix_var_ts2, 1, 5), !!!dico_liste_variable_page)
  return(paste('<iframe style="height:500px; width:793px;" src="./pdf/', page, '.pdf', '"></iframe>', sep = ""))
})