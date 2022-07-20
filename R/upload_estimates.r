suppressMessages(suppressPackageStartupMessages(library("sftp")))
suppressPackageStartupMessages(library("here"))
suppressPackageStartupMessages(library("purrr"))

sftp_config <- readRDS(here::here("config", "sftp.rds"))

sftp_con <-
  sftp_connect(server = sftp_config$server,
               folder = sftp_config$folder,
               username = sftp_config$username,
               password = sftp_config$password)

sftp_changedir("remote")
sftp_changedir("submit")

validate_files <- list.files(here::here("remote", "submit"))

if (length(validate_files) == 0) stop("No files to upload")

map(validate_files,
    sftp_upload,
    fromfolder = file.path("remote", "submit"),
    sftp_connection = sftp_con)


