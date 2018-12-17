#!/bin/env bash

psql -c "ALTER USER postgres PASSWORD 'secret'" -U postgres;
psql -c "CREATE DATABASE test" -U postgres;
