#!/bin/sh
. ./config.inc

echo "Installing hostapd..."
apt-get install -y haveged >/dev/null

if [ ${HARDWARE} = "orangepi0" ]; then
  apt-get -y purge hostapd >/dev/null
fi

if [ ${HARDWARE} = "raspberrypi1" ]; then
  tar -xzvf ./hostapd/hostapd_pi_arm6.tar.gz -C /usr/local/bin
else 
  tar -xzvf ./hostapd/hostapd_arm.tar.gz -C /usr/local/bin
fi


mkdir /etc/hostapd
cp ./scripts/etc/hostapd/hostapd-torbox.conf /etc/hostapd/hostapd-torbox.conf
echo "Applying hostapd conf..."
sed -i "s/ssid=orangeBox/ssid=${SSID_NAME}/" /etc/hostapd/hostapd-torbox.conf
sed -i "s/wpa_passphrase=not4youreyes/wpa_passphrase=${SSID_PASSWORD}/" /etc/hostapd/hostapd-torbox.conf

if [ ${HARDWARE} = "raspberrypi3" ] || [ ${HARDWARE} = "orangepi0" ]; then
  sed -i "s/driver=rtl871xdrv/#driver=rtl871xdrv/" /etc/hostapd/hostapd-torbox.conf
  sed -i "s/#driver=nl80211/driver=nl80211/" /etc/hostapd/hostapd-torbox.conf
fi

echo "Adding to systemd..."
cp ./scripts/etc/systemd/system/hostapd-torbox.service /etc/systemd/system/hostapd-torbox.service
systemctl daemon-reload
systemctl enable hostapd-torbox

