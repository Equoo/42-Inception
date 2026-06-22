#!/bin/sh
set -e

wget --quiet --tries=1 --spider http://localhost:3000/api/health || exit 1

exit $?
