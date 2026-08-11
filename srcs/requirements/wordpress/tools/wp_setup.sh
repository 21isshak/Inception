#!/bin/bash

set -euo pipefail

WP_PATH="/var/www/wordpress"

: "${MYSQL_HOST:?}"; : "${MYSQL_DATABASE:?}"; : "${MYSQL_USER:?}"
: "${MYSQL_PASSWORD_FILE:?}"
: "${WP_URL:?}"; : "${WP_TITLE:?}"
: "${WP_ADMIN_USER:?}"; : "${WP_ADMIN_EMAIL:?}"; : "${WP_ADMIN_PASSWORD_FILE:?}"
: "${WP_USER:?}"; : "${WP_USER_EMAIL:?}"; : "${WP_USER_PASSWORD_FILE:?}"

DB_PASSWORD="$(cat "$MYSQL_PASSWORD_FILE")"
WP_ADMIN_PASSWORD="$(cat "$WP_ADMIN_PASSWORD_FILE")"
WP_USER_PASSWORD="$(cat "$WP_USER_PASSWORD_FILE")"

cd $WP_PATH

echo "[WordPress] Waiting for MariaDB at ${MYSQL_HOST}..."
for i in $(seq 1 30); do
    if mysqladmin -h"${MYSQL_HOST}" -u"${MYSQL_USER}" -p"${DB_PASSWORD}" ping >/dev/null 2>&1; then
        echo "[WordPress] MariaDB is up."
        break
    fi
    if [ "$i" -eq 30 ]; then
        echo "[WordPress] MariaDB is unreachable, aborting." >&2
        exit 1
    fi
    sleep 2
done

if [ ! -f wp-config.php ]; then
    echo "[WordPress] Downloading wordpress core..."
    wp core download --allow-root --locale=en_US

    wp config create --allow-root \
    --dbname="${MYSQL_DATABASE}" \
    --dbuser="${MYSQL_USER}" \
    --dbpass="${DB_PASSWORD}" \
    --dbhost="${MYSQL_HOST}" \
    --skip-check

fi

if ! wp core is-installed --allow-root 2>/dev/null; then
    echo "[WordPress] Running WordPress install..."
    wp core install --allow-root \
        --url="${WP_URL}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email

    echo "[WordPress] Creating non-admin user..."
    wp user create "${WP_USER}" "${WP_USER_EMAIL}" --allow-root \
        --role=editor \
        --user_pass="${WP_USER_PASSWORD}"

fi

chown -R www-data:www-data "$WP_PATH"
chmod -R u+rwX,g+rwX "$WP_PATH" 2>/dev/null || true

echo "[WordPress] Starting php-fpm in the foreground..."
exec /usr/sbin/php-fpm8.2 -F