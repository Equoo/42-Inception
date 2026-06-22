#!/bin/sh
set -eo pipefail

log() { echo "[entrypoint] $*"; }
die() { echo "[entrypoint] ERROR: $*" >&2; exit 1; }

main() {
    log "Starting Redis"
	exec "$@"
}

main "$@"
