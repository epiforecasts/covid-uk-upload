sftp_config <- list(
  folder = "", 
  server = "", 
  username = "", 
  password = ""
)

suppressWarnings(dir.create(here::here("config")))
saveRDS(sftp_config, here::here("config", "sftp.rds"))
