#!/bin/bash
command=$(/nfsen/bin/nfsen status | grep "is not running" | wc -l)
if [[ $command  == "0" ]]; then
        echo "NFSen healthcheck success"
        exit 0
else
        echo "NFSen healthcheck failed"
        exit -1
fi

