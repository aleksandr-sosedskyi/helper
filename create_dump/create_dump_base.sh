#!/bin/bash

# Set environment variables
if [ $1 = 'prod' ]; then 
    export $(cat ./environment/prod.env | xargs)
elif [ $1 = 'stage' ]; then
    export $(cat ./environment/stage.env | xargs)
else
    exit 0
fi

formated_date=$(date +"%d%m")
local_db_name=$prefix$formated_date
local_db_user=$prefix$formated_date
file_name="$prefix$formated_date.sql"

# Downloading dump to local
sudo usermod -aG $USER postgres
ssh $ssh_host "sudo -u postgres pg_dump --dbname=postgresql://$server_db_user:$server_db_password@192.168.0.231:8635/$server_db_name" > /home/$USER/$file_name

# Create local database and user
sudo -u postgres psql -c "CREATE DATABASE $local_db_name;"
sudo -u postgres psql -c "CREATE USER $local_db_user WITH PASSWORD '$local_db_password';"
sudo -u postgres psql -c "GRANT ALL ON DATABASE $local_db_name TO $local_db_user;"
sudo -u postgres psql -c "ALTER ROLE $local_db_user WITH LOGIN;"
sudo -u postgres psql -c "ALTER ROLE $local_db_user WITH SUPERUSER;"

# Load dump to new database
sudo -u postgres psql --dbname=postgresql://$local_db_user:$local_db_password@localhost:5432/$local_db_name -f /home/$USER/$file_name
