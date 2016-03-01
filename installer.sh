#!/bin/sh

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
echo "Starting installer..."
. ./config.inc

##
echo "Copying needed scripts to /usr/local/bin..."
chmod a+x ./scripts/usr/local/bin/*
cp ./scripts/usr/local/bin/* /usr/local/bin/


if [ "$HARDWARE" == "orangepipc" ]; then
	echo "Fixing thermal problems..."
    
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
./scriprs/install/java8inst.sh



##
echo "Installing i2p.."
./scripts/install/i2pinst.sh

##
echo "Installing nescessary hardware modules..."
KERNEL_VERSION=`uname -r`

mkdir /lib/modules/${KERNEL_VERSION}/wifiap
cp ./hardware/${HARDWARE}/${KERNEL_VERSION}/*.ko /lib/modules/${KERNEL_VERSION}/wifiap

echo "8188eu" >>/etc/modules
echo "rtutil7601Uap" >>/etc/modules
echo "mt7601Uap" >>/etc/modules
echo "rtnet7601Uap" >>/etc/modules




