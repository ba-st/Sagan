#!/usr/bin/env bash

if [[ "$RDBMS" = PostgreSQLv9* ]]; then
  psql -c "ALTER USER postgres PASSWORD 'secret'" -U postgres;
  psql -c "CREATE DATABASE test" -U postgres;
elif [  "$RDBMS" = "PostgreSQLv10"  -o  "$RDBMS" = "PostgreSQLv11" ]; then
  psql --port 5433 -c "ALTER USER postgres PASSWORD 'secret'" -U postgres;
  psql --port 5433 -c "CREATE DATABASE test" -U postgres;
fi;
