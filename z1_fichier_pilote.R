########################################################################################################
# z1_fichier_pilote.R -- Docstring (documentation)
########################################################################################################
#           Ce fichier permet d'exécuter l'ensemble des fichiers à la suite afin de construire 
#           la base de données alimentant l'application Shiny.
#          
#           Les fichiers exécutés sont :
#              - 0_verif_packages.R
#              - z2_code_independant.R
#              - z3_calcul_centre.R
#              - z4_donnees_complementaires_carte.R
#          
#           À la fin du processus, la session R est redémarrée afin de vider la mémoire vide 
#           (les objets de la session sont conservés)
########################################################################################################


########################################################################################################
# Setup global
########################################################################################################
donnees_publiques = 0        # Provenance des données (les données confidientielles  : donnees_publiques = 0)
execution_pilote = 1         # indicateur pour distinguer si on lance depuis le fichier pilote ou non
verification_packages = 0    # vérifier ou non les packages installés sur l'ordinateur
importer_carte = 0           # choix : 0 ou 1
precision = 60               # choix : 1 ou 60 (l'option 1 n'est plus disponible, ne pas changer 60)
chemin_repertoire_donnees = "./data/enquete2/" # en chemin relatif vers les données de l'enquête
date_premiere_enquete = 2012 # année en YYYY de la première enquête à importer
date_derniere_enquete = 2013 # année en YYYY de la dernière enquête à importer
nombre_enquete = date_derniere_enquete - date_premiere_enquete + 1 # ne pas toucher
liste_periode = list(c(2004:2005),
                     c(2006:2009),
                     c(2010:2012),
                     c(2013:2015)) 
liste_periode = list(c(2010:2012),
                     c(2013:2015))
# les périodes sont en fonction des années de modification de la norme NUTS.


########################################################################################################
# Exécution des fichiers
########################################################################################################

date_debut = Sys.time() # servant à indiquer le temps d'exécution du code à la fin de celui-ci

# vérification des packages ############################################################################
if (verification_packages == 1){
    source("0_verif_packages.R", encoding = "UTF-8", echo = T)
}

# on construit d'abord la base des moyennes ... ########################################################
if (donnees_publiques == 0){
    source("z2_code_independant_alternatif.R", encoding = "UTF-8", echo = T)
} else {
    source("z2_code_independant.R", encoding = "UTF-8", echo = T)
}

# Garbage collection : pour vider un peu la mémoire vive après le gros traitement du fichier z2 ... ####
gc() 

# puis on calcule le centre des régions ... ############################################################
source("z3_calcul_centre.R", encoding = "UTF-8", echo = T)

# et on ajoute les variables eurostat complémentaires ##################################################
source("z4_donnees_complementaires_carte.R", encoding = "UTF-8", echo = T)



########################################################################################################
# Fin du processus
########################################################################################################

# Temps d'exécution du code
date_fin = Sys.time()
diff = date_fin - date_debut
print(diff)

# Fin du fichier pilote
rm(execution_pilote)

# Redémarrage de R pour vider correctement la mémoire vive
.rs.restartR()