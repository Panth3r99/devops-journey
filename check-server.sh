#!/bin/bash

echo "Starting server checks..."

# Detect OS for ping
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    ping_cmd="ping -n 2"
else
    ping_cmd="ping -c 2"
fi

failed=0

while read server
do
    # If it looks like a URL, use curl
    if [[ "$server" == http* ]]; then
        if curl -s --head "$server" | grep "200 OK" > /dev/null
        then
            status="UP"
        else
            status="DOWN"
            failed=1
            echo "ALERT: $server is DOWN"
        fi
    else
        if $ping_cmd "$server" > /dev/null
        then
            status="UP"
        else
            status="DOWN"
            failed=1
            echo "ALERT: $server is DOWN"
        fi
    fi

    echo "$server is $status"
    if [ "$status" == "UP" ]; then
    echo "$(date) - $server is UP" >> success.log
else
    echo "$(date) - $server is DOWN" >> error.log
fi

done < servers.txt

if [ $failed -eq 1 ]; then
    exit 1
else
    exit 0
fi
