#!/bin/sh
. ./config.inc
I2PURL=http://download.i2p2.de/releases/0.9.24/i2pinstall_0.9.24.jar
I2PJAR=i2pinstall_0.9.24.jar

apt-get update
apt-get -y install unzip
wget -t0 -c ${I2PURL}
mkdir ${I2P_LOCATION}
chown ${I2P_USER} ${I2P_LOCATION}
echo "ENTER ${I2P_LOCATION} as installation path!"
su -c "java -jar ./$I2PJAR -console" ${I2P_USER}
mkdir unpackedjar
mv ${I2P_LOCATION}/lib/jbigi.jar ./unpackedjar
cd unpackedjar
unzip jbigi.jar
su -c "cp libjbigi-linux-armv6.so /opt/i2p/libjbigi.so" ${I2P_USER}
cd ..
rm -rf unpackedjar
su -c "/usr/local/bin/starti2p.sh" ${I2P_USER}
sleep 20
su -c "/usr/local/bin/stopi2p.sh" ${I2P_USER}
su -c "sed -i 's/clientApp.0.args=7657\s*::1,127.0.0.1\s*.\/webapps\//clientApp.0.args=7657 0.0.0.0 .\/webapps\//' /home/orangepi/.i2p/clients.config" ${I2P_USER}
su -c "sed -i 's/clientApp.4.startOnLoad=true/clientApp.4.startOnLoad=false/'  /home/orangepi/.i2p/clients.config" ${I2P_USER}
su -c "/usr/local/bin/starti2p.sh" ${I2P_USER}
rm -rf ./$I2PJAR
cp ./scripts/etc/init.d/i2p /etc/init.d/i2p
sed -i "s/USER=orangepi/USER=${I2P_USER}/" /etc/init.d/i2p
chmod a+x /etc/init.d/i2p
systemctl enable i2p
echo "Sleeping for 30 seconds to let i2p start/settle..."
sleep 30
systemctl disable i2p
echo "I2P installation finised, hopefully without errors..."
