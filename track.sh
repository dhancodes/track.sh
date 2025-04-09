#!/bin/bash

# Configuration
INTERVAL=3h  # Check interval
TG_CHAT_ID=""
TG_BOT_TOKEN=""

# Function to send Telegram message
tgsend() {
    MESSAGE="$1"
    curl -s -X POST "https://api.telegram.org/bot$TG_BOT_TOKEN/sendMessage" -d chat_id="$TG_CHAT_ID" -d text="$MESSAGE" >/dev/null
}

if [[ -n "$1" ]]; then
    PID=$1
    echo "Tracking existing process with PID $PID..."
    tgsend "Tracking existing process with PID $PID..."
else
	echo "No PID given..." && exit 1
fi

# Function to get system info
get_system_info() {
    local info=""
    info+="Timestamp: $(date)\n"
    info+="---------------------------\n"

    info+="CPU Usage:\n"
    info+="$(top -bn1 | grep "Cpu(s)" | awk '{print "CPU Load: " $2 + $4 "%"}')\n"
    info+="---------------------------\n"

    info+="Memory Usage:\n"
    info+="$(free -h | awk '/Mem:/ {print $3 " / " $2}')\n"
    info+="---------------------------\n"

    info+="Top Processes:\n"
    info+="$(ps -eo %cpu,%mem,cmd --sort=-%cpu | head -n 11 | awk '{printf "%-8s %-6s %-6s %-s\n", $1, $2, $3, $4}')\n"
    info+="---------------------------\n"

    info+="Temperature (Celsius):\n"
    local avg_temp=$(sensors | grep 'Core' | awk '{sum+=$3; count++} END {print sum/count}' | sed 's/+//g' | sed 's/°C//g')
    local high_temp=$(sensors | grep 'Core' | awk '{print $3}' | sed 's/+//g' | sed 's/°C//g' | sort -nr | head -n1)
    info+="Average temp: $avg_temp\n"
    info+="Highest temp: $high_temp\n"
    info+="---------------------------\n"

    echo -e "$info"
}

# Monitor the system while the process is running
while kill -0 $PID 2> /dev/null; do
	system_report=$(get_system_info)
	tgsend "$system_report"
    sleep $INTERVAL
done

echo "Process $PID has completed."
tgsend "Process $PID has completed."

