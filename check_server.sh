#!/bin/bash

echo "Starting server checks..."

while read server; do

    # If it's a URL (HTTP/HTTPS)
    if [[ $server == http* ]]; then

        # First attempt
        status=$(curl -k -o /dev/null -s -w "%{http_code}" \
          --connect-timeout 10 \
          --max-time 20 \
          $server)

        if [ "$status" -eq 200 ]; then
            echo "$server is UP"
        else
            echo "Retrying $server..."
            sleep 10

            # Retry attempt
            status=$(curl -k -o /dev/null -s -w "%{http_code}" \
              --connect-timeout 10 \
              --max-time 20 \
              $server)

            if [ "$status" -eq 200 ]; then
                echo "$server is UP (after retry)"
            else
                echo "ALERT: $server is DOWN (HTTP $status)"
            fi
        fi

    else
        # For non-HTTP (ping)
        ping -c 1 $server > /dev/null 2>&1

        if [ $? -eq 0 ]; then
            echo "$server is UP"
        else
            echo "ALERT: $server is DOWN"
        fi
    fi

done < servers.txt
