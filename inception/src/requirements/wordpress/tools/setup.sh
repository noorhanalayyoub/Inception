#!/bin/bash
set -e #exit script immediately if any command fails


# get the value
MYSQL_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)
# no need to give mariadb time

echo "mariadb is ready..."


# check if wrodpress is alrd installed 
if [ ! -f /var/www/html/wp-config.php ]; then

    echo "WordPress not found. Downloading and configuring..."

    # Download WordPress core
    curl -s -o /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz
    tar -xzf /tmp/wordpress.tar.gz -C /tmp
    cp -r /tmp/wordpress/. /var/www/html/
    rm -rf /tmp/wordpress /tmp/wordpress.tar.gz

    # Step 3: Generate wp-config.php from the sample, using env vars
    cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

    sed -i "s/database_name_here/${MYSQL_DATABASE}/" /var/www/html/wp-config.php
    sed -i "s/username_here/${MYSQL_USER}/" /var/www/html/wp-config.php
    sed -i "s/password_here/${MYSQL_PASSWORD}/" /var/www/html/wp-config.php
    sed -i "s/localhost/mariadb/" /var/www/html/wp-config.php

    # Step 4: Set correct ownership so php-fpm (running as www-data) can read/write
    chown -R www-data:www-data /var/www/html

    # Step 5: Use WP-CLI to install WordPress non-interactively
    su -s /bin/bash www-data -c "wp core install \
        --path=/var/www/html \
        --url=${DOMAIN_NAME} \
        --title=\"Inception\" \
        --admin_user=${WP_ADMIN_USER} \
        --admin_password=${WP_ADMIN_PASSWORD} \
        --admin_email=${WP_ADMIN_EMAIL} \
        --skip-email"

    su -s /bin/bash www-data -c "wp user create ${WP_USER} ${WP_USER_EMAIL} \
        --user_pass=${WP_USER_PASSWORD} \
        --role=author \
        --path=/var/www/html"

fi
# Step 6: Start php-fpm in the foreground, as PID 1
echo "Starting PHP-FPM..."
exec php-fpm8.2 -F
