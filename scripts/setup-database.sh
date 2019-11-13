#!/usr/bin/env bash

if [ "$RDBMS" = "SQLite3" ];then
  sqlite3 -version
fi;
