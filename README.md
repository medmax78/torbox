#  Orange TorBOX
This project is a  set of installer scripts, which will allow to setup
anonymizing TOR middlebox and I2p proxy quickly and easily.

After installation your \*Pi device will get functionality of Access Point, which *clients* will connect to Internet through TOR completely. It supports 3 modes of 
operation: "all through TOR", "all through TOR+Privoxy (configurable web proxy with ads cutter)" and "direct mode". Also device will allow to run I2P daemon and
access .i2p sites. In this case you have to setup http-proxy on your device.

End-user devices ( Access Point clients) do not need TOR bundle to be installed - they work fully transparent via your new Access Point.

[Russian Description/Описание на русском](README.RU.md)

## System requirements
Current version is targeted for some OrangePI H3 hardware (Orange Pi PC, Orange Pi One), Raspberry Pi 1,2 and 3 hardware and assumes the following:

* You run Debian-based OS with systemd enabled/working (Debian 8+)
* You own compatible USB wifi dongle (see list below)
* Your "Internets" are connected via Ethernet cable and DHCP is possible for eth0 wired interface

There are still some new Orange Pi's to support, but this may be seriously postponed for some "vNext" version with major improvements. 

Currently supported hardware platforms:

|Board|Hardware target name |Remarks|
|:---|:---|:---|
|Orange Pi PC|orangepipc|
|Orange Pi One|orangepipc|
|Orange Pi Zero|orangepi0|Only built-in wifi supported|
|Raspberry Pi 1 (armv6)|raspberrypi1|Only Realtek WiFi is supported|
|Raspberry Pi 2 (armv7)|raspberrypi2|Only Realtek WiFi is supported|
|Raspberry Pi 3 (in armv7 mode)|raspberrypi3|Native RPI 3 WiFi only - no external dongle needed|


## Hardware requirements
### Media preparation
#### Pre-made image
##### For Orange Pi PC and Orange Pi One
Base image is build of OrangePI PC (AllWinner H3) with a modified Loboris kernel.
##### For Orange Pi Zero
Base image is Armbian 5.24. Standart update procedure should work correctly. Actual version is tested on 256MB board, so 512MB version should work ok also.
##### For Raspberry Pi 1, Raspberry Pi 2 and Raspberry Pi 3
Base image is derived from Mininian Image (https://minibianpi.wordpress.com/) - it resized to 2GB and swap partition added. 

It requires 2GB microSD card.

_Different manufacturers use diffrent "2GB" size interpretation. In case you receive
"out of space" error, change manufacturer or use 4GB card. They are cheap._

Prepared image can be downloaded here:
##### For Orange Pi PC and Orange Pi One

Located [here](http://znoxx.me/cgi-bin/url.cgi?2jjcGns)

##### For Orange Pi Zero
Located [here](http://znoxx.me/cgi-bin/url.cgi?2j55knh)

##### For Raspberry Pi 1, Raspberry Pi 2 and Raspberry Pi 3
Located [here](http://znoxx.me/cgi-bin/url.cgi?2jjfwJb)

Unpack it and "dd" to your microSD. Or use Win32DiskImager to write unpacked image on
Windows-based systems.
##### For Orange Pi PC and Orange Pi One
Mount first VFAT partition (or just re-insert your card on Windows) and copy your
hardware-script.bin to script.bin.

Initial image is targeted for Orange Pi PC. If you want to use it with Orange Pi One, you __have to__ do this. 

[![Orange Pi PC](docpics/orangepipc.png)](http://znoxx.me/cgi-bin/url.cgi?1NS4Fcm)

##### For Raspberry Pi 1,2,3 and Orange Pi Zero
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

* 0bda:0179 Realtek Semiconductor Corp. RTL8188ETV Wireless LAN 802.11n Network Adapter

[![Realtek](docpics/rtlwifi.png)](http://znoxx.me/cgi-bin/url.cgi?1qZe7Yl)

* 0bda:8179 Realtek Semiconductor Corp. RTL8188EUS 802.11n Wireless Network Adapter (http://znoxx.me/cgi-bin/rurl.cgi?1UYTCqW)
* 148f:7601 Ralink Technology, Corp. MT7601U Wireless Adapter 

[![MTK](docpics/mtkwifi.png)](http://znoxx.me/cgi-bin/rurl.cgi?1R2y3op)

**MTK IS NOT SUPPORTED IN RASPBERRY PI VERSIONS**

Also supported: 

* Onboard Raspberry Pi 3 Wifi (Broadcom)
* Onboard Orange Pi Zero (AllWinner ?)

However, it's not a "final" list. Other dongles are supported too, just make sure they can run with hostapd driver __"nl80211"__ or __"rtl871xdrv"__. Or even without hostapd, like listed Ralink/MTK one.

## Starting the installation
Boot in your freshly prepared SD-card.

Login for OrangePI is orangepi/orangepi, for Raspberry Pi - pi/raspberry.

Login via SSH and run following commands:

* `sudo apt-get update`
* `sudo apt-get install git`
* `git clone https://github.com/znoxx/torbox.git`

After everything is downloaded:

* `cd torbox`

Now adjust __config.inc__ to your needs.

What to tweak in addition to selection of "hardware target" (see table above):

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
For Orange Pi Zero - onboard WiFi chip **only**. Realtek dongle also can be used, depends on driver availability.
For Raspberry Pi 1 and 2  - **Realtek is only supported**. 
For Raspberry Pi 3 - onboard Broadcom **only**. You still can support Realtek like it done for Rpi2, check script internals.

## Using other WiFi dongles

To use some other WiFi adapters, keep in mind following:

* You should be sure that you have the appropriate driver and firmware if needed
* You have to change /etc/hostapd/hostapd.conf
* Better to rename your interface to wlan0 to make things running smoothly

I've tested some TP-Link drivers successfully, so no limitations here.


##### For OrangePi PC and Orange Pi One
_Beware, that installer script moves some Realtek default drivers to /lib/modules-disabled_. Better to check this dir, when you run into a problem with a WiFi dongle.

## Using other plarforms
Generally, you need to create new hardware target and compile nescessary hardware drivers.

## Thanks and references
Thanks to Loboris for providing working and stable kernels for OrangepPI http://www.orangepi.org/orangepibbsen/forum.php?mod=viewthread&tid=342

Thanks to bronco for fixing temperature issues on OrangePi http://www.orangepi.org/orangepibbsen/forum.php?mod=viewthread&tid=785

Original hostapd http://w1.fi/hostapd/  with Realtek patch https://github.com/pritambaral/hostapd-rtl871xdrv used in system and build for ARM arch.

Minibian (https://minibianpi.wordpress.com) with some updates is used for Raspberry Pi images.

Drivers bundled:

* Realtek 8188eu - https://github.com/lwfinger/rtl8188eu (native staging driver is used for Raspberry Pi 1 and 2)
* Mediatek 7601 AP mode - https://github.com/eywalink/mt7601u (not for Raspberry Pi boards)

## Disclaimer
Things to keep in mind

* Scripts are tested and supposed to be run ok. However, there is no warranty, that it will work for you or suite particular needs.
* Also I'm not responsible for damage of any kind, caused directly or indirectly to your hardware or privacy.
* TOR and I2P are not a silver bullet and designed to protect your privacy. The particular usage requires some fundamental knowledge.