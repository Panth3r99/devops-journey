#!/bin/bash

echo "Starting server checks..."

# Detect OS
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    ping_cmd="ping -n 2"
else
    ping_cmd="ping -c 2"
fi

while read server
do
    if $ping_cmd "$server" > /dev/null
    then
        status="UP"
    else
        status="DOWN"
        echo "ALERT: $server is DOWN"
    fi

    echo "$server is $status"
    echo "$(date) - $server is $status" >> monitor.log

done < servers.txt
