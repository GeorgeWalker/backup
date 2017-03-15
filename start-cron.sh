#!/bin/sh
# start-cron.sh

/usr/sbin/crond
touch /var/log/cron.log
tail -F /var/log/cron.log