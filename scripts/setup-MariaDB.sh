#!/usr/bin/env bash

DOCKER_IMAGE_VERSION=$(echo "$RDBMS" | cut --complement -c -8)
readonly DOCKER_IMAGE_VERSION
docker run -d -p 127.0.0.1:3306:3306 \
    -e MYSQL_ROOT_PASSWORD=secret \
    -e MYSQL_DATABASE=test \
    mariadb/server:"$DOCKER_IMAGE_VERSION"
