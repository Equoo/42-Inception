#!/bin/sh
set -eo pipefail

# Helpers
log() { echo "[entrypoint] $*"; }
die() { echo "[entrypoint] ERROR: $*" >&2; exit 1; }

setup_user() {
	log "Setup user \"$FTP_USER\""

	FTP_USER="${FTP_USER:-ftpuser}"
	FTP_UID="${FTP_UID:-1000}"
	FTP_GID="${FTP_GID:-1000}"
	FTP_HOME=/home/$FTP_USER

	mkdir -p $FTP_HOME/uploads

	HASH=$(cat /run/secrets/ftp_password | openssl passwd -1 -stdin)

	echo "${FTP_USER}:${HASH}:${FTP_UID}:${FTP_GID}::/ftp:/bin/sh" > /etc/proftpd/ftpd.passwd

	echo "${FTP_USER}group:x:${FTP_GID}:${FTP_USER}" > /etc/proftpd/ftpd.group

	chown 1000:1000 $FTP_HOME
    chmod 755 $FTP_HOME $FTP_HOME/uploads
}

main() {
	setup_user

    log "Starting ProFTPd"
	exec "$@"
}

main "$@"
