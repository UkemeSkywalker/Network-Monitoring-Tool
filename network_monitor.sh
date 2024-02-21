#!/bin/bash

# Ping a list of specified nodes and display the status of each node (reachable or unreachable).

# Check if input is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 [node1] [node2] ..."
    exit 1
fi

# Loop through each argument (node)
for node in "$@"; do
    # Ping the node and capture the output
    ping -c 1 "$node" > /dev/null 2>&1

    # Check the exit status of the ping command
    if [ $? -eq 0 ]; then
        echo "$node is reachable"
    else
        echo "$node is unreachable"
    fi
done
