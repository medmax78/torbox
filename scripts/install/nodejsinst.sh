#!/bin/sh
apt-get -y install curl
curl --silent --location https://deb.nodesource.com/setup_5.x | sudo bash -
apt-get -y install nodejs