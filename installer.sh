#!/bin/sh

if [ "$(id -u)" != 0 ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi


echo "Starting installer..."
. ./config.inc

##
echo "Copying needed scripts to /usr/local/bin..."
chmod a+x ./scripts/usr/local/bin/*
cp ./scripts/usr/local/bin/* /usr/local/bin/
chmod a+x ./hardware/${HARDWARE}/usr/local/bin/*
cp -r ./hardware/${HARDWARE}/usr/local/bin/* /usr/local/bin/


if [ -f /usr/local/bin/powersave.sh ]; then
  echo "Setting powersave script..."
  cp ./scripts/etc/init.d/powersave /etc/init.d/powersave
  update-rc.d powersave defaults
  update-rc.d powersave enable
fi

##
echo "Installing tor..."
./scripts/install/torinst.sh

##
echo "Installing privoxy..."
./scripts/install/privoxyinst.sh

##
echo "Installing Java 8 for ARM..."
./scripts/install/java8inst.sh


##
echo "Installing i2p.."
./scripts/install/i2pinst.sh

##
echo "Installing nescessary hardware modules..."
KERNEL_VERSION=`uname -r`

mkdir /lib/modules/${KERNEL_VERSION}/wifiap
cp ./hardware/${HARDWARE}/${KERNEL_VERSION}/wifi/*.ko /lib/modules/${KERNEL_VERSION}/wifiap


if [ ${HARDWARE} = "orangepipc" ]; then
        echo "Enabling crypto module"
        echo "ss" >>/etc/modules
fi


echo "8188eu" >>/etc/modules

if [ ${HARDWARE} = "orangepipc" ]; then
  echo "rtutil7601Uap" >>/etc/modules
  echo "mt7601Uap" >>/etc/modules
  echo "rtnet7601Uap" >>/etc/modules
fi

cp -r ./hardware/${HARDWARE}/${KERNEL_VERSION}/wifi/etc/* /etc/
cp -r ./hardware/${HARDWARE}/${KERNEL_VERSION}/wifi/firmware/* /lib/firmware/

if [ ${HARDWARE} = "raspberrypi2" ]; then
  wget https://github.com/porjo/mt7601/raw/master/src/mcu/bin/MT7601.bin -O /lib/firmware/mt7601u.bin
fi

if [ ${HARDWARE} = "orangepipc" ]; then
  echo "Disabling old 8188eu modules"
  mkdir /lib/modules-disabled
  mv /lib/modules/${KERNEL_VERSION}/kernel/drivers/net/wireless/rtl8188eu /lib/modules-disabled/
fi

depmod -a

echo "Setting up network and access point..."
./scripts/install/setupnet.sh

echo "Installing WebGUI..."
./scripts/install/webuiinst.sh


