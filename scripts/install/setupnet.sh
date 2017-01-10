#!/bin/sh
. ./config.inc
echo "Setting up network..."


echo "Setting network rules to rename all wireless interfaces to wlan0..."

cp ./scripts/etc/udev/rules.d/70-persistent-net.rules /etc/udev/rules.d/70-persistent-net.rules

if [ ${HARDWARE} = "raspberrypi3" ]; then
  apt-get update >/dev/null
  apt-get -y install firmware-brcm80211 >/dev/null
fi

echo "Setting wlan0 interface..."
WLANFILE  = /etc/network/interdaces.d/wlan0

if [ ${HARDWARE} = "orangepi0" ]; then
###Armbian workaround
  WLANFILE = /etc/network/interfaces
fi
echo "auto wlan0" >>${WLANFILE}
echo "iface wlan0 inet static" >>${WLANFILE}
echo "       address $IP_ADDRESS" >>${WLANFILE}
echo "       netmask $IP_NETMASK" >>${WLANFILE}
echo "       network $IP_NETWORK" >>${WLANFILE}
echo "       broadcast $IP_BROADCAST" >>${WLANFILE}

apt-get update > /dev/null
apt-get -y install iptables > /dev/null
apt-get -y remove dnsmasq > /dev/null
apt-get -y purge dnsmasq > /dev/null
apt-get -y install dnsmasq > /dev/null

echo "Applying dnsmasq conf rules..."
echo " " >>/etc/dnsmasq.conf
echo "interface=wlan0" >> /etc/dnsmasq.conf
echo "dhcp-range=${DHCP_RANGE}" >> /etc/dnsmasq.conf
echo "address=${HOSTADDR}" >> /etc/dnsmasq.conf

echo "Setting script to start AP..."

ln -s /usr/local/bin/ap.sh /etc/network/if-up.d/ap

echo "Setting SSID info to the mediatek driver"

if [ -f /etc/Wireless/RT2870AP/RT2870AP.dat ]; then
  sed -i "s/SSID=orangeBox/SSID=${SSID_NAME}/" /etc/Wireless/RT2870AP/RT2870AP.dat
  sed -i "s/WPAPSK=not4youreyes/WPAPSK=${SSID_PASSWORD}/" /etc/Wireless/RT2870AP/RT2870AP.dat
fi


echo "Installing arm verison of hostapd..."
./scripts/install/hostapdinst.sh
