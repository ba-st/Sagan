#!/usr/bin/env bash

apt update
set -e
echo "::group::Installing SQLite3"
apt --assume-yes --no-install-recommends install sqlite3
echo "SQLite3 version:"
sqlite3 -version
ln -s /usr/lib/x86_64-linux-gnu/libsqlite3.so.0 /opt/pharo/libsqlite3.so
chown pharo:users /opt/pharo/libsqlite3.so
echo "::endgroup::"
/opt/pharo/pharo-ci "$@"
