#!/bin/bash

# Read from environment (GitHub Secrets)
TELEGRAM_TOKEN=$TELEGRAM_TOKEN
CHAT_ID=$CHAT_ID

# Debug prints
echo "DEBUG: Token length = ${#TELEGRAM_TOKEN}"
echo "DEBUG: Chat ID = $CHAT_ID"

# Function to send alert
send_alert() {
    MESSAGE=$1

    echo "DEBUG: Sending Telegram message..."

    curl -v -X POST "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage" \
        -d chat_id=$CHAT_ID \
        -d text="$MESSAGE"
}

echo "FORCING ALERT TEST..."

# Force send alert
send_alert "🚨 TEST ALERT FROM GITHUB ACTIONS"

# Always succeed (don’t break CI)
exit 0
