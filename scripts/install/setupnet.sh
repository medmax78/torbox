#!/bin/sh
. ./config.inc
echo "Setting up network..."


echo "Setting network rules to rename all wireless interfaces to wlan0..."

cp ./scripts/etc/udev/udev.d/persistentnet /etc/udev/udev.d/persistentnet

echo "Setting wlan0 interface..."

sed ...

apt-get update
apt-get -y dnsmasq

echo "Applying dnsmasq conf rules..."

sed ...

echo "Installing arm verison of hostapd..."
echo "Deeecrunching"
echo "Copying binary..."
echo "Copying config..."
echo "Applying config settings"
echo "Copying init.d script"
systemctl enable  hostapd
systemctl start hostapd


