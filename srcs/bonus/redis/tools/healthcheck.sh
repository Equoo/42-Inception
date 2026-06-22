#!/bin/sh
set -e

redis-cli ping | grep -q PONG || exit 1

exit $?
