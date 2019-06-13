library(polylabelr)
library(tidyverse)

# Pour résoudre des problèmes d'encodage ...
if (Sys.info()[1] == "Windows"){
    Sys.setlocale("LC_ALL","English")
}

# Si on ne lance pas depuis le fichier pilote, executer ceci (la condition n'est pas tout à fait équivalente...)
if (!exists("execution_pilote")){
    date_premiere_enquete = 2004
    date_derniere_enquete = 2013
    
    
    liste_periode = list(c(2004:2005),
                         c(2006:2009),
                         c(2010:2012),
                         c(2013:2015))
}



df_identifiants = data.frame()
df_coords = data.frame()

for (nuts in c(0:2)){
    for (annee_enquete in c(date_premiere_enquete:date_derniere_enquete)) {
        if (annee_enquete < 2006){
            annee_carte = 2003
        } else if (annee_enquete >= 2006 & annee_enquete < 2010){
            annee_carte = 2006
        } else if (annee_enquete >= 2010 & annee_enquete < 2013){
            annee_carte = 2010
        } else if (annee_enquete >= 2013 & annee_enquete < 2016){
            annee_carte = 2013
        } else { # CODEBOOK-REFERENCE01 : transformer le else en if else si nécessaire pour les prochaines normes
            annee_carte = 2016
        }
        choix_carte = paste0("data_map", annee_carte, "_nuts", nuts, sep = "")
        
        liste_ids = data.frame("REGION" = get(choix_carte)$NUTS_ID,
                               "NUTS" = paste("NUTS", nuts),
                               "ANNEE" = annee_enquete)
        
        bonne_carte = get(choix_carte)
        nombre_region = length(bonne_carte@polygons)
        
        for (region in 1:nombre_region){
            nombre_poly = length(bonne_carte@polygons[[region]]@Polygons)
            aire_max = -1 # réinitialisation
            imax = -1 # réinitialisation
            for (poly in c(1:nombre_poly)){
                aire = bonne_carte@polygons[[region]]@Polygons[[poly]]@area
                if (aire > aire_max){
                    aire_max = aire
                    imax = poly
                }
            }
            bon_polygon = bonne_carte@polygons[[region]]@Polygons[[imax]]@coords
            
            df_bon_poly = data.frame("x" = poi(bon_polygon[, 1], bon_polygon[, 2], precision = 0.01)$x,
                                     "y" = poi(bon_polygon[, 1], bon_polygon[, 2], precision = 0.01)$y)
            
            df_coords = df_coords %>% 
                bind_rows(df_bon_poly)
        }
        
        df_identifiants = df_identifiants %>% 
            bind_rows(liste_ids)
    }
}


df_total_annee = df_identifiants %>% 
    bind_cols(df_coords)




df_total_periode = data.frame()

for (i in c(1:length(liste_periode))){
    df_temporaire_periode = df_total_annee %>% 
        filter(ANNEE == liste_periode[[i]][1]) %>% 
        mutate(PERIODE = paste(liste_periode[[i]][1], "-", liste_periode[[i]][length(liste_periode[[i]])], sep = "")) %>% 
        select(-ANNEE)
    
    df_total_periode = df_total_periode %>% 
        bind_rows(df_temporaire_periode)
}

df_total = df_total_annee %>% 
    bind_rows(df_total_periode) %>% 
    select(REGION, NUTS, ANNEE, PERIODE, LNG_CENTRE = x, LAT_CENTRE = y)



write.csv(df_total, 
          file = "./data/finaux/centre_poly.csv",
          row.names = F,
          fileEncoding = "UTF-8")
