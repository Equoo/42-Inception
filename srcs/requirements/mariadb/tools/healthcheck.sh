#!/bin/sh
set -e

HOST="${MYSQL_HOST:-localhost}"
PORT="${MYSQL_PORT:-3306}"
USER="${MYSQL_HEALTHCHECK_USER:-root}"
PASSWORD_FILE="${MYSQL_HEALTHCHECK_PASSWORD_FILE:-/run/secrets/mysql_root_password}"

PASSWORD=$(cat "$PASSWORD_FILE")

mariadb \
    --host="$HOST" \
    --port="$PORT" \
    --user="$USER" \
    --password="$PASSWORD" \
    --connect-timeout=3 \
    -e "SELECT 1" > /dev/null 2>&1

exit $?
