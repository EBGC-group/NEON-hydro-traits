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


saveRDS(ARIK_15min, file = "data/discharge/ARIK_15min_Q_Combo")

setwd("~/NEON-hydro-traits/data/discharge")

neon_15min <- readRDS("NEON_Q_15min.rds") |> 
  select(siteID, endDateTime, stageContinuous, dischargeContinuous, dischargeFinalQF) |> 
  rename(endDate = endDateTime, stage = stageContinuous, discharge = dischargeContinuous, dischargeFinal = dischargeFinalQF)

neon_ARIK_15min <- readRDS("NEON_Q_ARIK_15min.rds") |> 
  select(siteID, endDate, equivalentStage, maxpostDischarge, dischargeFinalQF) |> 
  rename(stage = equivalentStage, discharge = maxpostDischarge, dischargeFinal = dischargeFinalQF)
neon_BIGC_15min <- readRDS("NEON_Q_BIGC_15min.rds") |> 
  select(siteID, endDate, equivalentStage, maxpostDischarge, dischargeFinalQF) |> 
  rename(stage = equivalentStage, discharge = maxpostDischarge, dischargeFinal = dischargeFinalQF)
neon_BLDE_15min <- readRDS("NEON_Q_BLDE_15min.rds") |> 
  select(siteID, endDate, equivalentStage, maxpostDischarge, dischargeFinalQF) |> 
  rename(stage = equivalentStage, discharge = maxpostDischarge, dischargeFinal = dischargeFinalQF)
neon_BLUE_15min <- readRDS("NEON_Q_BLUE_15min.rds") |> 
  select(siteID, endDate, equivalentStage, maxpostDischarge, dischargeFinalQF) |> 
  rename(stage = equivalentStage, discharge = maxpostDischarge, dischargeFinal = dischargeFinalQF)
neon_CARI_15min <- readRDS("NEON_Q_CARI_15min.rds") |> 
  select(siteID, endDate, equivalentStage, maxpostDischarge, dischargeFinalQF) |> 
  rename(stage = equivalentStage, discharge = maxpostDischarge, dischargeFinal = dischargeFinalQF)
neon_COMO_15min <- readRDS("NEON_Q_COMO_15min.rds") |> 
  select(siteID, endDate, equivalentStage, maxpostDischarge, dischargeFinalQF) |> 
  rename(stage = equivalentStage, discharge = maxpostDischarge, dischargeFinal = dischargeFinalQF)
neon_CUPE_15min <- readRDS("NEON_Q_CUPE_15min.rds") |> 
  select(siteID, endDate, equivalentStage, maxpostDischarge, dischargeFinalQF) |> 
  rename(stage = equivalentStage, discharge = maxpostDischarge, dischargeFinal = dischargeFinalQF)
neon_GUIL_15min <- readRDS("NEON_Q_GUIL_15min.rds") |> 
  select(siteID, endDate, equivalentStage, maxpostDischarge, dischargeFinalQF) |> 
  rename(stage = equivalentStage, discharge = maxpostDischarge, dischargeFinal = dischargeFinalQF)
neon_HOPB_15min <- readRDS("NEON_Q_HOPB_15min.rds") |> 
  select(siteID, endDate, equivalentStage, maxpostDischarge, dischargeFinalQF) |> 
  rename(stage = equivalentStage, discharge = maxpostDischarge, dischargeFinal = dischargeFinalQF)
neon_KING_15min <- readRDS("NEON_Q_KING_15min.rds") |> 
  select(siteID, endDate, equivalentStage, maxpostDischarge, dischargeFinalQF) |> 
  rename(stage = equivalentStage, discharge = maxpostDischarge, dischargeFinal = dischargeFinalQF)
neon_LECO_15min <- readRDS("NEON_Q_LECO_15min.rds") |> 
  select(siteID, endDate, equivalentStage, maxpostDischarge, dischargeFinalQF) |> 
  rename(stage = equivalentStage, discharge = maxpostDischarge, dischargeFinal = dischargeFinalQF)
neon_LEWI_15min <- readRDS("NEON_Q_LEWI_15min.rds") |> 
  select(siteID, endDate, equivalentStage, maxpostDischarge, dischargeFinalQF) |> 
  rename(stage = equivalentStage, discharge = maxpostDischarge, dischargeFinal = dischargeFinalQF)
