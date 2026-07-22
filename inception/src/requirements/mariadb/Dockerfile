FROM alpine:3.22

RUN apk add --no-cache mariadb mariadb-client gettext

RUN mkdir -p /run/mysqld /var/lib/mysql && \
    chown -R  mysql:mysql /run/mysqld /var/lib/mysql

COPY tools/setup.sh /
COPY tools/bootstrap.sql.template /
RUN chmod +x /setup.sh

EXPOSE 3306

ENTRYPOINT ["/setup.sh"]
