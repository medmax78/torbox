#!/bin/sh
. ./config.inc

echo "Installing hostapd..."
apt-get update -y >/dev/null
apt-get install -y haveged >/dev/null

if [ ${HARDWARE} = "raspberrypi1" ]; then
  tar -xzvf ./hostapd/hostapd_pi_arm6.tar.gz -C /usr/local/bin
else 
  tar -xzvf ./hostapd/hostapd_arm.tar.gz -C /usr/local/bin
fi


mkdir /etc/hostapd
cp ./scripts/etc/hostapd/hostapd.conf /etc/hostapd/hostapd.conf
echo "Applying hostapd conf..."
sed -i "s/ssid=orangeBox/ssid=${SSID_NAME}/" /etc/hostapd/hostapd.conf
sed -i "s/wpa_passphrase=not4youreyes/wpa_passphrase=${SSID_PASSWORD}/" /etc/hostapd/hostapd.conf

if [ ${HARDWARE} = "raspberrypi3" ] || [ ${HARDWARE} = "orangepi0" ]; then
  sed -i "s/driver=rtl871xdrv/#driver=rtl871xdrv/" /etc/hostapd/hostapd.conf
  sed -i "s/#driver=nl80211/driver=nl80211/" /etc/hostapd/hostapd.conf
fi

echo "Adding to init.d..."
cp ./scripts/etc/init.d/hostapd /etc/init.d/hostapd
update-rc.d hostapd defaults
update-rc.d hostapd enable

