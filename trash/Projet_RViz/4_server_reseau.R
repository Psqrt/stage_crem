observeEvent(input$club_selection_rs,
             {
                 rs_global = donnees_trans %>% 
                     filter(Team_from == input$club_selection_rs | Team_to == input$club_selection_rs) 
                 
                 df_club_selected = rs_global # pour les graphiques après
                 
                 rs_global = rs_global %>% 
                     select(Team_from, Team_to, Transfer_fee)
                 
                 rs_edges = rs_global %>% 
                     select(from = Team_from,
                            to = Team_to,
                            length = Transfer_fee) %>% 
                     mutate(length = length/1000000+100) # transformation affine pour "réduire" et faire dépendre la longueur du edge
                 
                 df_avec_logos = unique(df_avec_logos[, c("tab_Transferts", "Club.Logo1")])
                 
                 rs_nodes = data.frame(id = unique(c(rs_global$Team_from, rs_global$Team_to)),
                                       label = unique(c(rs_global$Team_from, rs_global$Team_to)),
                                       stringsAsFactors = FALSE)
                 
                 rs_nodes = rs_nodes %>% 
                     mutate(shape = rep("image", nrow(rs_nodes))) %>%
                     inner_join(df_avec_logos, by = c("id" = "tab_Transferts")) %>% 
                     rename(image = Club.Logo1) %>% 
                     replace_na(list(image = "http"))
                 
                 rs = visNetwork(rs_nodes, rs_edges, 
                                 width = "100%", 
                                 height = "1300px",
                                 background = "#fff7d6") %>% 
                     visNodes(brokenImage = "no_logo_network.png")
                 
                 output$rs_network = renderVisNetwork(rs)
                 
                 df_club_selected = df_club_selected %>% 
                     mutate(flow = ifelse(Team_from == input$club_selection_rs,
                                          "outflow",
                                          "inflow"),
                            Transfer_fee = ifelse(flow == "outflow",
                                                  -Transfer_fee,
                                                  Transfer_fee)) # proxy du budget
                 df_club_selected_stats = df_club_selected %>% 
                     group_by(Season) %>% 
                     summarise(nombre = n(),
                               fees_somme = sum(Transfer_fee))
                 
                 df_club_selected_stats2 = df_club_selected %>%
                     group_by(Season, flow) %>% 
                     summarise(quantite = n())
                 
                 df_club_selected_positions = as.data.frame(sort(table(df_club_selected$Position), decreasing = T))
                 
                 output$table_positions_flux = renderTable(df_club_selected_positions,
                                                           colnames = F)
                 
                 
                 line_budget = df_club_selected_stats %>% 
                     ggplot() +
                     aes(x = Season,
                         y = fees_somme,
                         group = 1) + # à cause du x non continu
                     geom_line(col = "#F8766D") +
                     theme_bw() +
                     ylab("Budget spent on transfers (€)") +
                     xlab(NULL) +
                     theme(axis.text.x = element_text(angle = 45, hjust = 1))
                 
                 line_nombre = df_club_selected_stats %>% 
                     ggplot() +
                     aes(x = Season,
                         y = nombre,
                         group = 1) + # à cause du x non continu
                     geom_line(col = "#F8766D") +
                     theme_bw() +
                     ylab("Number of transfers") +
                     xlab(NULL) +
                     theme(axis.text.x = element_text(angle = 45, hjust = 1))
                 
                 line_nombre_sep = df_club_selected_stats2 %>%
                     ggplot() +
                     aes(x = Season,
                         y = quantite,
                         group = flow) + # à cause du x non continu
                     geom_line(aes(col = flow)) +
                     theme_bw() +
                     ylab("Number of transfers") +
                     theme(axis.text.x = element_text(angle = 45, hjust = 1),
                           legend.position = "bottom")
                 
                 
                 output$line_budget = renderPlot(line_budget,
                                                 height = 230)
                 output$line_nombre = renderPlot(line_nombre,
                                                 height = 230)
                 output$line_nombre_sep = renderPlot(line_nombre_sep,
                                                     height = 230)
                 
             }
)

#### STACKED GEOM_AREA PLOT ####################################################
# Sorte de gathering
q1 = donnees_trans %>% 
    select(Club = Team_from, Season, Transfer_fee)
q2 = donnees_trans %>% 
    select(Club = Team_to, Season, Transfer_fee)
q3 = rbind(q1, q2)

# Agrégation
info = q3 %>% 
    group_by(Club, Season) %>% 
    summarise(Fees = sum(Transfer_fee))

# Données utiles sur les saisons pour plus tard
info_saison = q3 %>% 
    group_by(Season) %>% 
    summarise(Total = sum(as.numeric(Transfer_fee)))

# Calcul des ratios (parts de marchés par saison)
info = inner_join(info, info_saison, by = "Season") %>% 
    mutate(Ratio = Fees/Total) 

# Les 10 plus gros clubs, toutes saisons confondues
best = info %>% 
    group_by(Club) %>% 
    summarise(TotFees = sum(as.numeric(Fees))) %>% 
    arrange(-TotFees)

# best[1:10, ]

prems = info %>% 
    filter(Club %in% best[1:10, "Club"][[1]]) %>% 
    mutate(Fees = as.double(Fees))

# On constate que certains clubs de la liste des 10 n'ont 
# pas effectué de transferts sur certaines saisons
# On ajoute l'information manquante.
pansement = data.frame("FC Barcelona", 2005, 0, 0, 0,
                       stringsAsFactors = F)
colnames(pansement) = colnames(prems)
# pansement
pansement2 = data.frame("Spurs", 2018, 0, 0, 0,
                        stringsAsFactors = F)
colnames(pansement2) = colnames(prems)
# pansement2

prems$Season = as.numeric(substr(prems$Season, 1, 4))
prems = bind_rows(prems, pansement, pansement2) %>% 
    mutate(Ratio = 100 * Ratio)

# graphique
graph_share_stacked = prems %>% 
    ggplot() +
    aes(x = Season, y = Ratio, fill = Club) +
    geom_area(color = "white", size = 0.15) +
    scale_x_continuous(breaks = pretty(x = prems$Season, 
                                       n = length(unique(prems$Season))),
                       labels = c(unique(info_saison$Season)),
                       limits = c(2000, 2021)) +
    theme(axis.text.x = element_text(angle = 45, hjust = 1),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          legend.position = "none") +
    geom_dl(aes(label = Club, color = Club), 
            position = "stack", 
            method = list("last.bumpup", rot = 0, cex = 0.8, dl.trans(x = x + 0.2))) +
    scale_y_continuous(name = "Market share",
                       labels = dollar_format(suffix = "%", prefix = "")) # yep ...
output$marketshare = renderPlot(graph_share_stacked)

