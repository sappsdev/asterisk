#!/bin/sh

ENV_FILE=".env"
if [ ! -f "$ENV_FILE" ]; then
    echo "Error: File .env not found."
    exit 1
fi

# Update and install dependencies
apt update
apt install -y wget odbc-postgresql certbot

# Download and install Asterisk
cd /usr/src
wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-20-current.tar.gz
tar zxvf asterisk-20-current.tar.gz
rm -rf asterisk-20-current.tar.gz
cd /usr/src/asterisk-20*/

# Install asterisk dependencies
contrib/scripts/install_prereq install

# Configure and compile Asterisk
./configure
make menuselect.makeopts
menuselect/menuselect --enable codec_opus --enable format_mp3 menuselect.makeopts
make
contrib/scripts/get_mp3_source.sh
make install
make config

systemctl enable asterisk
systemctl start asterisk

echo "Asterisk has been installed successfully."
