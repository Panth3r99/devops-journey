#!/bin/bash

# Environment variables (use GitHub Secrets in CI)
TELEGRAM_TOKEN=${8612525745:AAEwFydlMmO2bqS8lsZYMaAtwWzKecu4B1c}
CHAT_ID=${5224463283}

# Function to send Telegram alert
send_alert() {
    MESSAGE=$1
    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage" \
        -d chat_id=$5224463283 \
        -d text="$MESSAGE"
}

echo "Starting server checks..."

while read server; do

    # If it's a URL
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

                # Send Telegram alert
                send_alert "🚨 ALERT: $server is DOWN (HTTP $status)"
            fi
        fi

    else
        # Ping check
        ping -c 1 $server > /dev/null 2>&1

        if [ $? -eq 0 ]; then
            echo "$server is UP"
        else
            echo "ALERT: $server is DOWN"

            # Send Telegram alert
            send_alert "🚨 ALERT: $server is DOWN"
        fi
    fi

done < servers.txt

# Always succeed (don’t break CI)
exit 0
