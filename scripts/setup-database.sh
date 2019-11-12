#!/usr/bin/env bash

if [[ "$RDBMS" = "MySQLv5" || "$RDBMS" = MariaDB* ]];then
  mysql --version
  mysql -uroot -e "CREATE DATABASE IF NOT EXISTS test;"
  mysql -uroot -e "CREATE USER travis@localhost IDENTIFIED BY 'travis';"
  mysql -uroot -e "GRANT ALL PRIVILEGES ON test.* TO 'travis'@'localhost';"
  mysql -uroot -e "FLUSH PRIVILEGES;"
elif [ "$RDBMS" = "SQLite3" ];then
  sqlite3 -version
fi;
