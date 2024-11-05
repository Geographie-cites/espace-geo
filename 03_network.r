library(tidyverse)
library(igraph)
library(tnet)
library(cartography)
install.packages("functions/cartigraph/cartigraph_0.0.0.9000.tar.gz", repos = NULL, type = "source")
library(cartigraph)
library(HyperG)

eg <- read_tsv("data/netscity_espacegeo/netscity_espacegeo.tsv")

################################################################################

source("functions/hypercartigraph.r")


d <- eg %>%
  select(id, idcomposite, agglo, country) %>%
  distinct(id, idcomposite, .keep_all = T)

g <- cartigraph::netproj(d = d, e = id, p = idcomposite, method = "sum")

# keep only dyads with at least 2 co-publications

gtop <- delete_edges(g, E(g)[weight < 2])

V(gtop)$degree <- degree(gtop)

gtop <- induced_subgraph(gtop, vids = V(gtop)$degree > 0)

vert <- V(gtop)$name

# filter the dataset to keep only the urban agglomerations involved in at least 2 co-publications

d <- d %>%
  filter(idcomposite %in% vert) 

## intermediary step to get an hypergraph

# prepare the data to identify clusters of urban agglomerations with at least 2 co-publications

prep <- d %>%
  group_by(id) %>%
  summarize(l = list(idcomposite)) %>%
  group_by(l) %>%
  summarise(n = n_distinct(id)) %>%
  rowwise() %>%
  mutate(lg = length(l)) %>%
  filter(n > 1 & lg > 1) %>%
  rowid_to_column("id")

prep %>%
  ungroup() %>%
  summarise(n = sum(n))

# get an hypergraph

h <- hypergraph_from_edgelist(pull(prep, l))

h$names <- str_to_title(d$agglo[match(hnames(h), d$idcomposite)])

h <- reorder_vertices(h, decreasing = F)

# get an hyperedges table

htable <- prep %>%
  unnest(l) %>%
  left_join(distinct(d, idcomposite, agglo, country), by = c("l" = "idcomposite")) %>% # warning CHINA and TAIWAN as a country same agglo!!
  group_by(id) %>%
  mutate(nb_country = n_distinct(country)) %>%
  ungroup() %>%
  mutate(inter = ifelse(nb_country > 1, T, F)) # %>% 
  # write_tsv("data/hyperedge_list.tsv") # for Figure 3


# compute the nb of international and domestic hyperedges

htable %>% 
  distinct(id, nb_country) %>%
  count(nb_country)

# categorical variable : 
# TRUE if the hyperedge clusters urban agglomerations belonging to more than 1 country

h$cat <- htable %>%
  group_by(id) %>%
  summarise(cat = first(inter)) %>%
  pull(cat)

# nb of co-publications per urban agglomeration

h$size <- htable %>%
  group_by(l) %>%
  summarise(n = sum(n)) %>%
  pull(n)

h$names <- str_to_title(d$agglo[match(hnames(h), d$idcomposite)])

h$names

svg(paste("plots/Figure_3.svg"), width = 8, height = 6) # for Figure 6

hypercartigraph(h, 
                title = "Ensembles d'aires urbaines co-publiant dans l'Espace Géographique (2 co-publications ou plus)", 
                sources = "Source: Persée - Cairn - Scopus - Netscity. Packages R {Cartography}, {igraph} et {HyperG}.",
                author = "M. Maisonobe, 2024. Affiliations récupérées dans Persée et Cairn par Max Beligne",
                legend.title.nodes = "Nb de co-publications",
                legend.cat = c("international", "intra-national"), 
                legend.title.cat = "Type de collaboration")

dev.off()

# hypergraph exploration

print(h)
summary(h)
hnames(h)
hdegree(h)
horder(h)
hsize(h)
edge_orders(h)

plot.new()
plot.hypergraph(h)
dev.off()

write_rds(h, "data/hypergraph_eg.rds")
