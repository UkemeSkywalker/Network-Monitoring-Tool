#!/bin/bash

# Log file path
logs_folder="./logs/"

# Check if the logs folder exists
if [ ! -d "$logs_folder" ]; then
    echo "Logs folder does not exist. Creating..."
    mkdir -p "$logs_folder"
    echo "Logs folder created successfully."
else
    echo "Logs folder already exists."
fi

LOG_FILE="./logs/network_monitor.log"


# Email configuration
recipient="ukemzyreloaded@gmail.com"
subject="Network Monitor Alert: Node Unreachable"


# Function to log the timestamp and node status
log_status() {
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    node=$1
    status=$2
    echo "$timestamp - $node is $status" >> "$LOG_FILE"

    # Check if status is unreachable and send email notification
    if [ "$status" = "unreachable" ]; then
        send_email "$node"
    fi
}

# Function to send email notification
send_email() {
    node=$1
    message="Node $node is unreachable at $(date '+%Y-%m-%d %H:%M:%S')"
    
# JSON payload for the API request

    payload=$(cat <<EOF
        {
        "from": "Supra Oracle <onboarding@resend.dev>",
        "to": ["$recipient"],
        "subject": "$subject",
        "text": "$message"
        }
EOF
    )


     # Send the email using curl
    curl -X POST 'https://api.resend.com/emails' \
     -H 'Authorization:  Bearer change_this_to_api_key' \
     -H 'Content-Type: application/json' \
     -d "$payload"

}



# Ping a list of specified nodes and display the status of each node (reachable or unreachable).
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
