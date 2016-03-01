#!/bin/sh

IPTABLES=/sbin/iptables
LAN=wlan0
WAN=eth0

firewall_pass ()
{
echo "Applying pass-through firewall rules..."
$IPTABLES -t nat -A PREROUTING -i $LAN -p tcp --dport 8118 -j REDIRECT --to-port 8118
$IPTABLES -t nat -A PREROUTING -i $LAN -p tcp --dport 7657 -j REDIRECT --to-ports 7657
$IPTABLES -t nat -A PREROUTING -i $LAN -p tcp --dport 22 -j REDIRECT --to-ports 22
$IPTABLES -t nat -A PREROUTING -i $LAN -p tcp --dport 3000 -j REDIRECT --to-ports 3000
}

firewall_tor ()
{
echo "Applying tor firewall rules..."
$IPTABLES -t nat -A PREROUTING -i $LAN -p udp --dport 53 -j REDIRECT --to-ports 9053
$IPTABLES -t nat -A PREROUTING -i $LAN -p tcp --syn -j REDIRECT --to-ports 9040
}

firewall_privoxy ()
{
 echo "Applying privoxy firewall rules..."
 $IPTABLES -t nat -A PREROUTING -i $LAN -p tcp --dport 80 -j REDIRECT --to-port 8118
}

firewall_incoming ()
{
  echo "Blocking incoming connections..."
  $IPTABLES -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
  $IPTABLES -A INPUT -i $WAN -j DROP
}


/usr/local/bin/clean_firewall.sh
/sbin/sysctl -w net.ipv4.ip_forward=1
firewall_pass

MODE="${1}" 

case $MODE in
	tor)
            firewall_tor
            echo "TOR" >/run/apmode
            echo "TOR mode enabled..."
           ;;
	privoxy) 
            firewall_privoxy
            firewall_tor
            echo "PRIVOXY" >/run/apmode
            echo "Privoxy mode enabled..."
           ;;
	direct) 
            masquerade.sh $LAN $WAN
            echo "DIRECT" >/run/apmode
	    echo "Direct mode enabled..."
           ;;
	*) echo "Usage: all_tor.sh tor|privoxy|direct"
	   ;;
esac



