# Collation and upload of epidemiological estimates of COVID-19 in the UK

This repository contains scripts for weekly collation and upload of epidemiological estimates of COVID-19 generated by the [Epiforecasts](https://epiforecasts.io) team.

## Configuration

The scripts look for the following files:
- `config/sftp_host`: protocol, username and host of a host to which to make SFTP uploads
- `config/sftp_dir`: remote directory for uploads
- `config/pass.gpg`: GPG-encrypted SFTP password file
