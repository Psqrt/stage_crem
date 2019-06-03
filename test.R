# library(stringr)
# library(dplyr)
# 
# con = gzcon(url("https://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing?file=data/demo_r_d2jan.tsv.gz"))
# 
# contenu = readLines(con)
# 
# contenu_clean = str_remove_all(contenu, "[ bcdefnprsuz]")
# 
# df = read.delim(file = textConnection(contenu_clean),
#                 sep = "\t",
#                 header = T,
#                 na.strings = c(":"),
#                 stringsAsFactors = F)
# 
# close(con)
# 
# 







library(polylabelr)
# library(tidyverse)


library(ggpubr)

n = sample(1:30, 1)
n=10
print(n)

coords = data_map2013_nuts0@polygons[[n]]@Polygons[[1]]@coords %>% as.data.frame

pole = poi(coords$V1, coords$V2, precision = 0.01)

coords2 = data_map2013_nuts0@polygons[[15]]@Polygons[[1]]@coords %>% as.data.frame

pole2 = poi(coords2$V1, coords2$V2, precision = 0.01)

q1 = coords %>% ggplot() +
    aes(x = V1, y = V2) +
    geom_polygon() +
    theme_bw() +
    geom_point(aes(x = data_map2013_nuts0@polygons[[n]]@Polygons[[1]]@labpt[1],
                   y = data_map2013_nuts0@polygons[[n]]@Polygons[[1]]@labpt[2]), col = "red") +
    ggtitle("Point centroid (par défaut)") +
    xlab(NULL) +
    ylab(NULL)

q2 = coords %>% ggplot() +
    aes(x = V1, y = V2) +
    geom_polygon() +
    theme_bw() +
    geom_point(aes(x = pole$x,
                   y = pole$y), col = "red") +
    ggtitle("Pole d'inaccessibilité") +
    xlab(NULL) +
    ylab(NULL)

q3 = coords2 %>% ggplot() +
    aes(x = V1, y = V2) +
    geom_polygon() +
    theme_bw() +
    geom_point(aes(x = data_map2013_nuts0@polygons[[15]]@Polygons[[1]]@labpt[1],
                   y = data_map2013_nuts0@polygons[[15]]@Polygons[[1]]@labpt[2]), col = "red") +
    ggtitle("Point centroid (par défaut)") +
    xlab(NULL) +
    ylab(NULL)

q4 = coords2 %>% ggplot() +
    aes(x = V1, y = V2) +
    geom_polygon() +
    theme_bw() +
    geom_point(aes(x = pole2$x,
                   y = pole2$y), col = "red") +
    ggtitle("Pole d'inaccessibilité") +
    xlab(NULL) +
    ylab(NULL)

ggarrange(q1, q2, q3, q4,
          ncol = 2,
          nrow = 2)
