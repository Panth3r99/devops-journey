#!/bin/bash

TELEGRAM_TOKEN=$TELEGRAM_TOKEN
CHAT_ID=$CHAT_ID

send_alert() {
    MESSAGE=$1
    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage" \
        -d chat_id=$CHAT_ID \
        -d text="$MESSAGE"
}

echo "Starting server checks..."

while read server; do

    if [[ $server == http* ]]; then

        status=$(curl -k -o /dev/null -s -w "%{http_code}" \
          --connect-timeout 10 \
          --max-time 20 \
          $server)

        if [ "$status" -eq 200 ]; then
            echo "$server is UP"
        else
            echo "Retrying $server..."
            sleep 10

            status=$(curl -k -o /dev/null -s -w "%{http_code}" \
              --connect-timeout 10 \
              --max-time 20 \
              $server)

            if [ "$status" -eq 200 ]; then
                echo "$server is UP (after retry)"
            else
                echo "ALERT: $server is DOWN (HTTP $status)"
                send_alert "🚨 ALERT: $server is DOWN (HTTP $status)"
            fi
        fi

    else
        ping -c 1 $server > /dev/null 2>&1

        if [ $? -eq 0 ]; then
            echo "$server is UP"
        else
            echo "ALERT: $server is DOWN"
            send_alert "🚨 ALERT: $server is DOWN"
        fi
    fi

done < servers.txt

exit 0
