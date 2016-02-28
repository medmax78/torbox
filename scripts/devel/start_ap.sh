#! /bin/sh
/usr/local/bin/masquerade.sh wlan0 eth0
/usr/local/bin/all_tor.sh tor
touch /var/log/ap.log
DATE=`date`
echo "$DATE Access point started..." >/run/ap_stamp.log

