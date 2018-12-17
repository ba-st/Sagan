#!/usr/bin/env bash

sudo /etc/init.d/postgresql stop
curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
sudo apt-get update
if [ "$RDBMS" = "PostgreSQLv9.3" ]; then
  sudo apt-get install postgresql-9.3
elif [ "$RDBMS" = "PostgreSQLv9.4" ]; then
  sudo apt-get install postgresql-9.4
elif [ "$RDBMS" = "PostgreSQLv9.5" ]; then
  sudo apt-get install postgresql-9.5
elif [ "$RDBMS" = "PostgreSQLv9.6" ]; then
  sudo apt-get install postgresql-9.6
elif [ "$RDBMS" = "PostgreSQLv10" ]; then
  sudo apt-get install postgresql-10
elif [ "$RDBMS" = "PostgreSQLv11" ]; then
  sudo apt-get install postgresql-11
else
  echo "Unsupported RDBMS"
  exit 1
fi;
