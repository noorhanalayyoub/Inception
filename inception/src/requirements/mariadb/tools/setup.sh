#!/bin/bash
set -e #exit script immediately if any command fails


# assign values 
MYSQL_PASSWORD=$(cat /run/secrets/db_password) #assign the value
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password) #assign the value
MYSQL_DATABASE=${MYSQL_DATABASE}
MYSQL_USER=${MYSQL_USER}
echo "THIS IS mariadb SCRIIIIIIIIIIIIPT"

# text editor to change stuff inside container
sed -i 's/^bind-address.*=.*127.0.0.1/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf


 # Step 1: Check if MariaDB has already been initialized
if [ ! -d /var/lib/mysql/mysql ]; then
    echo "No existing database found. Initializing MariaDB..."

    # initialize the data directory (system tables) 
    mysql-install-db
    echo "db was installed"

    # start mariadb in bootstrap mode
    mysqld --bootstrap <<EOF 
        CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
        CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
        GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
    DELETE FROM mysql.user WHERE User='';
        FLUSH PRIVILEGES;
EOF


fi
# Step 8: Start the real server in the foreground, as PID 1
echo "Starting MariaDB server..."
chown -R mysql:mysql /var/lib/mysql

exec mysqld --user=mysql
