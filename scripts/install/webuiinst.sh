#!/bin/sh
. ./config.inc
./scripts/install/nodejsinst.sh

echo "Installing sudo..."
apt-get -y install sudo > /dev/null

echo "Adding user ${WEBUI_USER} to system and adding it to sudoers..."
useradd ${WEBUI_USER} -s /bin/false

echo " " >>/etc/sudoers

echo "${WEBUI_USER}   ALL = (root) NOPASSWD: /sbin/shutdown" >>/etc/sudoers
echo "${WEBUI_USER}   ALL = (root) NOPASSWD: /usr/local/bin/all_tor.sh" >>/etc/sudoers
echo "${WEBUI_USER}   ALL = (root) NOPASSWD: /usr/local/bin/cputemp.sh" >>/etc/sudoers
echo "${WEBUI_USER}   ALL = (root) NOPASSWD: /etc/init.d/i2p" >>/etc/sudoers
echo "${WEBUI_USER}   ALL = (root) NOPASSWD: /bin/systemctl start i2p-torbox" >>/etc/sudoers


mkdir ${WEBUI_LOCATION}

echo "Copying Web UI script to location..."

cp -r ./webui/* ${WEBUI_LOCATION}


CURRENTDIR=`pwd`

cd ${WEBUI_LOCATION}

npm install

cd $CURRENTDIR

chown -R ${WEBUI_USER}:${WEBUI_USER} ${WEBUI_LOCATION}

echo "Enabling webui"

cp ./scripts/etc/systemd/system/webui-torbox.service /etc/systemd/system/webui-torbox.service

echo "Applying settings to webui script"
sed -i "s~WEBUI_ROOT~${WEBUI_LOCATION}~" /etc/systemd/system/webui-torbox.service
sed -i "s/WEBUI_GROUP/${WEBUI_USER}/" /etc/systemd/system/webui-torbox.service
sed -i "s/WEBUI_USER/${WEBUI_USER}/" /etc/systemd/system/webui-torbox.service


systemctl daemon-reload
systemctl enable webui-torbox

systemctl start webui-torbox
sync






