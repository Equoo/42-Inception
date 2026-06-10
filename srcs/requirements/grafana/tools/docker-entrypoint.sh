#!/bin/sh
set -eo pipefail

log() { echo "[entrypoint] $*"; }
die() { echo "[entrypoint] ERROR: $*" >&2; exit 1; }

is_fresh() {
	[ -n "$(ls -A /usr/share/grafana)" ];
}

setup_homedir() {
	cp -r /usr/share/grafana-default/* /usr/share/grafana/
}

main() {
	if [ is_fresh ]; then
		setup_homedir
	fi
	
	export GF_SERVER_DOMAIN=$DOMAIN_NAME

    log "Starting Grafana"
	exec "$@"
}

main "$@"
