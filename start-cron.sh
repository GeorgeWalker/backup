#!/bin/sh
# start-cron.sh

export USER_ID=$(id -u)
export GROUP_ID=$(id -g)
envsubst < /app/passwd.template > /tmp/passwd
export LD_PRELOAD=libnss_wrapper.so
export NSS_WRAPPER_PASSWD=/tmp/passwd
export NSS_WRAPPER_GROUP=/etc/group

crontab /app/crontab
tail -F /var/log/cron.log