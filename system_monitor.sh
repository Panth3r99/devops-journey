#!/bin/bash

echo "===== System Monitoring Report ====="
echo "Time: $(date)"
echo ""

# CPU usage
cpu=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
cpu=${cpu%.*}

# Memory usage
mem=$(free | awk '/Mem/ {printf("%.0f"), $3/$2 * 100}')

# Disk usage
disk=$(df / | awk 'END {print $5}' | sed 's/%//')

echo "CPU Usage: $cpu%"
echo "Memory Usage: $mem%"
echo "Disk Usage: $disk%"
echo ""

# Alerts
failed=0

if [ "$cpu" -gt 80 ]; then
    echo "ALERT: High CPU usage"
    failed=1
fi

if [ "$mem" -gt 80 ]; then
    echo "ALERT: High Memory usage"
    failed=1
fi

if [ "$disk" -gt 80 ]; then
    echo "ALERT: Disk almost full"
    failed=1
fi

# Exit for CI
if [ $failed -eq 1 ]; then
    exit 1
else
    exit 0
fi
