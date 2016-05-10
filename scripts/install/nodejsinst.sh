#!/bin/sh
. ./config.inc

if [ ${HARDWARE} = "orangepipc" ]  || [ ${HARDWARE} = "raspberrypi2" ]; then
  apt-get -y install curl > /dev/null
  curl --silent --location https://deb.nodesource.com/setup_5.x | sudo bash -
  apt-get -y install nodejs > /dev/null
fi

if [ ${HARDWARE} = "raspberrypi1" ]; then
 wget http://node-arm.herokuapp.com/node_latest_armhf.deb
 dpkg -i node_latest_armhf.deb
 ln -s /usr/local/bin/node /usr/bin/node
 ln -s /usr/local/bin/npm /usr/bin/npm
 rm -f node_latest_armhf.deb
fi

