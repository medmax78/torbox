#!/bin/sh
. ./config.inc
echo "Setting up network..."


echo "Setting network rules to rename all wireless interfaces to wlan0..."

cp ./scripts/etc/udev/rules.d/70-persistent-net.rules /etc/udev/rules.d/70-persistent-net.rules

echo "Setting wlan0 interface..."

echo "auto wlan0" >>/etc/network/interfaces.d/wlan0
echo "iface wlan0 inet static"
echo "       address $IP_ADDRESS" >>/etc/network/interfaces.d/wlan0
echo "       netmask $IP_NETMASK" >>/etc/network/interfaces.d/wlan0
echo "       network $IP_NETWORK" >>/etc/network/interfaces.d/wlan0
echo "       broadcast $IP_BROADCAST" >>/etc/network/interfaces.d/wlan0

apt-get update
apt-get -y install iptables
apt-get -y install dnsmasq

echo "Applying dnsmasq conf rules..."

echo "interface=${INTERFACE}" >> /etc/dnsmasq.conf
echo "dhcp-range=${DHCP_RANGE}" >> /etc/dnsmasq.conf
echo "address=${HOSTADDR}" >> /etc/dnsmasq.conf

echo "Setting SSID info to the mediatek driver"

if [ -f /etc/Wireless/RT2870AP/RT2870AP.dat ]; then
  sed -i "s/SSID=orangeBox/SSID=${SSID_NAME}/" /etc/Wireless/RT2870AP/RT2870AP.dat
  sed -i "s/WPAPSK=not4youreyes/WPAPSK=${SSID_PASSWORD}/" /etc/Wireless/RT2870AP/RT2870AP.dat
fi


echo "Installing arm verison of hostapd..."
echo "Deeecrunching"
echo "Copying binary..."
echo "Copying config..."
echo "Applying config settings"
echo "Copying init.d script"
#systemctl enable  hostapd
#systemctl start hostapd


