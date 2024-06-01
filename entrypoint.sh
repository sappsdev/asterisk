#!/bin/bash

ENV_FILE=".env"
if [ ! -f "$ENV_FILE" ]; then
    echo "Error: File .env not found."
    exit 1
fi

set -a
source .env
set +a

sed -i "s|{{DB_HOST}}|$DB_HOST|g" /etc/odbc.ini
sed -i "s|{{DB_NAME}}|$DB_NAME|g" /etc/odbc.ini
sed -i "s|{{DB_USER}}|$DB_USER|g" /etc/odbc.ini
sed -i "s|{{DB_PASS}}|$DB_PASS|g" /etc/odbc.ini
sed -i "s|{{DB_PORT}}|$DB_PORT|g" /etc/odbc.ini
sed -i "s|{{DB_USER}}|$DB_USER|g" /etc/asterisk/res_odbc.conf
sed -i "s|{{DB_PASS}}|$DB_PASS|g" /etc/asterisk/res_odbc.conf

if [ ! -d "/etc/letsencrypt/live/$SIP_DOMAIN" ]; then
    if certbot certonly --standalone -d $SIP_DOMAIN --agree-tos --eff-email --email $SIP_EMAIL; then
        cp /etc/letsencrypt/live/$SIP_DOMAIN/privkey.pem /etc/asterisk/keys/asterisk.key
        cp /etc/letsencrypt/live/$SIP_DOMAIN/fullchain.pem /etc/asterisk/keys/asterisk.crt
        chmod 777 /etc/asterisk/keys/asterisk.crt
        chmod 777 /etc/asterisk/keys/asterisk.key
        certbot renew --dry-run
    else
        echo "Error: Certbot certonly command failed"
    fi
else
    echo "El directorio de certificados ya existe: /etc/letsencrypt/live/$SIP_DOMAIN"
fi