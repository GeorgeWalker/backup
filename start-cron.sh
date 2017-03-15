#!/bin/sh
# start-cron.sh
crontab /app/crontab
tail -F /var/log/cron.log