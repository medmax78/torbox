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


CURRENTDIR=`pwd`

cd ${WEBUI_LOCATION}

npm install

cd $CURRENTDIR

chown -R ${WEBUI_USER}:${WEBUI_USER} ${WEBUI_LOCATION}

echo "Enabling webui"

cp ./scripts/etc/init.d/webui /etc/init.d/webui

echo "Applying settings to webui script"
sed -i "s~WEBUI_ROOT=/opt/webui~WEBUI_ROOT=${WEBUI_LOCATION}~" /etc/init.d/webui
sed -i "s/WEBUI_GROUP=webui/WEBUI_GROUP=${WEBUI_USER}/" /etc/init.d/webui
sed -i "s/WEBUI_USER=webui/WEBUI_USER=${WEBUI_USER}/" /etc/init.d/webui


update-rc.d webui defaults
update-rc.d webui enable

/etc/init.d/webui start





