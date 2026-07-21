FROM debian:bookworm

RUN apt update && apt install -y mariadb-server

RUN mkdir -p /run/mysqld && \
    chown -R  mysql:mysql /run/mysqld

COPY tools/setup.sh /setup.sh
RUN chmod +x /setup.sh

EXPOSE 3306

ENTRYPOINT ["/setup.sh"]
