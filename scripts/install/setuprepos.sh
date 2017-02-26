#!/bin/sh
. ./config.inc

##
echo "Install TOR repos..."

if [ ${USE_STOCK_TOR} = "1" ]; then
   #### This part is for installing stock tor
   echo "For stock tor..."
   rm /etc/apt/sources.list.d/tor-repo.list
     
else
   ####This part is for installing from tor offical repo.
   echo "For torproject repo..."
   echo "deb http://deb.torproject.org/torproject.org jessie main" | tee /etc/apt/sources.list.d/tor-repo.list
   echo "deb-src http://deb.torproject.org/torproject.org jessie main" | tee -a /etc/apt/sources.list.d/tor-repo.list
   gpg --keyserver keys.gnupg.net --recv 886DDD89
   gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -
fi

echo "Install Java8 repos..."

echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list
echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 >/dev/null

apt-get update -y > /dev/null
