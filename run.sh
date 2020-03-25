#!/bin/bash

/etc/init.d/php7.3-fpm restart || exit 1
/etc/init.d/nginx restart || exit 1
/nfsen/bin/nfsen start || exit 1
sleep infinity
