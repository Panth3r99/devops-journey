#!/bin/bash

echo "Starting server checks..."

while read server
do
    if ping -n 2 "$server" > /dev/null
    then
        status="UP"
    else
        status="DOWN"
        echo "⚠️ ALERT: $server is DOWN"
    fi

    echo "[$(date)] $server status: $status"
    echo "$(date) - $server is $status" >> monitor.log

done < servers.txt