neon_MART_15min <- readRDS("NEON_Q_MART_15min.rds") |> 
  select(siteID, endDate, equivalentStage, maxpostDischarge, dischargeFinalQF) |> 
  rename(stage = equivalentStage, discharge = maxpostDischarge, dischargeFinal = dischargeFinalQF)
neon_MAYF_15min <- readRDS("NEON_Q_MAYF_15min.rds") |> 
  select(siteID, endDate, equivalentStage, maxpostDischarge, dischargeFinalQF) |> 
  rename(stage = equivalentStage, discharge = maxpostDischarge, dischargeFinal = dischargeFinalQF)
neon_MCDI_15min <- readRDS("NEON_Q_MCDI_15min.rds") |> 
  select(siteID, endDate, equivalentStage, maxpostDischarge, dischargeFinalQF) |> 
  rename(stage = equivalentStage, discharge = maxpostDischarge, dischargeFinal = dischargeFinalQF)
neon_MCRA_15min <- readRDS("NEON_Q_MCRA_15min.rds") |> 
  select(siteID, endDate, equivalentStage, maxpostDischarge, dischargeFinalQF) |> 
  rename(stage = equivalentStage, discharge = maxpostDischarge, dischargeFinal = dischargeFinalQF)
neon_OKSR_15min <- readRDS("NEON_Q_OKSR_15min.rds") |> 
  select(siteID, endDate, equivalentStage, maxpostDischarge, dischargeFinalQF) |> 
  rename(stage = equivalentStage, discharge = maxpostDischarge, dischargeFinal = dischargeFinalQF)
neon_POSE_15min <- readRDS("NEON_Q_POSE_15min.rds") |> 
  select(siteID, endDate, equivalentStage, maxpostDischarge, dischargeFinalQF) |> 
  rename(stage = equivalentStage, discharge = maxpostDischarge, dischargeFinal = dischargeFinalQF)
neon_PRIN_15min <- readRDS("NEON_Q_PRIN_15min.rds") |> 
  select(siteID, endDate, equivalentStage, maxpostDischarge, dischargeFinalQF) |> 
  rename(stage = equivalentStage, discharge = maxpostDischarge, dischargeFinal = dischargeFinalQF)
neon_REDB_15min <- readRDS("NEON_Q_REDB_15min.rds") |> 
  select(siteID, endDate, equivalentStage, maxpostDischarge, dischargeFinalQF) |> 
  rename(stage = equivalentStage, discharge = maxpostDischarge, dischargeFinal = dischargeFinalQF)
neon_SYCA_15min <- readRDS("NEON_Q_SYCA_15min.rds") |> 
  select(siteID, endDate, equivalentStage, maxpostDischarge, dischargeFinalQF) |> 
  rename(stage = equivalentStage, discharge = maxpostDischarge, dischargeFinal = dischargeFinalQF)
neon_TECR_15min <- readRDS("NEON_Q_TECR_15min.rds") |> 
  select(siteID, endDate, equivalentStage, maxpostDischarge, dischargeFinalQF) |> 
  rename(stage = equivalentStage, discharge = maxpostDischarge, dischargeFinal = dischargeFinalQF)
neon_WALK_15min <- readRDS("NEON_Q_WALK_15min.rds") |> 
  select(siteID, endDate, equivalentStage, maxpostDischarge, dischargeFinalQF) |> 
  rename(stage = equivalentStage, discharge = maxpostDischarge, dischargeFinal = dischargeFinalQF)
neon_WLOU_15min <- readRDS("NEON_Q_WLOU_15min.rds") |> 
  select(siteID, endDate, equivalentStage, maxpostDischarge, dischargeFinalQF) |> 
  rename(stage = equivalentStage, discharge = maxpostDischarge, dischargeFinal = dischargeFinalQF)

neon_full_15min <- rbind(neon_15min, neon_ARIK_15min, neon_BIGC_15min, neon_BLDE_15min, neon_BLUE_15min, neon_CARI_15min, neon_COMO_15min, neon_CUPE_15min, neon_GUIL_15min, neon_HOPB_15min, neon_KING_15min, neon_LECO_15min, neon_LEWI_15min, neon_MART_15min, neon_MAYF_15min, neon_MCDI_15min, neon_MCRA_15min, neon_OKSR_15min, neon_POSE_15min, neon_PRIN_15min, neon_REDB_15min, neon_SYCA_15min, neon_TECR_15min, neon_WALK_15min, neon_WLOU_15min)
saveRDS(neon_full_15min, file = "NEON_full_15min.rds")
