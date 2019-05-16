#!/bin/bash
command=$(/nfsen/bin/nfsen status | grep "is not running" | wc -l)
if [[ $command  == "0" ]]; then
        echo "$command success"
        exit 0
else:
        echo "$command fail"
        exit -1
fi

