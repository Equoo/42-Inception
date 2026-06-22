#!/bin/sh
set -eo pipefail

log() { echo "[entrypoint] $*"; }
die() { echo "[entrypoint] ERROR: $*" >&2; exit 1; }

configure() {
	sed -i "s/{hostname}/$DOMAIN_NAME/g" /etc/nginx/http.d/default.conf
}

main() {
	configure

    log "Starting NGINX..."
    exec "$@"
}

main "$@"
