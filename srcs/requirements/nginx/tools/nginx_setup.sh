#!/bin/bash

set -euo pipefail

: "${DOMAIN_NAME:?DOMAIN_NAME is not set}"

mkdir -p /etc/nginx/ssl

if [ ! -f /etc/nginx/ssl/inception.crt ] || [ ! -f /etc/nginx/ssl/inception.key ]; then
    echo "[Nginx] Generating self-signed TLS certificate for ${DOMAIN_NAME}..."
    openssl req -x509 -nodes -days 365 \
        -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/inception.key \
        -out /etc/nginx/ssl/inception.crt \
        -subj "/C=PL/O=42Warsaw/OU=Students/CN=${DOMAIN_NAME}" \
        -addext "subjectAltName=DNS:${DOMAIN_NAME}"
fi

nginx -t

echo "[Nginx] Starting NGINX in the foreground..."
exec nginx -g "daemon off;"