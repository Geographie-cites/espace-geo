library(fmtr)
library(libr)
library(tidyverse)

# create the folders "data" and "plots" in the repository (if missing)

purrr::map(c("data", "plots"), dir.create)

# download the data from Zenodo using the downloading url and save the data in the data folder

# Step 1 : download the data from Zenodo using the downloading url
# URL : "https://zenodo.org/records/14039283/files/netscity_espacegeo.zip?download=1"

download.file(url = "https://zenodo.org/records/14039283/files/netscity_espacegeo.zip?download=1", 
              destfile = "data/netscity_espacegeo.zip", # name and place of the destination file
              mode = "wb") 

# Step 2 : List the content of the zip file: "netscity_espacegeo.zip" in the object lf

lf <- unzip(zipfile = "data/netscity_espacegeo.zip", list = TRUE)

# check the content of the zip file

View(lf)

# Step 3 : Unzip the data tables, remove the zip file, and upload the data tables in R

unzip(zipfile = "data/netscity_espacegeo.zip", # nom du dossier a dezipper
                    files = paste0(lf$Name), # nom du fichier a dezipper (depuis lf)
                    exdir = "data") # placer le fichier dezippe dans data/wos

# remove the zip file for the data folder

file.remove("data/netscity_espacegeo.zip")

# upload the data and metadata tables

eg <- read_tsv("data/netscity_espacegeo/netscity_espacegeo.tsv")

metadata <- read_tsv("data/netscity_espacegeo/metadata.tsv")

summary(eg)

View(metadata)

---------------------------------------------------------------------------------------

# Optional step : update the metadata table

# description of the variables
descriptions(eg) <- list(id = "Publication identifier", 
                         year = "Publication year",
                         address = "City, Province, Country", 
                         city = "City name - geocoded using NETSCITY",
                         agglo = "Urban area name - NETSCITY urban agglomeration level",
                         province = "Province name",
                         country = "Country name",
                         subregion = "UN subregion name",
                         region = "UN region name",
                         continent = "UN continent name",
                         latitude = "City latitude (several possible pairs of coordinates per urban area)",
                         longitude = "City longitude (several possible pairs of coordinates par urban area)",
                         idcomposite = "Urban area identifier",
                         confidence = "SANS_API (geocoded using the NETSCITY database); GEONAMES (geocoded using a dump of the Geonames database); AVEC_API (geocoded with the LocationIQ API)",
                         manual_update = "1 (Geocoded after a manual correction of the raw data in NETSCITY); 0 (Geocoded right after uploading the raw data in NETSCITY)",
                         DOIURL = "Publication DOI if available or the URL of the publication on the Cairn Portal",
                         EID = "Scopus publication identifier",
                         DOI = "Publication DOI",
                         affil = "Affiliations",
                         title = "Publication title",
                         authors = "Authors names",
                         authors_with_affiliations = "Authors with their raw affiliation",
                         num = "EG for Espace Geographique, publication year, volume and issue number",
                         source_affil = "MBMM_notinscopus (affiliation retrieved from Cairn or Persée by Max Beligne); MBMM_from_scopus (affiliation both present on Scopus and in Cairn and Persée); Scopus (affiliation only present on Scopus, retrieved by Marion Maisonobe)",
                         summary = "section in the journal",
                         url = "url of the publication on Cairn or Persée",
                         ISO = "UN country code ISO2",
                         ISO3 = "UN country code ISO3",
                         world_bank_reg = "World Bank region name"
                          )

dico <- dictionary(eg) %>%
  select(-c(Label, Format, Width, Justify))

# export the updated metadata table
# write_tsv(dico, "data/metadata.tsv")

