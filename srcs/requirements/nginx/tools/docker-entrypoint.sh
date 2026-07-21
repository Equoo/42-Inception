#!/bin/sh
set -eo pipefail

log() { echo "[entrypoint] $*"; }
die() { echo "[entrypoint] ERROR: $*" >&2; exit 1; }

configure() {
	sed -i "s/{hostname}/$DOMAIN_NAME/g" /etc/nginx/http.d/default.conf

	cp /run/secrets/nginx_cert /etc/ssl/certs/nginx.crt
	cp /run/secrets/nginx_key /etc/ssl/private/nginx.key
	chmod 644 /etc/ssl/certs/nginx.crt
	chmod 600 /etc/ssl/private/nginx.key
}

main() {
	configure

    log "Starting NGINX..."
    exec "$@"
}

main "$@"
