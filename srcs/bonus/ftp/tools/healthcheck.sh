#!/bin/sh
set -e

curl -Is --connect-timeout 5 ftp://localhost:21

exit $?
