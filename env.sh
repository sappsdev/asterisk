#!/bin/bash

ENV_FILE=".env"
if [ ! -f "$ENV_FILE" ]; then
    echo "Error: File .env not found."
    exit 1
fi

cp -r etc/* /etc/

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
sed -i "s|{{ARI_PASSWORD}}|$ARI_PASSWORD|g" /etc/asterisk/ari.conf

systemctl restart asterisk