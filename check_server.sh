#!/bin/bash

echo "Checking server..."

if ping -n 2 google.com > /dev/null
then
    echo "$(date) - Server is UP" >> monitor.log
    echo "Server is UP"
else
    echo "$(date) - Server is DOWN" >> monitor.log
    echo "Server is DOWN"
fi
