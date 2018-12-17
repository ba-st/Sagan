#!/usr/bin/env bash

if [[ "$RDBMS" = PostgreSQLv9* ]]; then
  psql -c "ALTER USER postgres PASSWORD 'secret'" -U postgres;
  psql -c "CREATE DATABASE test" -U postgres;
elif [  "$RDBMS" = "PostgreSQLv10"  -o  "$RDBMS" = "PostgreSQLv11" ]; then
  sudo cp /etc/postgresql/9.6/main/pg_hba.conf /etc/postgresql/10/main/pg_hba.conf
  sudo cp /etc/postgresql/9.6/main/pg_hba.conf /etc/postgresql/11/main/pg_hba.conf
  sudo /etc/init.d/postgresql restart
  psql --port 5433 -c "ALTER USER postgres PASSWORD 'secret'" -U postgres;
  psql --port 5433 -c "CREATE DATABASE test" -U postgres;
fi;
