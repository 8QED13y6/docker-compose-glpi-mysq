#!/bin/bash

if [ ! -f "/var/www/html/glpi/config/config_db.php" ]; then
    apt-get update && apt-get install -y wget tar nginx php7.4 php7.4-fpm php7.4-mysql php7.4-xml php7.4-mbstring php7.4-curl php7.4-intl php7.4-gd

    wget https://github.com/glpi-project/glpi/releases/download/10.0.9/glpi-10.0.9.tgz
    tar -xvf glpi-10.0.9.tgz -C /var/www/html

    chown -R www-data:www-data /var/www/html/glpi

    ln -s /etc/nginx/sites-available/glpi.conf /etc/nginx/sites-enabled/glpi.conf
    rm /etc/nginx/sites-enabled/default
    echo 'daemon off;' >> /etc/nginx/nginx.conf

    # Install GLPI using the console tool
    php /var/www/html/glpi/bin/console glpi:database:install \
        --config-dir="/var/www/html/glpi/config" \
        --db-host="${MYSQL_HOST}" \
        --db-user="${glpi_database_user}" \
        --db-password="${glpi_database_password}" \
        --db-name="${glpi_database_name}" \
        --default-language="fr_FR" \
        --no-interaction
fi

service php7.4-fpm start
nginx
