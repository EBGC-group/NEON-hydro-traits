here::i_am("code/init.R")
library(here)
library(magrittr)
library(dplyr)
library(ggplot2)
library(neonstore)
library(neonUtilities)
library(arrow)
library(aws.s3)

streamsites=c("HOPB", "LEWI", "POSE", "CUPE",
              "GUIL", "KING", "MCDI", "LECO",
              "WALK", "MAYF", "ARIK", "BLUE",
              "PRIN", "BLDE", "COMO", "WLOU",
              "SYCA", "REDB", "MART", "MCRA",
              "BIGC", "TECR", "OKSR", "CARI")
# We then set the specifications of the s3 bucket. This bucket is publicly readable:
# set the s3 bucket specs 
s3_specs = readRDS(here::here('data/repo-objs/s3_specs.rds'))

# We can view the files available on the s3 bucket using the `aws.s3` package to view the contents.
get_bucket(bucket = s3_specs$bucket,
           prefix = s3_specs$prefix)


# And we can connect to the s3 bucket to perform actions locally by connecting to the remote bucket:
s3 = arrow::s3_bucket(bucket = paste0(s3_specs$bucket,"/",s3_specs$prefix,"/"))
remote = neon_remote_db(bucket = s3)

# and then reading in a file from the remote connection.
neon_remote(
  table = "csd_15_min-basic", 
  product = "DP4.00130.001",
  db = remote
  )  %>%
  dplyr::collect() %>% 
  saveRDS(here::here('data/discharge/NEON_Q_15min.rds'))
