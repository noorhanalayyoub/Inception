# base image
FROM debian:bookworm

# prevent services from starting during package installation
RUN echo '#!/bin/sh\nexit 0' > /usr/sbin/policy-rc.d

RUN apt update && \
    apt install -y mariadb-server

RUN rm -rf /var/lib/mysql/*

RUN rm /usr/sbin/policy-rc.d

# prepare directories for the container
RUN mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld

# bring setup to the container
COPY tools/setup.sh /setup.sh
RUN chmod +x /setup.sh

EXPOSE 3306

ENTRYPOINT ["/setup.sh"]
