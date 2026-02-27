#!/usr/bin/env bash

NOW=$(date "+%Y-%m-%d %H:%M:%S")

if [ -z "$SCHEDULE" ] ; then
  echo "No schedule provided"
  exit
fi

SETUP_FILE=$(echo "$SETUP" | cut -d " " -f 1)
chmod -f +x "$SETUP_FILE"
$SETUP
if [ ! $? ] ; then
  echo "$NOW: Setup failed"
  exit
else
  echo "$NOW: Install Complete"
fi

SCRIPT_FILE=$(echo "$SCRIPT" | cut -d " " -f 1)
chmod -f +x "$SCRIPT_FILE"

mkdir -p /var/spool/cron/crontabs/
echo "$SCHEDULE $SCRIPT" > /var/spool/cron/crontabs/root
$RUN