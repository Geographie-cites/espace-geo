
library(tidyverse)

eg <- read_tsv("data/db_netscity_espacegeo.tsv")

################################################################################


# Table 1

tab1 <- eg %>%
  group_by(id) %>%
  mutate(nb_countries = n_distinct(country)) %>%
  mutate(nb_agglo = n_distinct(agglo)) %>%
  mutate(international = ifelse(nb_countries < 2, 0, 1)) %>%
  mutate(interurban = ifelse(nb_agglo < 2, 0, 1)) %>%
  mutate(fr = ifelse(id %in% fr, 1, 0)) %>%
  mutate(paris = ifelse(id %in% paris, 1, 0)) %>%
  ungroup() %>%
  distinct(id, year, international, nb_countries, interurban, nb_agglo, fr, paris) %>%
  mutate(dec = case_when(year < 1978 ~ "1972-1977",
                         year < 1983 & year >= 1978 ~ "1978-1983",
                         year < 1990 & year >= 1983 ~ "1984-1989",
                         year < 1997 & year >= 1990 ~ "1990-1996",
                         year < 2003 & year >= 1997 ~ "1997-2002",
                         year < 2011 & year >= 2003 ~ "2003-2010",
                         TRUE ~ "2011-2020")) %>%
  group_by(dec) %>%
  summarise(n = n(), ni = sum(international), nu = sum(interurban), meanc = mean(nb_countries), meana = mean(nb_agglo), 
            nfr = sum(fr), nparis = sum(paris)) %>%
  mutate(nsolo = n-ni, pi = ni/n*100, pfr = nfr/n*100, pparis = nparis/n*100)

# Tableau 1. Progression des collaborations interurbaines et internationales. 
# Part des articles de l’Espace Géographique signés depuis la France et depuis l’agglomération parisienne.

tab1 %>%
  select(Période = dec, "Nb art" = n, # Nb. d'articles
         "Nb pays/art" = meanc, # Nb. moyen de pays par article
         "Nb agglo/art" = meana, # Nb. moyen d’agglo. par article
         "% international" = pi, # Part de co-publications internationales
         "% France" = pfr, # Part d’articles signés depuis au moins une adresse en France
         "% Paris" = pparis) # Part d’articles signés depuis une adresse francilienne

# Figure 1

# Title of the figure:
# L’Espace Géographique, origine géographique des articles entre 1972 et 2020 par pays. 

source("scaletime.r")

svg(paste("plots/Figure_1.svg"), width = 12, height = 7)

scaletime(d = eg, id = id, year = year, unit = country,  group = continent, 
          method = "complete", # unweighted 
          min = 1972, max = 2020, k = 55, graph = TRUE, colour_axis = TRUE,
          size_label = "N. de publications\nIn l'Espace Géo.",
          x_title = "Année",
          title = "L'Espace géographique, origine des articles par pays d'après l'affiliation des auteurs", 
          ego_level = country, caption = TRUE, source = "Scopus, Persée et Cairn (articles)", 
          author = "\nMarion Maisonobe, 2024. Récupération des affiliations sur Persée et Cairn : Max Beligné")


dev.off()

# Figure 4

# Title of the figure:
# L’Espace Géographique, origine géographique des articles entre 1972 et 2020 par agglomération.

svg(paste("plots/Figure_4.svg"), width = 9, height = 6)

scaletime(d = eg, id = id, year = year, unit = agglo, method = "complete", ego_level = agglo,
          min = 1972, max = 2020, k = 47, graph = TRUE, group = continent, 
          size_label = "N. de publications\nIn l'Espace Géo.",
          x_title = "Année",
          title = "L'Espace géographique, origine des articles par aire urbaine d'après l'affiliation des auteurs", 
          caption = TRUE, source = "Scopus, Persée et Cairn (articles)", 
          author = "\nMarion Maisonobe, 2024. . Récupération des affiliations sur Persée et Cairn : Max Beligné")


dev.off()

###################################################################################

# Number of countries
eg %>%
  distinct(country)

# Number of countries per continent
eg %>%
  distinct(country, continent) %>%
  count(continent)

# subset of publications: France

fr <- eg  %>%
  filter(country %in% c("FRANCE")) %>%
  distinct(id) %>%
  pull(id)

eg  %>%
  filter(! country %in% c("FRANCE")) %>%
  distinct(id) %>%
  nrow()

nrow(distinct(eg %>% filter(!country %in% "FRANCE"), id))

# share of publications from France

length(fr)/nrow(distinct(eg, id))

# Number of publications per country (in/outside the editorial board)

eg %>%
  group_by(country) %>%
  summarise(n = n_distinct(id)) %>%
  filter(country %in% c("SENEGAL", "ALGERIA", "ARGENTINA", "BENIN",
                        "BURKINA-FASO", "IVORY-COAST", "NEW-ZEALAND",
                        "HUNGARY", "MADAGASCAR", "VANUATU", "SWEDEN",
                        "MEXICO", "IRELAND", "NORWAY", "BULGARIA"))

# Number of publications per francophone country

eg %>%
  group_by(country) %>%
  summarise(n = n_distinct(id)) %>%
  filter(country %in% c("BELGIUM", "CANADA", "SWITZERLAND"))

(71+55+45)/
  nrow(distinct(a %>% filter(!country %in% "FRANCE"), id))

# Number of publications per top country

eg %>%
  group_by(country) %>%
  summarise(n = n_distinct(id)) %>%
  arrange(-n)

(25+23+19+17+13+9)/
  nrow(distinct(a %>% filter(!country %in% "FRANCE"), id))

# subset of publications: Paris

paris <- eg  %>%
  filter(agglo %in% c("PARIS")) %>%
  distinct(id) %>%
  pull(id)

# Number of agglomeration

eg %>%
  distinct(idcomposite)

# Number of french agglomeration 

eg %>%
  filter(country %in% "FRANCE") %>%
  distinct(idcomposite)

# Number of publications per agglomeration

eg %>%
  group_by(idcomposite) %>%
  summarise(n = n_distinct(id), agglo = first(agglo)) %>%
  arrange(-n)

# Share of co-publications (more than 2 agglomerations)

eg %>%
  group_by(id) %>%
  mutate(collab = n_distinct(idcomposite)) %>%
  ungroup() %>%
  filter(collab >= 2) %>%
  nrow() /(eg %>%
             distinct(id) %>%
             nrow()) *100

# Share of co-publications from at least 3 agglomerations

eg %>%
  group_by(id) %>%
  mutate(collab = n_distinct(idcomposite)) %>%
  ungroup() %>%
  filter(collab >= 3) %>%
  nrow() /(eg %>%
             distinct(id) %>%
             nrow()) *100

# Top agglomerations

top50 <- eg %>%
  group_by(agglo, idcomposite) %>%
  summarise(n = n_distinct(id), fy = min(year), fymax = max(year)) %>%
  mutate(etendu = fymax - fy) %>%
  arrange(-n) %>%
  ungroup() %>%
  slice_max(n, n = 48, with_ties = T)

top50 %>%
  filter(fy <= 1982) # 1992


# Share of publications (Top 50)
top50 %>%
  summarise(sn = sum(n))/(eg %>%
                            distinct(id) %>%
                            nrow())*100

# Share of publications (Top 15)

top15 <- eg %>%
  group_by(agglo, idcomposite) %>%
  summarise(n = n_distinct(id)) %>%
  arrange(-n) %>%
  ungroup() %>%
  slice_max(n, n = 15, with_ties = T)

top15 %>%
  summarise(sn = sum(n))/(eg %>%
                            distinct(id) %>%
                            nrow())*100

##########################################################################################

