## for now - orange pi is supported.
HARDWARE=orangepipc
## Put your hostname here
HOSTNAME=orangebox
## Active user (orangepi default one for orangepi, pi - for raspberry pi)
USER=orangepi
## SSID name
SSID_NAME=orangeBox
## SSID password
SSID_PASSWORD=not4youreyes
## IP adddress
IP_ADDRESS=192.168.110.1
IP_NETMASK=255.255.255.0
IP_NETWORK=192.168.110.0
IP_BROADCAST=192.168.110.255
INTERFACE=wlan0
DHCP_RANGE="192.168.110.50,192.168.110.150,255.255.255.0,12h"
HOSTADDR="/my.torbox/${IP_ADDRESS}"


## below are settings of WEBUI. Don't change them, until you don't know what are you doing
WEBUI_USER=webui
WEBUI_LOCATION=/opt/webui

## below are settings of i2p. Don't change them, until you don't know, what are you doing
I2P_USER=${USER}
I2P_LOCATION=/opt/i2p

##Use offical repo tor
USE_STOCK_TOR=1


