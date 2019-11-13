#!/usr/bin/env bash

if  [[ "$RDBMS" = MariaDB* ]]; then
  readonly DOCKER_IMAGE_VERSION=$(echo $RDBMS | cut --complement -c -8)
  docker run -d -p 127.0.0.1:3306:3306 \
    -e MYSQL_ROOT_PASSWORD=secret \
    -e MYSQL_DATABASE=test \
    mariadb/server:$DOCKER_IMAGE_VERSION
elif  [[ "$RDBMS" = MySQL* ]]; then
    readonly DOCKER_IMAGE_VERSION=$(echo $RDBMS | cut --complement -c -6)
    docker run -d -p 127.0.0.1:3306:3306 \
      -e MYSQL_ROOT_PASSWORD=secret \
      -e MYSQL_DATABASE=test \
      mysql/mysql-server:$DOCKER_IMAGE_VERSION
elif  [[ "$RDBMS" = PostgreSQL* ]]; then
  readonly DOCKER_IMAGE_VERSION=$(echo $RDBMS | cut --complement -c -11)
  docker run -d -p 127.0.0.1:5432:5432 \
    -e POSTGRES_PASSWORD=secret \
    -e POSTGRES_USER=postgres \
    -e POSTGRES_DB=test \
    postgres:$DOCKER_IMAGE_VERSION
elif [ "$RDBMS" = "SQLite3" ]; then
  sudo apt-get install sqlite3
  sqlite3 -version
fi;
