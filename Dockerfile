#Base On Asterisk Image
FROM andrius/asterisk

# Set maintainer label
LABEL maintainer="Ala Khiari <khiarialaa@gmail.com>"

#Put The Configuration Of Your Asterisk
COPY modules.conf /etc/asterisk/modules.conf
COPY extensions.conf /etc/asterisk/extensions.conf
COPY ari.conf /etc/asterisk/ari.conf
COPY http.conf /etc/asterisk/http.conf
COPY queues.conf /etc/asterisk/queues.conf
COPY voicemail.conf /etc/asterisk/voicemail.conf
COPY sip.conf /etc/asterisk/sip.conf
COPY queues.conf /etc/asterisk/queues.conf
#Expose Ports From Container
EXPOSE 8088
EXPOSE 5060/udp

#External Storage For users
VOLUME /etc/asterisk/sip.conf
VOLUME /etc/asterisk/voicemail.conf

