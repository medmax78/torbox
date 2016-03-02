#!/bin/sh
I2P_LOCATION=/opt/i2p
/usr/local/bin/stopi2p.sh
sleep 3
${I2P_LOCATION}/runplain.sh
sleep 3

