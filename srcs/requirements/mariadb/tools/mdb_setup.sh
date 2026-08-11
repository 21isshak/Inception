#!/bin/bash

set -euo pipefail

DATADIR="/var/lib/mysql"
SOCKET="/var/run/mysqld/mysqld.sock"

: "${MYSQL_DATABASE:?MYSQL_DATABASE is not set}"
: "${MYSQL_USER:?MYSQL_USER is not set}"
: "${MYSQL_ROOT_PASSWORD_FILE:?MYSQL_ROOT_PASSWORD_FILE is not set}"
: "${MYSQL_PASSWORD_FILE:?MYSQL_PASSWORD_FILE is not set}"

MYSQL_ROOT_PASSWORD="$(cat "$MYSQL_ROOT_PASSWORD_FILE")"
MYSQL_PASSWORD="$(cat "$MYSQL_PASSWORD_FILE")"

if [ -z "$(ls -A "$DATADIR/$MYSQL_DATABASE" 2>/dev/null)" ]; then
    echo "[MariaDB] No existing database found, bootstrapping..."

    mariadb-install-db --user=mysql --datadir="$DATADIR" --skip-test-db \
    --auth-root-authentication-method=normal > /dev/null

    echo "[MariaDB] Initializing database..."
    mariadbd --user=mysql --datadir="$DATADIR" --skip-networking --socket="$SOCKET" &
    TMP_PID=$!

    for n in $(seq 1 30); do
        if mysqladmin --socket="$SOCKET" ping >/dev/null 2>&1; then
            break;
        fi
        if [ "$n" -eq 30 ]; then
            echo "[MariaDB] Database initialization failed, aborting." >&2
            exit 1
        fi
        sleep 1
    done

    mysql --socket="$SOCKET" -u root <<-SQL
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
        CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE}
            CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
        CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
        GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
        FLUSH PRIVILEGES;
SQL

    mysqladmin --socket="$SOCKET" -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
    wait "$TMP_PID" 2>/dev/null || true

    echo "[MariaDB] Bootstrap completed."
fi
    
echo "[MariaDB] Starting service in the foreground..."
exec mariadbd --user=mysql --datadir="$DATADIR"