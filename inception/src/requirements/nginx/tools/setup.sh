#!/bin/bash
set -e
# Step 1: Generate a self-signed TLS certificate, if one doesn't already exist
if [ ! -f /etc/ssl/certs/nginx-selfsigned.crt ]; then
    echo "No certificate found. Generating self-signed TLS certificate..."
    mkdir -p /etc/ssl/certs /etc/ssl/private
    openssl req -x509 -nodes -days 365 \
        -newkey rsa:2048 \
        -keyout /etc/ssl/private/nginx-selfsigned.key \
        -out /etc/ssl/certs/nginx-selfsigned.crt \
        -subj "/C=JO/ST=Balqa/L=SaltCity/O=42/CN=${DOMAIN_NAME}"
fi
# Step 2: Start NGINX in the foreground, as PID 1
echo "Starting NGINX..."
exec nginx -g "daemon off;"
