#!/bin/bash

LOG_FILE="system_monitor.log"

echo "===== System Monitoring Report =====" | tee -a $LOG_FILE
echo "Time: $(date)" | tee -a $LOG_FILE
echo "" | tee -a $LOG_FILE

# CPU usage
cpu=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
cpu=${cpu%.*}

# Memory usage
mem=$(free | awk '/Mem/ {printf("%.0f"), $3/$2 * 100}')

# Disk usage
disk=$(df / | awk 'END {print $5}' | sed 's/%//')

echo "CPU Usage: $cpu%" | tee -a $LOG_FILE
echo "Memory Usage: $mem%" | tee -a $LOG_FILE
echo "Disk Usage: $disk%" | tee -a $LOG_FILE
echo "" | tee -a $LOG_FILE

failed=0

# Alerts
if [ "$cpu" -gt 80 ]; then
    echo "ALERT: High CPU usage" | tee -a $LOG_FILE
    failed=1
fi

if [ "$mem" -gt 80 ]; then
    echo "ALERT: High Memory usage" | tee -a $LOG_FILE
    failed=1
fi

if [ "$disk" -gt 80 ]; then
    echo "ALERT: Disk almost full" | tee -a $LOG_FILE
    failed=1
fi

# Do NOT fail CI (logging only)
exit 0
