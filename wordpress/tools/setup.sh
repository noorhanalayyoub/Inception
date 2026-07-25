#!/bin/bash

#exit immediately if any command fails 
set -e

echo "starting wordpress container"

# checking if wp is installed


if [ ! -f /var/www/html/wp-config.php ]; then
    mkdir -p /var/www/html
    curl -s -o /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz
    tar -xzf /tmp/wordpress.tar.gz -C /tmp
    cp -r /tmp/wordpress/. /var/www/html/
    rm -rf /tmp/wordpress /tmp/wordpress.tar.gz

    # get the sample file into wp config
    cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
    

    # edit on this wp config, replace these with variable names
    sed -i "s/database_name_here/${MYSQL_DATABASE}/" /var/www/html/wp-config.php
    sed -i "s/username_here/${MYSQL_USER}/" /var/www/html/wp-config.php
    sed -i "s/password_here/${MYSQL_PASSWORD}/" /var/www/html/wp-config.php
    sed -i "s/localhost/mariadb/" /var/www/html/wp-config.php

    # fix ownership so phpfpm can move freely
    chown -R www-data:www-data /var/www/html

    su -s /bin/bash www-data -c "wp core install \
        --path=/var/www/html \
        --url=${DOMAIN_NAME} \
        --title=\"Inception\" \
        --admin_user=${WP_ADMIN_USER} \
        --admin_password=${WP_ADMIN_PASSWORD} \
        --admin_email=${WP_ADMIN_EMAIL} \
        --skip-email"
	
    # users are created in web server default directory /var/www/html
    su -s /bin/bash www-data -c "wp user create ${WP_USER} ${WP_USER_EMAIL} \
        --user_pass=${WP_USER_PASSWORD} \
        --role=author \
        --path=/var/www/html"
fi

echo "Starting PHP-FPM..."
exec php-fpm8.2 -F
