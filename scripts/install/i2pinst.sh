#!/bin/sh
. ./config.inc
I2PURL=http://download.i2p2.de/releases/0.9.25/i2pinstall_0.9.25.jar
I2PJAR=i2pinstall_0.9.25.jar

apt-get update > /dev/null
apt-get -y install unzip expect > /dev/null
sed -i "s~I2P_LOCATION=/opt/i2p~I2P_LOCATION=${I2P_LOCATION}~" /usr/local/bin/starti2p.sh
wget -t0 -c ${I2PURL}
mkdir ${I2P_LOCATION}
expect <<EOF
spawn  java -jar ${I2PJAR} -console
expect "press 1 to continue, 2 to quit, 3 to redisplay" { send "1\r" }
expect "Select target path*\r" {send "${I2P_LOCATION}\r"}
expect "press 1 to continue, 2 to quit, 3 to redisplay\r" { send "1\r"}
expect "*Console installation done*" {send "\r"} 
EOF
chown -R ${I2P_USER} ${I2P_LOCATION}
chmod a+x ${I2P_LOCATION}/*.sh
mkdir unpackedjar
mv ${I2P_LOCATION}/lib/jbigi.jar ./unpackedjar
cd unpackedjar
unzip jbigi.jar
su -c "cp libjbigi-linux-armv6.so ${I2P_LOCATION}/libjbigi.so" ${I2P_USER}
cd ..
rm -rf unpackedjar
su -c "/usr/local/bin/starti2p.sh" ${I2P_USER}
sleep 20
su -c "/usr/local/bin/stopi2p.sh" ${I2P_USER}
su -c "sed -i 's/clientApp.0.args=7657\s*::1,127.0.0.1\s*.\/webapps\//clientApp.0.args=7657 0.0.0.0 .\/webapps\//' /home/${I2P_USER}/.i2p/clients.config" ${I2P_USER}
su -c "sed -i 's/clientApp.4.startOnLoad=true/clientApp.4.startOnLoad=false/'  /home/${I2P_USER}/.i2p/clients.config" ${I2P_USER}
su -c "/usr/local/bin/starti2p.sh" ${I2P_USER}
rm -rf ./$I2PJAR
cp ./scripts/etc/init.d/i2p /etc/init.d/i2p
sed -i "s/USER=orangepi/USER=${I2P_USER}/" /etc/init.d/i2p
sed -i "s~DAEMON=/opt/i2p/i2prouter~DAEMON=${I2P_LOCATION}/i2prouter~" /etc/init.d/i2p
chmod a+x /etc/init.d/i2p
update-rc.d i2p defaults
update-rc.d i2p enable
/etc/init.d/i2p start
echo "Sleeping for 30 seconds to let i2p start/settle..."
sleep 30
update-rc.d i2p disable
echo "I2P installation finised, hopefully without errors..."
