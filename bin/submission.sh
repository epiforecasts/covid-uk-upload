#!/bin/bash

## change to parent directory of directory in which this script is
cd "$(dirname "$0")/..";

latest_date="$(date "+%Y-%m-%d")"

mtp_dir="format-forecast/data/all"
mtp_filename="$latest_date-lshtm-forecast.csv"

r_dir="format-rt/data/time-series"
r_filename="$latest_date-time-series-r-lshtm.csv"

cis_dir="format-rt/data/cis"
cis_filename="$latest_date-time-series-ons-cis-lshtm.csv"

[ ! -d "remote" ] && mkdir remote
[ ! -d "remote/submit" ] && mkdir remote/submit
[ ! -d "remote/submitted" ] && mkdir remote/submitted

wget https://raw.githubusercontent.com/epiforecasts/covid19-uk-nowcasts-projections/main/$mtp_dir/$mtp_filename -O remote/submit/$mtp_filename
wget https://raw.githubusercontent.com/epiforecasts/covid19-uk-nowcasts-projections/main/$r_dir/$r_filename -O remote/submit/$r_filename

## MTP exclusions
Rscript R/mtp_exclusions.r remote/submit/$mtp_filename

Rscript R/get_ons_estimates.R

export LFTP_PASSWORD=$(gpg --quiet --decrypt config/pass.gpg)
export SFTP_HOST=$(echo $(cat config/sftp_host))
export SFTP_DIR=$(echo $(cat config/sftp_dir)) 
lftp --env-password $SFTP_HOST -e "cd $SFTP_DIR; put $(echo $(ls remote/submit/*)); bye"
export LFTP_PASSWORD=""
export SFTP_HOST=""
export SFTP_DIR=""

mv remote/submit/* remote/submitted
