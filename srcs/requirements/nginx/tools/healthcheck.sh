#!/bin/sh
set -e

echo 127.0.0.1 $DOMAIN_NAME >> /etc/hosts

curl \
    --fail \
    --connect-timeout 3 \
    --max-time 5 \
    --insecure \
    --silent \
    --show-error \
    "https://$DOMAIN_NAME/" > /dev/null 2>&1

exit $?
