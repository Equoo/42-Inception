#!/bin/sh
set -eo pipefail

# Helpers
log() { echo "[entrypoint] $*"; }
die() { echo "[entrypoint] ERROR: $*" >&2; exit 1; }


is_fresh_install() {
    [ ! -d "/var/lib/mysql/mysql" ]
}

init_database() {
    log "Initialising MariaDB data directory..."
    mariadb-install-db \
        --user=mysql \
        --datadir=/var/lib/mysql \
        --skip-test-db \
        > /dev/null
    log "Data directory initialised."
}

start_temp_server() {
    log "Starting temporary server for setup..."
    mariadbd \
        --user=mysql \
        --skip-networking \
        --socket=/run/mysqld/mysqld.sock \
        --pid-file=/run/mysqld/mysqld-temp.pid \
        &
    TEMP_PID=$!

    # Wait until the socket is ready
    local tries=30
    while [ $tries -gt 0 ]; do
        if mariadb-admin \
            --socket=/run/mysqld/mysqld.sock \
            --user=root ping \
            2>/dev/null; then
            break
        fi
        tries=$((tries - 1))
        sleep 1
    done

    [ $tries -eq 0 ] && die "Temporary server failed to start."
    log "Temporary server ready."
}

stop_temp_server() {
    log "Stopping temporary server..."
    mariadb-admin --socket=/run/mysqld/mysqld.sock --user=root --password="$(cat /run/secrets/mysql_root_password)" shutdown
    wait "$TEMP_PID"
}

configure_server() {
	MYSQL_ROOT_PASSWORD=$(cat "/run/secrets/mysql_root_password")

    log "Configuring root user..."
    mariadb --socket=/run/mysqld/mysqld.sock --user=root <<-EOSQL
		ALTER USER 'root'@'localhost' IDENTIFIED BY '$(cat /run/secrets/mysql_root_password)';
        DELETE FROM mysql.global_priv WHERE User='';
        DELETE FROM mysql.global_priv WHERE User='root' AND Host NOT IN ('localhost','127.0.0.1','::1');
        DROP DATABASE IF EXISTS test;
        FLUSH PRIVILEGES;
EOSQL

    # Optional: create a database + user
    if [ -n "$MYSQL_DB" ]; then
        log "Creating database '$MYSQL_DB'..."
        mariadb --socket=/run/mysqld/mysqld.sock \
              --user=root \
              --password="$(cat /run/secrets/mysql_root_password)" \
              -e "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DB\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    fi

    if [ -n "$MYSQL_USER" ] && [ -n "$MYSQL_DB" ]; then
        MYSQL_PASSWORD=$(cat "/run/secrets/mysql_password")

        log "Creating user '$MYSQL_USER'..."
        mariadb --socket=/run/mysqld/mysqld.sock \
              --user=root \
              --password="$(cat /run/secrets/mysql_root_password)" \
			  -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$(cat /run/secrets/mysql_password)';
		GRANT ALL PRIVILEGES ON \`$MYSQL_DB\`.* TO '$MYSQL_USER'@'%';
                  FLUSH PRIVILEGES;"
    fi
}

run_init_scripts() {
    local dir="/docker-entrypoint-initdb.d"
    [ -d "$dir" ] || return 0

    for f in "$dir"/*.sql "$dir"/*.sh; do
        [ -f "$f" ] || continue
        case "$f" in
            *.sql)
                log "Executing SQL: $f"
                mariadb --socket=/run/mysqld/mysqld.sock \
                      --user=root \
                      --password="$(cat /run/secrets/mysql_root_password)" \
                      ${MYSQL_DB:+--database="$MYSQL_DB"} \
                      < "$f"
                ;;
            *.sh)
                log "Executing shell script: $f"
                sh "$f"
                ;;
        esac
    done
}

main() {
    if is_fresh_install; then
        init_database
        start_temp_server
        configure_server
        run_init_scripts
        stop_temp_server
        log "Initialisation complete."
    else
        log "Existing data directory found — skipping init."
    fi

    log "Starting MariaDB..."
    exec "$@"
}

main "$@"
