#!/bin/bash

# Update the package list to get the latest information about available packages
sudo apt update

# Install PostgreSQL and its command-line tools
sudo apt install postgresql postgresql-contrib -y

# Start the PostgreSQL service
sudo systemctl start postgresql.service

# Create a PostgresSQL database
sudo -u postgres psql -c "CREATE DATABASE flask_db;"

# Create a PostgreSQL user and grant privileges on the database
sudo -u postgres psql -c "CREATE USER tal WITH PASSWORD 'tal';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE flask_db TO tal;"

echo "listen_addresses = '*'" | sudo tee -a /etc/postgresql/*/main/postgresql.conf
echo "host all all 10.0.1.0/24 md5" | sudo tee -a /etc/postgresql/*/main/pg_hba.conf
sudo systemctl restart postgresql.service 


