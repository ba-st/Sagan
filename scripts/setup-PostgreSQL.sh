#!/usr/bin/env bash

readonly DOCKER_IMAGE_VERSION=$(echo "$RDBMS" | cut --complement -c -11)
docker run -d -p 127.0.0.1:5432:5432 \
  -e POSTGRES_PASSWORD=secret \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_DB=test \
  postgres:"$DOCKER_IMAGE_VERSION" \
  -c ssl=on \
  -c ssl_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem \
  -c ssl_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
