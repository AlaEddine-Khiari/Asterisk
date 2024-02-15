#!/bin/bash

# Start Asterisk Docker container
docker run -d --name asterisk-cli asterisk-image

# Wait for Asterisk to initialize
sleep 10

# Enter Asterisk CLI
cli_output=$(docker exec -it asterisk-cli /bin/sh -c "asterisk -rvvvv 2>&1")

# Check if Asterisk CLI command was successful
if [ $? -ne 0 ]; then
    # If the Asterisk CLI command failed then exit
    echo "Asterisk CLI command failed"
    exit 1  # Exit with status 1 to indicate failure
fi

# Stop and remove the container
docker stop asterisk-cli
docker rm asterisk-cli
