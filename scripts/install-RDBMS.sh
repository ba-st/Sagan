#!/usr/bin/env bash

if  [[ "$RDBMS" = MariaDB* ]]; then
  sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
fi

if [ "$RDBMS" = "PostgreSQLv9.4" ]; then
  docker run -d -p 127.0.0.1:5432:5432 \
    -e POSTGRES_PASSWORD=secret \
    -e POSTGRES_USER=postgres \
    -e POSTGRES_DB=test \
    postgres:9.4
elif [ "$RDBMS" = "PostgreSQLv9.5" ]; then
  docker run -d -p 127.0.0.1:5432:5432 \
    -e POSTGRES_PASSWORD=secret \
    -e POSTGRES_USER=postgres \
    -e POSTGRES_DB=test \
    postgres:9.5
elif [ "$RDBMS" = "PostgreSQLv9.6" ]; then
  docker run -d -p 127.0.0.1:5432:5432 \
    -e POSTGRES_PASSWORD=secret \
    -e POSTGRES_USER=postgres \
    -e POSTGRES_DB=test \
    postgres:9.6
elif [ "$RDBMS" = "PostgreSQLv10" ]; then
  docker run -d -p 127.0.0.1:5432:5432 \
    -e POSTGRES_PASSWORD=secret \
    -e POSTGRES_USER=postgres \
    -e POSTGRES_DB=test \
    postgres:10
elif [ "$RDBMS" = "PostgreSQLv11" ]; then
  docker run -d -p 127.0.0.1:5432:5432 \
    -e POSTGRES_PASSWORD=secret \
    -e POSTGRES_USER=postgres \
    -e POSTGRES_DB=test \
    postgres:11
elif [ "$RDBMS" = "MariaDBv10.0" ]; then
  sudo add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://nyc2.mirrors.digitalocean.com/mariadb/repo/10.0/ubuntu trusty main'
  sudo apt-get update
  sudo apt-get install mariadb-server
elif [ "$RDBMS" = "MariaDBv10.1" ]; then
  sudo add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://nyc2.mirrors.digitalocean.com/mariadb/repo/10.1/ubuntu trusty main'
  sudo apt-get update
  sudo apt-get install mariadb-server
elif [ "$RDBMS" = "MariaDBv10.2" ]; then
  sudo add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://nyc2.mirrors.digitalocean.com/mariadb/repo/10.2/ubuntu trusty main'
  sudo apt-get update
  sudo apt-get install mariadb-server
elif [ "$RDBMS" = "MariaDBv10.3" ]; then
  sudo add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://nyc2.mirrors.digitalocean.com/mariadb/repo/10.3/ubuntu trusty main'
  sudo apt-get update
  sudo apt-get install mariadb-server
elif [ "$RDBMS" = "SQLite3" ]; then
  sudo apt-get install sqlite3
fi;
