#!/bin/sh

# Set default user to run Asterisk as (defaults to 'asterisk')
ASTERISK_USER=${ASTERISK_USER:-asterisk}

# Check if no command is provided
if [ "$1" = "" ]; then
  # Set default command to start Asterisk with verbose output
  COMMAND="/usr/sbin/asterisk -T -W -U ${ASTERISK_USER} -p -vvvdddf"
else
  # Use provided command
  COMMAND="$@"
fi

# Check if both ASTERISK_UID and ASTERISK_GID environment variables are set
if [ "${ASTERISK_UID}" != "" ] && [ "${ASTERISK_GID}" != "" ]; then
  # Recreate user and group for Asterisk if they are provided as environment variables
  # This is typically done to match the user and group IDs with those of the host system
  # to fix permissions for mounted folders

  # Delete existing asterisk user
  deluser asterisk && \
  # Add asterisk user with specified UID and no home directory, and disabled password
  adduser --gecos "" --no-create-home --uid ${ASTERISK_UID} --disabled-password ${ASTERISK_USER} || exit

  # Change ownership of directories to match new UID and GID
  chown -R ${ASTERISK_UID}:${ASTERISK_GID} /etc/asterisk \
                                           /var/*/asterisk \
                                           /usr/*/asterisk
fi
# Execute the command (either default or provided)
exec ${COMMAND}
