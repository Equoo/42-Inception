#!/bin/sh
set -e

HOST=localhost
PORT=9000
TIMEOUT=-3

if command -v cgi-fcgi >/dev/null 2>&1; then
    cgi-fcgi -bind -connect "${HOST}:${PORT}" < /dev/null > /dev/null 2>&1
    exit $?
fi

(
    exec 3<>/dev/tcp/"$HOST"/"$PORT"
    exec 3>&-
) 2>/dev/null

exit $?
