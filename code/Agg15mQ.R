library(here)
library(magrittr)
library(dplyr)
library(ggplot2)

NEON_Q_ARIK_1min=readRDS(here::here("data/discharge/NEON_Q_ARIK_1min.rds"))

seq<-seq(1, nrow(NEON_Q_ARIK_1min), by = 15)

min_15 <- NEON_Q_ARIK_1min %>% 
  slice(seq(1, n(), by = 15))


saveRDS(min_15, file = "data/discharge/NEON_Q_ARIK_15min.rds")
write.csv()

sites<-as.data.frame(c("ARIK", "BIGC", "BLDE", "BLUE", "CARI", "COMO", "CUPE", "GUIL", "HOPB", "KING", "LECO", "LEWI", "MART", "MAYF", "MCDI", "MCRA", "OKSR", "POSE", "PRIN", "REDB", "SYCA", "TECR", "WALK", "WLOU"), col.names=site)
names(sites)[1] <- "site"

library(tidyverse)
library(glue)

# Loop through each site in your sites vector

site_vector <- as.data.frame(sites)[[1]]
for (site in sites) {
  
  # 1. Construct the input file path and read the data
  input_path <- here::here(glue("data/discharge/NEON_Q_{site}_1min.rds"))
  
  # Optional check: skip to next site if the 1-minute file doesn't exist
  if (!file.exists(input_path)) {
    warning(glue("File not found for site: {site}. Skipping..."))
    next
  }
  
  df_1min <- readRDS(input_path)
  
  # 2. Subset the data every 15 rows
  df_15min <- df_1min %>% 
    slice(seq(1, n(), by = 15))
  
  # 3. Save as RDS
  rds_output_path <- here::here(glue("data/discharge/NEON_Q_{site}_15min.rds"))
  saveRDS(df_15min, file = rds_output_path)
  
  # 4. Save as CSV (filled in your write.csv function)
  csv_output_path <- here::here(glue("data/discharge/NEON_Q_{site}_15min.csv"))
  write.csv(df_15min, file = csv_output_path, row.names = FALSE)
  
}



library(tidyverse)
library(glue)

# 1. Force 'sites' into a pure vector of text strings.
# (This extracts the first column regardless of whether it has a header or not)
site_vector <- as.data.frame(sites)[[1]]

# 2. Run the loop exactly as before using the new vector
for (site in site_vector) {
  
  input_path      <- here::here(glue("data/discharge/NEON_Q_{site}_1min.rds"))
  rds_output_path <- here::here(glue("data/discharge/NEON_Q_{site}_15min.rds"))

  if (!file.exists(input_path)) {
    warning(glue("File not found for site: {site}. Skipping..."))
    next
  }
  
  df_1min <- readRDS(input_path)
  
  df_15min <- df_1min %>% 
    slice(seq(1, n(), by = 15))
  
  saveRDS(df_15min, file = rds_output_path)
  
}




library(tidyverse)
library(glue)

# 1. Force 'sites' into a pure vector of text strings
site_vector <- as.data.frame(sites)[, 1]

# 2. Create an empty list to store the dataframes temporarily
output_list <- list()

for (site in site_vector) {
  
  input_path      <- here::here(glue("data/discharge/NEON_Q_{site}_1min.rds"))
  rds_output_path <- here::here(glue("data/discharge/NEON_Q_{site}_15min.rds"))
  csv_output_path <- here::here(glue("data/discharge/NEON_Q_{site}_15min.csv"))
  
  if (!file.exists(input_path)) {
    warning(glue("File not found for site: {site}. Skipping..."))
    next
  }
  
  df_1min <- readRDS(input_path)
  
  df_15min <- df_1min %>% 
    slice(seq(1, n(), by = 15))
  
  # OPTIONAL: Add a column tracking which site this data belongs to
  df_15min <- df_15min %>% 
    mutate(site_name = site)
  
  # Save the individual files
  saveRDS(df_15min, file = rds_output_path)
  write.csv(df_15min, file = csv_output_path, row.names = FALSE)
  
  # 3. Store the dataframe in our list using the site name as the list key
  output_list[[site]] <- df_15min
  
}

# 4. Efficiently bind all pieces together into one master dataframe
combined_df <- bind_rows(output_list)

NEON_Q_15=readRDS(here::here("data/discharge/NEON_Q_15min.rds"))

full_df<-bind_rows(combined_df, NEON_Q_15)

site_dfs_list <- full_df %>% 
  group_split(siteID)


ARIK_15min<-site_dfs_list[[1]]
BIGC_15min<-site_dfs_list[[2]]


saveRDS(ARIK_15min, file = "data/discharge/ARIK_15min_Q_Combo.rds")
