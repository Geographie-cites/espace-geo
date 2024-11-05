
library(tidyverse)
library(sf)
library(mapsf)
# devtools::install_github("riatelab/mapinsetr")
library(mapinsetr)

eg <- read_tsv("data/netscity_espacegeo/netscity_espacegeo.tsv")

################################################################################


fraca <- eg %>%
  mutate(label = str_to_title(agglo)) %>%
  distinct(id, idcomposite, .keep_all = T) %>%
  group_by(id) %>%
  mutate(c = 1/n_distinct(idcomposite)) %>%
  ungroup() %>%
  group_by(idcomposite) %>%
  mutate(n = sum(c), label = first(label), country = first(country),
         latitude = first(latitude), longitude = first(longitude)) %>%
  ungroup() %>%
  distinct(idcomposite, label, n, country, latitude, longitude) %>%
  arrange(-n) 

# write_tsv(fraca, "data/eg_carto.tsv")

c <- st_as_sf(fraca, coords = c("longitude", "latitude"), 
              crs = 4326, agr = "constant") %>%
  #  st_transform("+proj=vandg4") #  "+proj=vandg4"
  st_transform(crs = 3035) 

# upload the world shapefile

country <- st_read("shp/world/ne_110m_admin_0_countries.shp")

# plot the world

plot(st_geometry(country))

country <- st_transform(x = country, crs = 3035) # "+proj=vandg4", "+proj=eck4" 

plot.new()

mf_map(x = country, col = "white", border = "black")

mask <- create_mask(interactive = T, add = T, prj = st_crs(country)) # select Europe on the map

# mf_export(mask, filename = "plots/eg_map_europe.svg")

mf_init(x = mask)

mf_map(x = country, col = "white", border = "grey", add = T)

mf_map(x = c, var = "n", type = "prop", inches = 0.15, col = "#009473",
       leg_title = "Nombre de publications dans l'Espace Géographique entre 1972 et 2020\n(articles et positions de recherche)", 
       border = "black", lwd = 0.3, add = T) 

mf_credits(txt = "Crédit : M. Maisonobe - Sources : Persée, Cairn et Scopus.\nAffilitions récupérées sur Persée et Cairn par Max Beligne\nTraitement : NETSCITY et mapsf. Comptage fractionné des publications (niveau agglomération urbaine).")

# dev.off()
  