suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(glue))

# Download zip file from GBIF ---------------------------------------------

if (!file.exists("tmp/0399802-210914110416597.zip")) {
  cat("Downloading data from GBIF\n")
  download.file(
    "https://api.gbif.org/v1/occurrence/download/request/0399802-210914110416597.zip",
    "tmp/0399802-210914110416597.zip",
    quiet = TRUE
  )
}

# Process the images for the entries that have them -----------------------

cat("Obtaining image URLs from metadata\n")
# use the first image only
media <- read_tsv(
  unz(
    "tmp/0399802-210914110416597.zip",
    "multimedia.txt"
  ),
  col_types = cols(
    .default = col_skip(),
    gbifID = col_character(),
    identifier = col_character()
  )
) %>%
  rename(img_url = identifier) %>%
  arrange(gbifID, img_url) %>%
  group_by(gbifID) %>%
  top_n(1, img_url)


# Generate the main datasets ----------------------------------------------

cat("Processing the observations data, augmented with image URLs\n")
raw_df <- read_tsv(
  unz(
    "tmp/0399802-210914110416597.zip",
    "occurrence.txt"
    ),
  col_types = cols(
    .default = col_skip(),
    gbifID = col_character(),
    identifier = col_character(),
    occurrenceID = col_character(),
    eventDate = col_date(format = "%Y-%m-%dT00:00:00"),
    year = col_integer(),
    month = col_integer(),
    day = col_integer(),
    individualCount = col_integer(),
    countryCode = col_character(),
    locality = col_character(),
    decimalLatitude = col_number(),
    decimalLongitude = col_number(),
    kingdom = col_character(),
    vernacularName = col_character(),
    scientificName = col_character()
  )
)

# Observations of organisms in Poland
pl_df <- raw_df %>%
  select(-vernacularName) %>%
  left_join( # try to complete some missing Vernacular Names
    raw_df %>%
      select(
        scientificName,
        vernacularName
      ) %>%
      distinct() %>%
      filter(vernacularName != ""),
    by = "scientificName"
  ) %>% # add image info
  left_join(
    media,
    by = "gbifID"
  ) %>% # prepare extra columns
  mutate(
    img_url = replace_na(
      img_url,
      "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg"
    ),
    vernacularName = replace_na(
      vernacularName,
      "*Common name not recorded*"
    ),
    org_name = glue("{scientificName} / {vernacularName}"),
    popup_lbl = glue(
      "<h4><i>{scientificName}</i><br/>",
      "<b>{vernacularName}</b></h4><br/>",
      "<table>",
      "<tr><th>Obs. ID:</th><td>{identifier}</td>",
      "<td rowspan='5'><img src='{img_url}' width = '120px'/></td></tr>",
      "<tr><th>Date:</th><td>{eventDate}</td></tr>",
      "<tr><th>Count:</th><td>{individualCount}</td></tr>",
      "<tr><th>Location:</th><td>{locality}</td></tr>",
      "<tr><th>Kingdom:</th><td>{kingdom}</td></tr>",
      "</table><br/>",
      "[ 📄️ <a href='{occurrenceID}' target = '_blank'>More details...</a> ]"
    ),
    str_lbl = glue(
      "{scientificName} / {vernacularName} / Count: {individualCount}"
    )
  )

saveRDS(
  pl_df,
  "data/pl_data.rds"
)

# Equivalencies of scientific and vernacular names
cat("Saving the equivalencies of scientific and common names\n")
names_df <- pl_df %>%
  select(
    scientificName,
    vernacularName,
    org_name
  ) %>%
  distinct()

saveRDS(
  names_df,
  "data/species_names.rds"
)
