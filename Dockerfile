FROM debian:buster-slim

# Set maintainer label
LABEL maintainer="Ala Khiari <khiarialaa@gmail.com>"

# Set environment variables for Asterisk version and Opus codec
ENV ASTERISK_VERSION 18-current
ENV OPUS_CODEC       asterisk-18.0/x86-64/codec_opus-18.0_current-x86_64

# Copy the Asterisk build script into the container root directory
COPY build-asterisk.sh /

# Set execute permissions on the build script
RUN chmod +x /build-asterisk.sh

# Run the Asterisk build script
RUN /build-asterisk.sh

# Set Up The Config: Copy Asterisk configuration files
COPY modules.conf /etc/asterisk/modules.conf
COPY extensions.conf /etc/asterisk/extensions.conf
COPY ari.conf /etc/asterisk/ari.conf
COPY http.conf /etc/asterisk/http.conf
COPY queues.conf /etc/asterisk/queues.conf
COPY res_odbc.conf /etc/asterisk/res_odbc.conf

# Expose Asterisk ports
EXPOSE 5060/udp 5060/tcp
EXPOSE 8088
EXPOSE 10000-10099/udp
# Define volumes 
VOLUME /etc/asterisk/sip.conf
VOLUME /etc/asterisk/voicemail.conf

# Copy the Docker entrypoint script into the container root directory
COPY docker-entrypoint.sh /

# Set execute permissions on the entrypoint script
RUN chmod +x /docker-entrypoint.sh

# Set the entrypoint for the container to the entrypoint script
ENTRYPOINT ["/docker-entrypoint.sh"]
