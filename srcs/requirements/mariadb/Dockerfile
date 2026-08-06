# base image
FROM debian:bookworm

RUN apt update && \
    apt install -y mariadb-server

RUN rm -rf /var/lib/mysql/*

# prepare directories for the container
RUN mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld

# bring setup to the container
COPY tools/setup.sh /setup.sh
RUN chmod +x /setup.sh

EXPOSE 3306

ENTRYPOINT ["/setup.sh"]
