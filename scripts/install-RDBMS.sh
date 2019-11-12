#!/usr/bin/env bash

if [[ "$RDBMS" = PostgreSQL* ]]; then
  sudo /etc/init.d/postgresql stop
  sudo apt-get remove postgresql-*
  curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
  sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
  sudo apt-get update
elif [[ "$RDBMS" = MariaDB* ]]; then
  sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
fi

if [ "$RDBMS" = "PostgreSQLv9.4" ]; then
  sudo apt-get install postgresql-9.4 postgresql-client-9.4
  sudo /etc/init.d/postgresql restart
elif [ "$RDBMS" = "PostgreSQLv9.5" ]; then
  sudo apt-get install postgresql-9.5
elif [ "$RDBMS" = "PostgreSQLv9.6" ]; then
  sudo apt-get install postgresql-9.6
elif [ "$RDBMS" = "PostgreSQLv10" ]; then
  sudo apt-get install postgresql-10
elif [ "$RDBMS" = "PostgreSQLv11" ]; then
  sudo /etc/init.d/postgresql stop
  sudo apt-get remove postgresql-client-*
  sudo apt-get install postgresql-11 postgresql-client-11
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
