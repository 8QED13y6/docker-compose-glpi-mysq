#!/bin/bash


source secrets.env

sql_final_file="sql/initdb.sql"

# Lisez le fichier SQL d'origine et remplacez les variables par les valeurs définies
sed -e "s|\${glpi_database_name}|${glpi_database_name}|g" \
    -e "s|\${glpi_database_user}|${glpi_database_user}|g" \
    -e "s|\${glpi_database_password}|${glpi_database_password}|g" \
    sql/initdb.sql.template > "$sql_final_file"

if [ ! -f ssl/ssl.crt ] || [ ! -f ssl/ssl.key ]; then
    echo "Les fichiers ssl.crt et ssl.key sont manquants dans le dossier ssl/. Génération d'un certificat auto-signé..."
    mkdir -p ssl
    openssl req -x509 -nodes -days 3650 -newkey rsa:4096 -keyout ssl/ssl.key -out ssl/ssl.crt -subj "/C=FR/ST=France/L=Paris/O=entreprise/CN=localhost" 
fi

docker-compose build && docker-compose up -d
