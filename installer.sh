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


if [ ${HARDWARE} = "orangepipc" ]; then
        echo "Fixing thermal problems..."
        /usr/local/bin/fix-thermal-problems.sh
else
        echo "Not an OrangePI PC. Skipping fix thermal problems.."
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
echo "rtutil7601Uap" >>/etc/modules
echo "mt7601Uap" >>/etc/modules
echo "rtnet7601Uap" >>/etc/modules

cp -r ./hardware/${HARDWARE}/${KERNEL_VERSION}/wifi/etc/* /etc/
cp -r ./hardware/${HARDWARE}/${KERNEL_VERISON}/wifi/firmware/* /lib/firmware/
echo "Disabling old 8188eu modules"
mkdir /lib/modules-disabled
mv /lib/modules/3.4.39-02-lobo/kernel/drivers/net/wireless/rtl8188eu /lib/modules-disabled/
depmod -a

echo "Setting up network and access point..."
./scripts/install/setupnet.sh

