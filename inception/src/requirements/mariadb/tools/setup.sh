#!/bin/bash
# exit immediately if anything fails
set -e

MYSQL_PASSWORD=$(cat /run/secrets/db_user_password)
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

if ! [ -d /var/lib/mysql/mysql ]; then # should be changed to inception_db later
	echo "Initializing MariaDB..."

	chown -R mysql:mysql /var/lib/mysql

	mariadb-install-db \
		--user=mysql \
		--datadir=/var/lib/mysql

	mkdir -p /run/mysqld
	chown mysql:mysql /run/mysqld

	mysqld \
		--user=mysql \
		--datadir="/var/lib/mysql" \
		--skip-networking &
	
	# pid of most recently starred background process
	PID="$!"

	echo "Waiting for MariaDB to be ready..."

	MAX_RETRIES=30
	COUNT=0

	while ! mysqladmin ping --silent; do
		COUNT=$((COUNT + 1))

		if [ "$COUNT" -ge "$MAX_RETRIES" ]; then
			echo "MariaDB failed to start"
			kill "$PID"
			exit 1
		fi
	done

	echo "MariaDB is ready"

	echo "Creating database and users..."

	mysql << EOF
DROP USER IF EXISTS ''@'localhost';
DROP USER IF EXISTS ''@'${HOSTNAME}';

FLUSH PRIVILEGES;

CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};

CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';

GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';

ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

FLUSH PRIVILEGES;
EOF

	echo "Stopping temporary MariaDB..."

	mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown

	wait "$PID"
fi

echo "Starting MariaDB..."

# started a temporary server while skip netowrking
# unix socket created rather than tcp/ip socket
# no process would attempt to connect to the db 
# shut down temporary server and start real server

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

exec mysqld \
	--user=mysql \
	--datadir="/var/lib/mysql"
