# base image
FROM debian:bookworm

# -y flag for yes (do u want to continue )
# install nginx and openssl
RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx \
    openssl

# get the config gile here 
COPY conf/nginx.conf /etc/nginx/nginx.conf

# be able to run setup.sh from anywhere in teh filesystem
# not just this directory 
COPY tools/setup.sh /setup.sh

# make it executable
RUN chmod +x /setup.sh

# documentation for port exposure
# port for https
EXPOSE 443

# srart this program when the container launches
ENTRYPOINT ["/setup.sh"]
