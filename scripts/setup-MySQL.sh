#!/usr/bin/env bash

readonly DOCKER_IMAGE_VERSION=$(echo "$RDBMS" | cut --complement -c -6)
docker run -d -p 127.0.0.1:3306:3306 \
  -e MYSQL_ROOT_PASSWORD=secret \
  -e MYSQL_ROOT_HOST=% \
  -e MYSQL_DATABASE=test \
  mysql/mysql-server:"$DOCKER_IMAGE_VERSION"
