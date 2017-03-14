#!/bin/sh
# start-cron.sh

rsyslogd
/usr/sbin/crond
touch /var/log/cron.log
tail -F /var/log/syslog /var/log/cron.log