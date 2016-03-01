#!/bin/sh
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
echo "Starting installer..."

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
echo "Copying needed scripts to /usr/local/bin..."
chmod a+x ./scripts/usr/local/bin/*
cp ./scripts/usr/local/bin/* /usr/local/bin/

##
echo "Installing i2p.."
./scripts/install/i2pinst.sh

##
echo "Installing nescessary hardware modules..."
. ./config.inc


