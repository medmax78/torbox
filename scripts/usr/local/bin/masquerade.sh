#!/bin/sh

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 wlan0(local) eth0(internet)" >&2
    exit 1
fi

/usr/local/bin/clean_firewall.sh

IPTABLES=/sbin/iptables
$IPTABLES --table nat --append POSTROUTING --out-interface $2 -j MASQUERADE
$IPTABLES --append FORWARD --in-interface $1 -j ACCEPT
$IPTABLES -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
$IPTABLES -A INPUT -i $2 -j DROP
/sbin/sysctl -w net.ipv4.ip_forward=1

