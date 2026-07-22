FROM debian:bookworm

RUN apt update && apt install -y nginx openssl

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY tools/setup.sh /usr/local/bin/setup.sh

RUN chmod +x /usr/local/bin/setup.sh

EXPOSE 443

ENTRYPOINT ["/usr/local/bin/setup.sh"]
