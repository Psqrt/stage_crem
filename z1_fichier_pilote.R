# Ce fichier permet d'exécuter l'ensemble des fichiers à la suite afin de construire la base de données alimentant l'application Shiny.


###################################################################################################
# Setup global
###################################################################################################
execution_pilote = 1 # indicateur pour distinguer si on lance depuis le fichier pilote ou non
verification_packages = 0 # vérifier ou non les packages installés sur l'ordinateur
importer_carte = 1 # choix : 0 ou 1
precision = 60 # choix : 1 ou 60
chemin_repertoire_donnees = "./data/enquete/" # en chemin relatif
date_premiere_enquete = 2004
date_derniere_enquete = 2013
nombre_enquete = date_derniere_enquete - date_premiere_enquete + 1
liste_periode = list(c(2004:2005),
                     c(2006:2009),
                     c(2010:2012),
                     c(2013:2015))


###################################################################################################
# Exécution des fichiers
###################################################################################################

date_debut = Sys.time()

# vérification des packages
if (verification_packages == 1){
    source("0_verif_packages.R", encoding = "UTF-8", echo = T)
}

# on construit d'abord la base des moyennes ...
source("z2_code_independant.R", encoding = "UTF-8", echo = T)

# gestion de la mémoire vive
gc() 

# puis on calcule le centre des régions ...
source("z3_calcul_centre.R", encoding = "UTF-8", echo = T)

# et on ajoute les variables eurostat complémentaires
source("z4_donnees_complementaires_carte.R", encoding = "UTF-8", echo = T)




# fin du pilote

date_fin = Sys.time()
diff = date_fin - date_debut
print(diff)
rm(execution_pilote)

# redémarrage de R pour vider correctement la mémoire vive
.rs.restartR()