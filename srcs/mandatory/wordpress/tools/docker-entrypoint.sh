#!/bin/sh
set -eo pipefail

log() { echo "[entrypoint] $*"; }
die() { echo "[entrypoint] ERROR: $*" >&2; exit 1; }

WP="wp --allow-root --path=/var/www/wordpress"

is_fresh_install() {
    [ ! -f "./wordpress/wp-config.php" ]
}

download() {
    $WP core download --version=latest
}

download_plugins() {
    $WP plugin install https://downloads.wordpress.org/plugin/wp-redis.1.4.7.zip --activate
	$WP plugin install https://downloads.wordpress.org/plugin/wp-statistics.14.16.8.zip --activate

    rm -f ./wordpress/wp-content/object-cache.php
    ln -s plugins/wp-redis/object-cache.php ./wordpress/wp-content/object-cache.php
}

configure() {
    cd wordpress

    set +e
    OLD_URL=$($($WP config get WP_HOME | true) | sed -e "s/https:\/\///")
    set -e

    $WP config create \
        --dbname="$MYSQL_DB" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$(cat /run/secrets/mysql_password)" \
        --dbhost="mariadb" \
        --skip-check \
        --force

    $WP config set WP_SITEURL "https://$DOMAIN_NAME"
    $WP config set WP_HOME "https://$DOMAIN_NAME"

    $WP search-replace "$OLD_URL" "$DOMAIN_NAME" --all-tables --precise

    $WP config set redis_server \
        "array('host' => 'redis', 'port' => 6379, 'database' => 0)" \
        --raw --type=variable

    if ! $WP core is-installed; then
        log "Running WordPress install..."
        $WP core install \
            --url="https://$DOMAIN_NAME" \
            --title="$WP_TITLE" \
            --admin_user="$WP_ADMIN_USER" \
            --admin_password="$(cat /run/secrets/wp_admin_password)" \
            --admin_email="$WP_ADMIN_EMAIL" \
            --skip-email

        $WP user create "$WP_USER" "$WP_USER_EMAIL" \
            --role=author \
            --user_pass="$(cat /run/secrets/wp_user_password)"
    fi

    wp cache flush
    wp rewrite flush

    cd ..
}

main() {
    if is_fresh_install; then
        download
    	configure
        download_plugins
        log "Initialisation complete."
    else
    	configure
        log "Existing data directory found — skipping init."
    fi

    log "Starting Wordpress..."
    exec "$@"
}

main "$@"
