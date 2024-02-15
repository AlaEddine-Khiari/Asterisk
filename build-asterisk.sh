#!/bin/bash

# Set the program name
PROGNAME=$(basename $0)

# Check if the ASTERISK_VERSION environment variable is set
if test -z ${ASTERISK_VERSION}; then
  echo "${PROGNAME}: ASTERISK_VERSION required" >&2
  exit 1
fi

# Set options for debugging and immediate exit on error
set -ex

# Create a system user for Asterisk
useradd --system asterisk

# Update package lists and install required dependencies
apt-get update -qq
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends --no-install-suggests \
    autoconf \
    binutils-dev \
    build-essential \
    ca-certificates \
    curl \
    file \
    libcurl4-openssl-dev \
    libedit-dev \
    libgsm1-dev \
    libogg-dev \
    libpopt-dev \
    libresample1-dev \
    libspandsp-dev \
    libspeex-dev \
    libspeexdsp-dev \
    libsqlite3-dev \
    libsrtp2-dev \
    libssl-dev \
    libvorbis-dev \
    libxml2-dev \
    libxslt1-dev \
    procps \
    portaudio19-dev \
    unixodbc \
    unixodbc-bin \
    unixodbc-dev \
    odbcinst \
    uuid \
    uuid-dev \
    xmlstarlet \
    locales

# Configure locales for French (change 'fr_FR.UTF-8' to the desired locale)
echo "fr_FR.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen

# Clean up after installation
apt-get purge -y --auto-remove
rm -rf /var/lib/apt/lists/*

# Set the time zone to Africa/Tunis
echo "Africa/Tunis" > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata

# Create directory for Asterisk source code
mkdir -p /usr/src/asterisk
cd /usr/src/asterisk

# Download and extract Asterisk source code based on specified version
curl -vsL http://downloads.asterisk.org/pub/telephony/asterisk/releases/asterisk-${ASTERISK_VERSION}.tar.gz | tar --strip-components 1 -xz || \
curl -vsL http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-${ASTERISK_VERSION}.tar.gz | tar --strip-components 1 -xz || \
curl -vsL http://downloads.asterisk.org/pub/telephony/asterisk/old-releases/asterisk-${ASTERISK_VERSION}.tar.gz | tar --strip-components 1 -xz

# Calculate number of jobs for parallel compilation
: ${JOBS:=$(( $(nproc) + $(nproc) / 2 ))}

# Configure Asterisk build with required options
./configure --with-resample \
            --with-pjproject-bundled \
            --with-jansson-bundled

# Build Asterisk with menu selections
make menuselect/menuselect menuselect-tree menuselect.makeopts

# Disable BUILD_NATIVE to avoid platform issues
menuselect/menuselect --disable BUILD_NATIVE menuselect.makeopts

# Enable necessary features
menuselect/menuselect --enable BETTER_BACKTRACES menuselect.makeopts
menuselect/menuselect --enable chan_ooh323 menuselect.makeopts

# Disable unnecessary features
menuselect/menuselect --disable-category MENUSELECT_CORE_SOUNDS menuselect.makeopts
menuselect/menuselect --disable-category MENUSELECT_MOH menuselect.makeopts
menuselect/menuselect --disable-category MENUSELECT_EXTRA_SOUNDS menuselect.makeopts

# Compile Asterisk
make -j ${JOBS} all
make install

# Copy default configuration files
make samples

# Set runuser and rungroup in Asterisk configuration
sed -i -E 's/^;(run)(user|group)/\1\2/' /etc/asterisk/asterisk.conf

# Install Opus codec
mkdir -p /usr/src/codecs/opus \
  && cd /usr/src/codecs/opus \
  && curl -vsL http://downloads.digium.com/pub/telephony/codec_opus/${OPUS_CODEC}.tar.gz | tar --strip-components 1 -xz \
  && cp *.so /usr/lib/asterisk/modules/ \
  && cp codec_opus_config-en_US.xml /var/lib/asterisk/documentation/

# Create directories and set permissions
mkdir -p /etc/asterisk/ \
         /var/spool/asterisk/fax

chown -R asterisk:asterisk /etc/asterisk \
                           /var/*/asterisk \
                           /usr/*/asterisk
chmod -R 750 /var/spool/asterisk

# Remove development packages and clean up
devpackages=`dpkg -l|grep '\-dev'|awk '{print $2}'|xargs`
DEBIAN_FRONTEND=noninteractive apt-get --yes purge \
    autoconf \
    binutils-dev \
    build-essential \
    ca-certificates \
    curl \
    file \
    libcurl4-openssl-dev \
    libedit-dev \
    libgsm1-dev \
    libogg-dev \
    libpopt-dev \
    libresample1-dev \
    libspandsp-dev \
    libspeex-dev \
    libspeexdsp-dev \
    libsqlite3-dev \
    libsrtp2-dev \
    libssl-dev \
    libvorbis-dev \
    libxml2-dev \
    libxslt1-dev \
    procps \
    portaudio19-dev \
    unixodbc \
    unixodbc-bin \
    unixodbc-dev \
    odbcinst \
    uuid \
    uuid-dev \
    xmlstarlet \
    ${devpackages}
rm -rf /var/lib/apt/lists/*

#Clean The container
DEBIAN_FRONTEND=noninteractive apt-get clean

# Remove the script itself
exec rm -f /build-asterisk.sh
