#!/bin/bash

TELEGRAM_TOKEN=$TELEGRAM_TOKEN
CHAT_ID=$CHAT_ID

send_alert() {
    MESSAGE=$1
    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage" \
        -d chat_id=$CHAT_ID \
        -d text="$MESSAGE"
}

echo "FORCING ALERT TEST..."

send_alert "🚨 TEST ALERT FROM GITHUB ACTIONS"

exit 0
