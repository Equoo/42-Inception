#!/bin/sh
set -eo pipefail

log() { echo "[entrypoint] $*"; }
die() { echo "[entrypoint] ERROR: $*" >&2; exit 1; }

is_fresh() {
	[ -n "$(ls -A /usr/share/grafana)" ];
}

setup_homedir() {
	cp -r /usr/share/grafana-default/* /usr/share/grafana/

	grafana-cli plugins install redis-datasource

	mkdir -p /usr/share/grafana/data/plugins/ 
	cp -r /var/lib/grafana/plugins/redis-datasource /usr/share/grafana/data/plugins/redis-datasource
}

main() {
	if [ is_fresh ]; then
		setup_homedir
	fi

	export GF_PASSWORD=$(cat /run/secrets/gf_password)
	export MYSQL_PASSWORD=$(cat /run/secrets/mysql_password)

	cat /usr/share/grafana/conf/custom.ini.template | envsubst > /usr/share/grafana/conf/custom.ini
	cat /usr/share/grafana/conf/provisioning/datasources/datasource.yml.template | envsubst > /usr/share/grafana/conf/provisioning/datasources/datasource.yml

	unset MYSQL_PASSWORD GF_PASSWORD

    log "Starting Grafana"
	exec "$@"
}

main "$@"
