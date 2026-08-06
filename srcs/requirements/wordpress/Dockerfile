FROM debian:bookworm

# install php fpm
# install phpfpm extension to talk to mariadb
# install curl to isntall files from internet 

RUN apt update && apt install -y \
    php-fpm \
    php-mysql \
    curl

# changing php fpm from listening on unix socket to listening to port 9000
# port 9000 receives fastcgi requests
# we configure it so nginx can send requests on port 9000

RUN sed -i 's|listen = /run/php/php8.2-fpm.sock|listen = 9000|' /etc/php/8.2/fpm/pool.d/www.conf


# moving wpcli to system path so we can run its commands in terminal
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp


# move the script to the container 
# these are inside the containers filesystem 
COPY tools/setup.sh /setup.sh

# make it exectuable 
RUN chmod +x  /setup.sh

# default command to run when the container starts
ENTRYPOINT ["/setup.sh"]
