#!/bin/bash

echo "Starting server checks..."

# Detect OS for ping
if [[ "$OSTYPE" == msys* || "$OSTYPE" == cygwin* ]]; then
    ping_cmd="ping -n 2"
else
    ping_cmd="ping -c 2"
fi

failed=0

while read server
do
    # Skip empty lines
    [ -z "$server" ] && continue

    # If it's a URL → use curl
    if [[ "$server" == http* ]]; then
        http_code=$(curl -k -s -o /dev/null -w "%{http_code}" "$server")

        if [[ "$http_code" == "200" || "$http_code" == "301" || "$http_code" == "302" ]]; then
            status="UP"
        else
            status="DOWN"
            failed=1
            echo "ALERT: $server is DOWN (HTTP $http_code)"
        fi

    # Else → use ping
    else
        if $ping_cmd "$server" > /dev/null 2>&1
        then
            status="UP"
        else
            status="DOWN"
            failed=1
            echo "ALERT: $server is DOWN"
        fi
    fi

    echo "$server is $status"

done < servers.txt

# Final exit status
if [ $failed -eq 1 ]; then
    exit 1
else
    exit 0
fi
