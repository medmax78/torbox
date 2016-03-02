#!/bin/sh
. ./config.inc
./scripts/install/nodejsinst.sh

echo "Installing sudo..."
apt-get -y install sudo

echo "Adding user ${WEBUI_USER} to system and adding it to sudoers..."
useradd ${WEBUI_USER} -s /bin/false

echo " " >>/etc/sudoers
cat ./scripts/etc/sudoers.example >>/etc/sudoers

mkdir ${WEBUI_LOCATION}

echo "Copying Web UI script to location..."

cp -r ./webui/* ${WEBUI_LOCATION}

chown -R ${WEBUI_USER}:${WEBUI_USER} ${WEBUI_LOCATION}

CURRENTDIR=`pwd`

cd ${WEBUI_LOCATION}

su -c 'npm install' ${WEBUI_USER}

echo "Enabling webui"

cd $CURRENTDIR

cp ./scripts/etc/init.d/webui /etc/init.d/webui

systemctl enable webui
systemctl start webui



