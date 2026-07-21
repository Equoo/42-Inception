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

main() {
    if is_fresh_install; then
		init_database
        log "Initialisation complete."
    else
        log "Existing data directory found — skipping init."
    fi


	export MYSQL_ROOT_PASSWORD=$(cat /run/secrets/mysql_root_password)
	export MYSQL_PASSWORD=$(cat /run/secrets/mysql_password)

	cat /var/lib/mysql/init.sql.template | envsubst > /var/lib/mysql/init.sql

	unset MYSQL_ROOT_PASSWORD MYSQL_PASSWORD

    log "Starting MariaDB..."
    exec "$@"
}

main "$@"
