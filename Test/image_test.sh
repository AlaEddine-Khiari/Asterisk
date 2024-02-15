#!/bin/bash

# Start Asterisk Docker container
docker run -d --name asterisk-cli \
    -v ./sip.conf:/etc/asterisk/sip.conf \
    -v ./voicemail.conf:/etc/asterisk/voicemail.conf \
    asterisk-image

# Check if the container started successfully
if [ $? -ne 0 ]; then
    echo "Failed to start Asterisk container"
    exit 1
fi

echo "Asterisk container started successfully"

# Wait for Asterisk to initialize
sleep 10

# Enter Asterisk CLI
cli_output=$(docker exec -it asterisk-cli /bin/sh -c "asterisk -rvvvv 2>&1")

# Check if Asterisk CLI command was successful
if [ $? -ne 0 ]; then
    echo "Asterisk CLI command failed"
fi

# Stop and remove the container
docker stop asterisk-cli
docker rm asterisk-cli
