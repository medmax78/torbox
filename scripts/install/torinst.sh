#!/bin/sh
. ./config.inc
apt-get -y remove tor > /dev/null
apt-get -y remove torsocks > /dev/null
apt-get -y purge tor > /dev/null
apt-get -y remove deb.torproject.org-keyring > /dev/null
apt-get -y purge deb.torproject.org-keyring > /dev/null

if [ ${USE_STOCK_TOR} = "1" ]; then
   #### This part is for installing stock tor
   echo "Installing stock tor..."
   rm /etc/apt/sources.list.d/tor-repo.list
   apt-get update > /dev/null
   apt-get -y install tor > /dev/null  
else
   ####This part is for installing from tor offical repo.
   echo "Installing tor from torproject repo..."
   echo "deb http://deb.torproject.org/torproject.org jessie main" | tee /etc/apt/sources.list.d/tor-repo.list
   echo "deb-src http://deb.torproject.org/torproject.org jessie main" | tee -a /etc/apt/sources.list.d/tor-repo.list
   gpg --keyserver keys.gnupg.net --recv 886DDD89
   gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -
   apt-get update > /dev/null
   apt-get -y install tor deb.torproject.org-keyring > /dev/null
fi





/etc/init.d/tor stop

echo "Configuring tor..."

echo "Log notice syslog" >>/etc/tor/torrc
echo "VirtualAddrNetworkIPv4 10.192.0.0/10" >>/etc/tor/torrc
echo "AutomapHostsOnResolve 1" >>/etc/tor/torrc
echo "TransPort 9040" >>/etc/tor/torrc
echo "DNSPort 9053" >>/etc/tor/torrc
echo "CircuitBuildTimeout 30" >>/etc/tor/torrc
echo "KeepAlivePeriod 60" >>/etc/tor/torrc
echo "NewCircuitPeriod 15" >>/etc/tor/torrc
echo "NumEntryGuards 8" >>/etc/tor/torrc
echo "ConstrainedSockets 1" >>/etc/tor/torrc
echo "ConstrainedSockSize 8192" >>/etc/tor/torrc
echo "AvoidDiskWrites 1" >>/etc/tor/torrc
echo "DNSListenAddress 0.0.0.0" >>/etc/tor/torrc

echo "TransListenAddress 0.0.0.0" >>/etc/tor/torrc

update-rc.d tor enable
/etc/init.d/tor start
