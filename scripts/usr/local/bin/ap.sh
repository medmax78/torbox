#! /bin/sh
wired=`cat /sys/class/net/eth0/operstate`
if [ "$wired" = "up" ]; then
  /usr/local/bin/start_ap.sh
fi



