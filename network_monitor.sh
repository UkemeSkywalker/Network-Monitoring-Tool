#!/bin/bash

# Log file path
LOG_FILE="network_monitor.log"

# Ping a list of specified nodes and display the status of each node (reachable or unreachable).
# Check if input is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 [node1] [node2] ..."
    exit 1
fi


# Function to log the timestamp and node status
log_status() {
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    node=$1
    status=$2
    echo "$timestamp - $node is $status" >> "$LOG_FILE"
}

# Loop through each argument (node)
for node in "$@"; do
    # Ping the node and capture the output
    ping -c 1 "$node" > /dev/null 2>&1

    # Check the exit status of the ping command
    if [ $? -eq 0 ]; then
        echo "$node is reachable"
        log_status $node reachable
    else
        echo "$node is unreachable"
        log_status $node unreachable
    fi
done
