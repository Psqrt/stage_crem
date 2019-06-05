# stage_crem

## /!\\ Remarques pratiques

L'application est divisée en plusieurs modules. On reviendra en détail sur le rôle de chaque fichier, mais pour l'instant, les fichiers qui servent à exécuter l'application sont (à exécuter dans l'ordre) :


* (1) Lancer ***stage_crem.Rproj*** et s'assurer que les fichiers suivants sont ouverts dans le cadre du projet stage_crem.
* (2) Le code ***0_verif_packages.R*** permet d'installer l'ensemble des packages nécessaires au bon déroulement des codes suivants.
* (3) Le code ***code_independant.R*** pour créer le fichier alimentant l'application shiny (pas tout à fait en fait ...). Le temps d'éxecution de ce code est d'environ 5 minutes pour notre ordinateur portable de travail (ordre d'idée)
    - Si les bases de données sont déjà créées (c'est-à-dire que le répertoire ***./data/finaux*** n'est pas vide), alors il n'est pas nécessaire de lancer ce code.
    - Si vous lancez ce code pour la première fois, il est nécessaire d'importer les données spatiales (polygones de carte). Dans le code ***code_independant.R***, il faut mettre 1 à la variable ***importer_carte*** (ligne 11 du code)
    - Si vous lancez ce code pour la seconde fois, il n'est plus nécessaire d'importer les données spatiales (à condition de les avoir dans la session R active). Il faudra alors remettre la variable ***importer_carte*** à 0.
* (4) Le code ***calcul_centre.R*** est à lancer ensuite, il permet de greffer à la base de données issue de l'étape (3), deux nouvelles colonnes, qui permettent de positionner le "centre" de chaque région. Le temps d'exécution ne dépasse pas 15 secondes.
* (5) Le code ***donnees_complementaires_carte.R*** pour créer le fichier alimentant le panel de droite de la carte (données socio-démo-économiques sur la région). Le temps d'exécution de ce code est de moins de 30 secondes (le délai vient essentiellement du téléchagement des 9 bases de données directement prises sur le site d'Eurostat)
    - Le bon déroulement de l'exécution de ce code nécessite l'existence du fichier de données ***./data/finaux/donnees.csv*** (celui créé à partir du code précédent)
    - Si le répertoire ***./data/finaux*** n'a pas été vidé, alors il n'est pas nécessaire d'exécuter ce code (le fichier créé existe déjà)
* (6) Le code ***1_fichier_lanceur.R*** permet de démarrer l'application shiny. Le temps de lancement est inférieur à 2 secondes normalement.
    - Si les deux précédents codes ont été exécutés avant, l'application peut directement être lancée.

Les fichiers se cumulent de plus en plus, rendant de moins en moins facile la construction des données, donc il sera prévu de créer un fichier "central" qui servira de tableau de bord afin d'exécuter ces étapes ci-dessus, avec la possibilité ou non de passer des étapes (si les données ont déjà été créées avant).


## Administration

* Dropbox : https://www.dropbox.com/home/Stage%20M1%20-%20Pr%C3%A9carit%C3%A9%20%C3%A9nerg%C3%A9tique
* Github : https://github.com/Psqrt/stage_crem
* Maquette : https://balsamiq.cloud/sgf7255/pky7rtu/r3D7B
* Transformations NUTS : https://docs.google.com/document/d/1IRVb8912ijZBV2mBxJdbu_GYBd4NTY5QlBu008ZSkXw/edit
* Détails des variables retenues : https://docs.google.com/document/d/1qfzHbjN1enVYsdSeOloMRwxj7nW6uSb4Yq8c_FLZCR0/edit
* Documentation Programme Indépendant : https://docs.google.com/document/d/1Zie090c7jKBRM7OdSxhfMM6s7Pyy1T5helV3eWCTnnY/edit#heading=h.2ldbl6ws0ers

### Rapports

* Rapport 1 : https://docs.google.com/document/d/1-z5IbRFjhgHSs6zwLoByYDJXsHQUUa0QpQ2p6zoMuzo/edit
* Rapport 2 : https://docs.google.com/document/d/1VrJxGSwtAESfuOQFKSoIyODAAj68VapsTirIRVFsrYU/edit  
* Rapport 3 : https://docs.google.com/document/d/16wZxiQ52D4dDHrUmpOiZVj5TBNeec611DEXRmDoFvbk/edit
* Rapport 4 : https://docs.google.com/document/d/1dxWyNT5gl4dCZRpWX4IFYPVkQxzU8LIjnttgMnfCnWs/edit

## Données
* Données de l'enquête : https://ec.europa.eu/eurostat/fr/web/microdata/statistics-on-income-and-living-conditions
* Données GIS : https://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units/nuts

## NUTS
* Changement des versions de la norme NUTS : https://ec.europa.eu/eurostat/fr/web/nuts/history
* Informations NUTS : http://database.espon.eu/db2/jsf/DicoSpatialUnits/DicoSpatialUnits_html/ch01s01.html
* Documentation NUTS2003 : **lien mort**
* Documentation NUTS2006 : https://ec.europa.eu/eurostat/documents/3859598/5902960/KS-RA-07-020-FR.PDF/a813b609-304a-4ec7-81f9-85ab33dfb2d1?version=1.0
* Documentation NUTS2010 : https://ec.europa.eu/eurostat/documents/3859598/5916917/KS-RA-11-011-EN.PDF/2b08d38c-7cf0-4157-bbd1-1909bebab6a6?version=1.0
* Documentation NUTS2013 : https://ec.europa.eu/eurostat/documents/3859598/6948381/KS-GQ-14-006-EN-N.pdf/b9ba3339-b121-4775-9991-d88e807628e3

## Géographie
* Norme IBAN/ISO2 : https://www.iban.com/country-codes
* Carte Europe avec ISO2 : https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2#/media/File:Europe_ISO_3166-1.svg
* Liste pays de l'UE : https://fr.wikipedia.org/wiki/%C3%89tats_membres_de_l%27Union_europ%C3%A9enne

### Algorithme de recherche du pole d'inaccessibilité
* Concept : https://en.wikipedia.org/wiki/Pole_of_inaccessibility
* Source : https://blog.mapbox.com/a-new-algorithm-for-finding-a-visual-center-of-a-polygon-7c77e6492fbc
* Explications : https://github.com/mapbox/polylabel
* Implémentation R : https://github.com/jolars/polylabelr


## Coloration
* Choix des palettes : http://colorbrewer2.org/

## Shiny
* Gallerie widgets : http://shinyapps.dreamrs.fr/shinyWidgets/
* Fonds de carte : https://leaflet-extras.github.io/leaflet-providers/preview/
* Fonction HTML : https://shiny.rstudio.com/articles/tag-glossary.html 
* Icones : https://fontawesome.com/icons/plus-circle?style=solid
