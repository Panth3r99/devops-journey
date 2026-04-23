#!/bin/bash

servers=("google.com" "github.com")

echo "Starting server checks..."

for server in "${servers[@]}"
do
    if ping -n 2 $server > /dev/null
    then
        echo "$(date) - $server is UP" >> monitor.log
        echo "$server is UP"
    else
        echo "$(date) - $server is DOWN" >> monitor.log
        echo "$server is DOWN"
    fi
done
