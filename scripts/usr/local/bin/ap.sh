#! /bin/sh
wireless=`cat /sys/class/net/wlan0/operstate`
wired=`cat /sys/class/net/eth0/operstate`
if [ "$wireless" != "down" ] || [ "$wired" = "up" ]; then
  /usr/local/bin/start_ap.sh
fi
