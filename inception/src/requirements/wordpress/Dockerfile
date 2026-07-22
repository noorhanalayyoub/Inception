FROM debian:bookworm

RUN apt update && apt install -y php-fpm php-mysqli php-gd curl

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

RUN sed -i 's|^listen = .*|listen = 9000|' /etc/php/8.2/fpm/pool.d/www.conf

COPY tools/setup.sh /

RUN chmod +x /setup.sh

EXPOSE 9000

ENTRYPOINT ["/setup.sh"]
