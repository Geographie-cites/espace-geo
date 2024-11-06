### La géographie de _L'Espace Géographique_ / The geography of the academic journal _L'Espace Géographique_

fr : Script et fonctions R pour reproduire le tableau et les figures de la publication intitulée : "La géographie de _L’Espace Géographique_"

- Marion Maisonobe (2022). "La géographie de _L’Espace Géographique_", _L'Espace Géographique_, n°4.

Les données utilisées ont été produites par l'autrice en collaboration avec Max Beligné et déposées sur Zenodo :

Maisonobe, M., Beligné, M., & UMR Géographie-cités. (2024). Metadata and georeferencing of the publications in the academic journal 'L'Espace Géographique' (1972-2020) [Data set]. Zenodo. [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.14039283.svg)](https://doi.org/10.5281/zenodo.14039283)

en: R script and functions to reproduce the table and figures comprised in "La géographie de _L’Espace Géographique_"

-------------------------------------------------------------------------------------------------------------------------
# Contenu du répertoire / Contents of the repository

fr : Ce repertoire git permet de reproduire les tableaux et figures de la publication "La géographie de _L’Espace Géographique_" à partir du jeu de données Zenodo.

Il comprend 4 scripts, 2 fonctions, le package en cours de développement {cartigraph}, et un shapefile du monde.

- "00_data.R": un script pour télécharger les données depuis zenodo et mettre à jour (si nécessaire) les métadonnées
- "01_stats.R" : un script pour calculer les pourcentages commentés dans la publication, produire le tableau 1, et les figures 1 et 4.
- "02_map.R" : un script pour réaliser la carte de provenance des publications parues dans la revue _L'Espace Géographique_ (Figure 2).
- "03_network.R" : un script pour visualiser la géographie des co-publications sous forme d'hypergraphe (Figure 3).
- "Functions/scaletime.R" : une fonction pour produire les figures 1 et 4 (distribution spatiale et temporelle de la production par entité géographique).
- "Functions/hypercartigraph.R" : une fonction pour produire la figure 3 (hypergraphe des liens de co-publications entre aires urbaines).
- "Functions/cartigraph" : un package en cours de développement pour convertir des tables de liens en graphes, les pondérer et les représenter.
- "shp/world" : fond ce carte des pays du monde (Natural Earth data) utilisé pour dessiner la carte.

en : This git repository is used to reproduce the tables and figures in "La géographie de _L’Espace Géographique_" from the Zenodo dataset: "Metadata and georeferencing of the publications in the academic journal 'L'Espace Géographique' (1972-2020) [Data set]".

It includes 4 scripts, 2 functions, the {cartigraph} package, and a shapefile of the world.

- 00_data.R": a script to download the data from Zenodo and update (if necessary) the metadata table.
- 01_stats.R": a script to calculate the percentages commented on in the publication, produce table 1, and figures 1 and 4.
- 02_map.R": a script to produce a map of the origin of publications issued in the journal _L'Espace Géographique_ (Figure 2).
- 03_network.R": a script for displaying the geography of co-publications in the form of an hypergraph (Figure 3).
- Functions/scaletime.R": a function to produce figures 1 and 4 (spatial and temporal distribution of the academic production by spatial entity).
- Functions/hypercartigraph.R": a function to produce figure 3 (hypergraph of co-publications links between urban areas).
- Functions/cartigraph": a package under development for converting edge lists into graphs, weighting them and representing them.
- shp/world": shapefile of the countries of the world (Natural Earth data) used to draw the map.
