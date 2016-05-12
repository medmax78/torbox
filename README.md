# Orange TorBOX
This project is a  set of installer scripts, which will allow to setup
anonymizing TOR middlebox and I2p proxy quickly and easily.

## System requirements
Current version is targeted on OrangePI H3 hardware, Raspberry Pi 1 and 2 hardware and assumes the following:

* You run Debian-based OS
* You own compatible USB wifi dongle (see list below)
* Your "Internets" are connected via Ethernet cable and DHCP is possible for eth0 wired interface

Raspberry  support is planned and will be
implemented, as long as I'll get my hands on this hardware.

Currently supported hardware platforms:

|Board|Hardware target name |Remarks|
|:---|:---|:---|
|Orange Pi PC|orangepipc|
|Orange Pi One|orangepipc|
|Raspberry Pi 1 (armv6)|raspberrypi1|Only Realtek WiFi is supported|
|Raspberry Pi 2 (armv7)|raspberrypi2|Only Realtek WiFi is supported|


## Hardware requirements
### Media preparation
#### Pre-made image
##### For Orange Pi PC and Orange Pi One
Base image is build of OrangePI PC (AllWinner H3) with a modified Loboris kernel.
##### For Raspberry Pi 1 and Raspberry Pi 2
Base image is derived from Mininian Image (https://minibianpi.wordpress.com/) - it resized to 2GB and swap partition added. 

It requires 2GB microSD card.

_Different manufacturers use diffrent "2GB" size interpretation. In case you receive
"out of space" error, change manufacturer or use 4GB card. They are cheap._

Prepared image can be downloaded here:
##### For Orange Pi PC and Orange Pi One
http://znoxx.me/cgi-bin/url.cgi?1Y4dQxp

##### For Raspberry Pi 1 and Raspberry Pi 2
http://znoxx.me/cgi-bin/url.cgi?1ZBXVXV

Unpack it and "dd" to your microSD. Or use Win32DiskImager to write unpacked image on
Windows-based systems.
##### For Orange Pi PC and Orange Pi One
Mount first VFAT partition (or just re-insert your card on Windows) and copy your
hardware-script.bin to script.bin.

Initial image is targeted for Orange Pi PC. If you want to use it with Orange Pi One, you __have to__ do this. 

##### For Raspberry Pi 1 and Raspberry Pi 2
No additional actions needed - just boot your device


#### Other images
You can adapt your own image, you use.
Things to keep in mind:

* eth0 interface should be configured and set to use DHCP
* Network Manager should be disabled or even completely uninstalled. Or it should not manage your WiFi.
* You will need some libnl packages - consider installing libnl3-200 and libnl-genl-3-200 to allow hostapd operation.

Now test it - insert SD, then power on and try to login to your system via SSH.

### Supported Wifi dongles

I decided to suppport cheapest dongles "out of the box", which can run in AP mode.

* 0bda:0179 Realtek Semiconductor Corp. RTL8188ETV Wireless LAN 802.11n Network Adapter (http://znoxx.me/cgi-bin/url.cgi?1qZe7Yl)
* 0bda:8179 Realtek Semiconductor Corp. RTL8188EUS 802.11n Wireless Network Adapter (http://znoxx.me/cgi-bin/rurl.cgi?1UYTCqW)
* 148f:7601 Ralink Technology, Corp. MT7601U Wireless Adapter (http://znoxx.me/cgi-bin/rurl.cgi?1R2y3op) **NOT SUPPORTED IN RASPBERRY PI VERSIONS**

However, it's not a "final" list. Other dongles are supported too, just make sure they can run with hostapd driver __"nl80211"__ or __"rtl871xdrv"__. Or even without hostapd, like listed Ralink/MTK one.

## Starting the installation
Boot in your freshly prepared SD-card.

Login for OrangePI is orangepi/orangepi, for Raspberry Pi - pi/raspberry.

Login via ssh and run following commands:

* `sudo apt-get update`
* `sudo apt-get install git`
* `git clone https://github.com/znoxx/torbox.git`

After everything is downloaded:

* `cd torbox`

Now adjust __config.inc__ to your needs.

What to tweak:

* USER - For Orange Pi PC and Orange Pi One if you use "orangepi" user, better leave it. Same for "pi" user on Raspberry. If you use your own - change the name.
* SSID_NAME - name of your future WiFi.
* SSID_PASSWORD - WiFi password
* IP_xxx and DHCP_xxx- things that will go to interface file. If you have special requirements for IP to use, change them
* WEBUI_xxx WEB UI related stuff. User and path. Think twice before changing, since default settings should be ok for everyone.
* I2P_USER - don't think you should change it
* I2P_LOCATION - where I2P will be installed.
* USE_STOCK_TOR - this indicates, that TOR from official debian/ubuntu repo will be installed. In case you want one bleeding edge - set to "0" and torproject repos will be used. But keep in mind, that you will may have problems with systemd compatibility.
* HOSTADDR - this one allow you to access system via name in browser. It is generated from "hostname", so in example you will have http://orangepi.torbox:3000. If your device in _direct_ mode - you can access it by name. 

When you are done, proceed with

* `sudo ./installer.sh`

It's completely automated and will install and configure software and also set __wlan0__ interface.
Installer runs significant amount of time, since it's downloads packages, installs node.js for Web UI and Java 8 from Oracle repository.

## Testing the system
After you are done, insert your WiFi dongle and powercycle the platform.
After boot, your new Torred and I2Ped Access point will be visible.
Connect to it, using the SSID and password, you set up on previous step.
Being connected to your WiFi, open any URL in your browser. 
Now check URL http://IP_ADDRESS:3000 (or hostname http://yourhost.torbox:3000) - the IP or name you set in config. WEB UI should be accessible.
Default username/password is "orangepi/orangepi". You can change them from the WebUI.
Change mode to TOR or Privoxy and open http://check.torproject.org - and if everything is ok, you will see confirmation, that TOR is configured.

## Modes of operation
Device has generally 3 modes of operation:


* _TOR_ - all traffic from __WiFi clients__ is routed through TOR
* _PRIVOXY_ - all traffic from __WiFi clients__ is routed thorough TOR and PRIVOXY. You can set some privoxy rules to get rid of ads and annoying "Like" buttons, for example .Better check with official privoxy documentation (http://privoxy.org)
* _DIRECT_ - All traffic is routed directly without TOR or/and privoxy, but you can still setup http/https proxy in your browser, pointing IP_ADDRESS and port 8118 to use anonymous internet browsing.

Those settings are switched via WebUI. Remember that traffic from torbox itself is not routed via TOR. E.g. running "apt-get" on system will go to internet directly. So, again - Wifi clients only are torred.


## Using the I2P
After boot, run the I2P daemon via WebUI. In couple of minutes, you will be ready to connect to http://IP_ADDRESS:7657. Feel free to tweak settings and play.
To access I2P site - set up a proxy on your system, pointing to IP_ADDRESS:8118 and after some time you will be able to open .i2p websites.

## Finalizing the installation
After things are tested and you are happy, run

* `sudo ./finalize_inst.sh`
* Optional: `sudo apt-get upgrade`

In project dir. It will adjust the firewall to close the access from outer world and clean some temp files.

From this moment, you can only SSH your system via IP_ADDRESS:22 when you are connected to your fresh torred wifi network.

## Special note about drivers

Bundled MediaTek/Ralink driver DOES NOT use hostapd to provide an access point. So if you want to change AP settings - change them in appropriate place. For Mediatek - in driver settings. For others - /etc/hostapd/hostapd.conf. During the install they are applied in both.
So if your dongle is Mediatek - hostapd silently fails on start, but you still do have an access point via driver.
For other dongles - hostapd is used.
For Raspberry Pi 1 and 2  - **Realtek is only supported**. In future - Raspberry Pi 3 _probably_ will use onboard WiFi. 

## Using other WiFi dongles

To use some other WiFi adapters, keep in mind following:

* You should be sure that you have the appropriate driver and firmware if needed
* You have to change /etc/hostapd/hostapd.conf
* Better to rename your interface to wlan0 to make things running smoothly

I've tested some TP-Link drivers successfully, so no limitations here.


##### For OrangePi PC and Orange Pi One
_Beware, that installer script moves some Realtek default drivers to /lib/modules-disabled_. Better to check this dir, when you run into a problem with a WiFi dongle.

## Using other plarforms
Support of Raspberry Pi 3 is planned, as soon as it will be obtained somewhere.
Generally in "hardware" folder there should be subfolder "raspberrypi3" for example with some platform/kernel specific things like drivers and scripts, reporting temperature.
_powersave.sh_ is generated with a help of powertop.

## Thanks and references
Thanks to Loboris for providing working and stable kernels for OrangepPI http://www.orangepi.org/orangepibbsen/forum.php?mod=viewthread&tid=342

Thanks to bronco for fixing temperature issues on OrangePi http://www.orangepi.org/orangepibbsen/forum.php?mod=viewthread&tid=785

Original hostapd http://w1.fi/hostapd/  with Realtek patch https://github.com/pritambaral/hostapd-rtl871xdrv used in system and build for ARM arch.

Minibian (https://minibianpi.wordpress.com) with some updates is used for Raspberry Pi images.

Drivers bundled:

* Realtek 8188eu - https://github.com/lwfinger/rtl8188eu (native staging driver is used for Raspberry Pi)
* Mediatek 7601 AP mode - https://github.com/eywalink/mt7601u (not for Raspberry Pi boards)

## Disclaimer
Things to keep in mind

* Scripts are tested and supposed to be run ok. However, there is no warranty, that it will work for you or suite particular needs.
* Also I'm not responsible for damage of any kind, caused directly or indirectly to your hardware or privacy.
* TOR and I2P are not a silver bullet and designed to protect your privacy. The particular usage requires some fundamental knowledge.