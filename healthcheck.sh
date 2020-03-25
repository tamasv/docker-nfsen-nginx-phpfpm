#!/usr/bin/env bash

# Yes, this is ugly.  I'll clean it up later

# Define LSB log_* functions.
# Depend on lsb-base (>= 3.0-6) to ensure that this file is present.
. /lib/lsb/init-functions

NAME=php-fpm7.3
DAEMON=/usr/sbin/$NAME

status_of_proc "$DAEMON" "$NAME" || exit $?

DAEMON=/usr/sbin/nginx
NAME=nginx
# Try to extract nginx pidfile
PID=$(cat /etc/nginx/nginx.conf | grep -Ev '^\s*#' | awk 'BEGIN { RS="[;{}]" } { if ($1 == "pid") print $2 }' | head -n1)
if [ -z "$PID" ]; then
	PID=/run/nginx.pid
fi

status_of_proc -p $PID "$DAEMON" "$NAME" || exit $?

command=$(/nfsen/bin/nfsen status | grep "is not running" | wc -l)
if [[ $command  == "0" ]]; then
        echo "NFSen healthcheck success"
        exit 0
else
        echo "NFSen healthcheck failed"
        exit -1
fi
