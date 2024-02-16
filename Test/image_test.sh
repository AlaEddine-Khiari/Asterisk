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

# Create a test recording file
docker exec -it asterisk-cli touch /var/spool/asterisk/recording/test_recording.wav

# Check if the test recording file was created successfully
if [ $? -eq 0 ]; then
    echo "Recording permission test successful"
else
    echo "Recording permission test failed"
fi

# Stop and remove the container
docker stop asterisk-cli
docker rm asterisk-cli
