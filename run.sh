#!/bin/bash

/etc/init.d/php7.2-fpm restart
/etc/init.d/nginx restart
/nfsen/bin/nfsen reconfig
/nfsen/bin/nfsen start
sleep infinity
