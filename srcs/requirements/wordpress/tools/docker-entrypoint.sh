#!/bin/sh
set -eo pipefail

log() { echo "[entrypoint] $*"; }
die() { echo "[entrypoint] ERROR: $*" >&2; exit 1; }

is_fresh_install() {
    [ ! -f "./wordpress/wp-config.php" ]
}

download() {
	wget https://wordpress.org/wordpress-latest.tar.gz &> /dev/null
	tar -xzvf wordpress-latest.tar.gz &> /dev/null
	rm wordpress-latest.tar.gz &> /dev/null

	rm ./wordpress/wp-content/object-cache.php

	ln -s ./wordpress/wp-content/plugins/wp-redis/object-cache.php ./wordpress/wp-content/object-cache.php

	wget -O ./wordpress/adminer.php https://github.com/vrana/adminer/releases/download/v5.4.2/adminer-5.4.2.php
}

configure() {
	cd wordpress
	cp ./wp-config-sample.php ./wp-config.php
	sed -i "s/username_here/$MYSQL_USER/g" ./wp-config.php
	sed -i "s/password_here/$(cat /run/secrets/mysql_password)/g" ./wp-config.php
	sed -i "s/localhost/mariadb/g" ./wp-config.php
	sed -i "s/database_name_here/$MYSQL_DB/g" ./wp-config.php

	echo "
	\$redis_server = array(
    'host'     => 'redis',
    'port'     => 6379,
    'auth'     => '', // ['user', 'password'] if you use Redis ACL
    'database' => 0, // Optionally use a specific numeric Redis database. Default is 0.
);

define( 'WP_SITEURL', 'https://$DOMAIN_NAME' );
define( 'WP_HOME', 'https://$DOMAIN_NAME' );
" >> ./wp-config.php

}

main() {
    if is_fresh_install; then
		download
        log "Initialisation complete."
    else
        log "Existing data directory found — skipping init."
    fi

	configure

    log "Starting Wordpress..."
    exec "$@"
}

main "$@"

