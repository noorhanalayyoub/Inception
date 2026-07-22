#!/bin/sh
set -e

echo "THIS IS mariadb SCRIIIIIIIIIIIIPT"

# Step 1: Check if MariaDB has already been initialized
if [ ! -d /var/lib/mysql/mysql ]; then
  echo "No existing database found. Initializing MariaDB..."

  # initialize the data directory (modern command)
  mariadb-install-db --user=mysql --datadir=/var/lib/mysql
  echo "db was installed"
  envsubst < /bootstrap.sql.template > /bootstrap.sql
  # start mariadb in bootstrap mode to setup users and DB
  mariadbd --user=mysql --datadir=/var/lib/mysql --bootstrap < /bootstrap.sql
  echo "Database and users configured"
fi

echo "Starting MariaDB server..."

exec mariadbd --user=mysql --datadir=/var/lib/mysql --bind-address=0.0.0.0
