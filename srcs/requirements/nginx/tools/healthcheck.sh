#!/bin/sh
set -e

curl \
    --fail \
    --connect-timeout 3 \
    --max-time 5 \
    --insecure \
    --silent \
    --show-error \
    "https://localhost:443/" > /dev/null 2>&1

exit $?
