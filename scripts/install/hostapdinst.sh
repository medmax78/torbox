#!/bin/sh
. ./config.inc

echo "Installing hostapd..."
apt-get update -y
apt-get install -y haveged
tar -xzvf ./hostapd/hostapd_arm.tar.gz -C /usr/local/bin
mkdir /etc/hostapd
cp ./scripts/etc/hostapd/hostapd.conf /etc/hostapd/hostapd.conf
echo "Applying hostapd conf..."
sed -i "s/ssid=orangeBox/ssid=${SSID_NAME}/" /etc/hostapd/hostapd.conf
sed -i "s/wpa_passphrase=not4youreyes/wpa_passphrase=${SSID_PASSWORD}/" /etc/hostapd/hostapd.conf
echo "Adding to init.d..."
cp ./scripts/etc/init.d/hostapd /etc/init.d/hostapd
update-rc.d hostapd defaults
update-rc.d hostapd enable


