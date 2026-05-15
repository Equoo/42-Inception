#!/bin/sh
set -eo pipefail

# Helpers
log() { echo "[entrypoint] $*"; }
die() { echo "[entrypoint] ERROR: $*" >&2; exit 1; }


is_fresh_install() {
    [ ! -f "./wp-config.php" ]
}

download() {
	wget https://wordpress.org/wordpress-latest.tar.gz &> /dev/null
	tar -xzvf wordpress-latest.tar.gz &> /dev/null
	rm wordpress-latest.tar.gz &> /dev/null

	mv wordpress/* .
	rm -Rf wordpress/
}

configure() {
	cp wp-config-sample.php wp-config.php
	sed -i "s/username_here/$MYSQL_USER/g" wp-config.php
	sed -i "s/password_here/$(cat /run/secrets/mysql_password)/g" wp-config.php
	sed -i "s/localhost/mariadb/g" wp-config.php
	sed -i "s/database_name_here/$MYSQL_DB/g" wp-config.php
}

main() {
    if is_fresh_install; then
		download
        configure
        log "Initialisation complete."
    else
        log "Existing data directory found — skipping init."
    fi

    log "Starting Wordpress..."
    exec "$@"
}

main "$@"
