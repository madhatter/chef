#!/bin/bash
# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

/etc/init.d/nginx stop 
/home/madhatter/letsencrypt/letsencrypt-auto renew -nvv --standalone > /var/log/letsencrypt/renew.log 2>&1
LE_STATUS=$?
/etc/init.d/nginx start 
if [ "$LE_STATUS" != 0 ]; then
    echo Automated renewal failed:
    cat /var/log/letsencrypt/renew.log
    exit 1
fi
