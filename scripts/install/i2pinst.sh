#!/bin/sh
I2PURL=http://download.i2p2.de/releases/0.9.24/i2pinstall_0.9.24.jar
I2PJAR=i2pinstall_0.9.24.jar

apt-get update
apt-get -y install unzip
wget -t0 -c $I2PURL
mkdir /opt/i2p
chown orangepi:orangepi /opt/i2p
echo "ENTER /opt/i2p as installation path!"
su -c "java -jar ./$I2PJAR -console" orangepi
mkdir unpackedjar
mv /opt/i2p/lib/jbigi.jar ./unpackedjar
cd unpackedjar
unzip jbigi.jar
su -c "cp libjbigi-linux-armv6.so /opt/i2p/libjbigi.so" orangepi
cd ..
rm -rf unpackedjar
su -c "/usr/local/bin/starti2p.sh" orangepi
sleep 10
su -c "/usr/local/bin/stopi2p.sh" orangepi
su -c "sed -i 's/clientApp.0.args=7657\s*::1,127.0.0.1\s*.\/webapps\//clientApp.0.args=7657 0.0.0.0 .\/webapps\//' /home/orangepi/.i2p/clients.config" orangepi
su -c "sed -i 's/clientApp.4.startOnLoad=true/clientApp.4.startOnLoad=false/'  /home/orangepi/.i2p/clients.config" orangepi
su -c "/usr/local/bin/starti2p.sh" orangepi
rm -rf ./$I2PJAR
