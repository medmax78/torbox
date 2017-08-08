# Changes for 08-08-2017

* Russian documentation moved to git repository
* Added some images
* English and Russian versions are aligned (well, almost).

**NOTE:

Project is no more supported. Heading to a whole new version.

# Changes for 05-03-2017

* Overall speedup of installer due to optimization of repository processing.
* init.d support completely removed - everything is moved to systemd.
* Systemd scripts and related binaries now have "-torbox" suffix to avoid conflicts with standard/other software
* I2P updated to last version (for the time being)

***NOTE: 

This update is considered as last major one, next commits will be only bugfixes (critical ones) and third-party  software updates 
(like node.js/i2p), since new version of anonymizing middlebox with much more flexible functionality is planned.

# Changes for 15-01-2017

* Added new hardware target and image link - Orange Pi Zero
* Version of i2p software updated to 0.9.27
* Some internal script optimizations


# Changes for 07-08-2016

* Added new hardware target - Raspberry Pi 3
* Node.js for ARMv7+ repo updated to 6.x version

# Changes for 25-06-2016

* i2p updated to version 0.9.26

# Changes for 14-05-2016:

* Raspberry Pi 1 and Raspberry Pi 2 platforms supported.
* Critical issue with Realtek 8188 firmware resolved - moved to correct folder.
* Added haveged daemon to solve entropy issues and increase SoftAP speed/reliablilty.
* Pug in WebUI updated to latest version from npmjs.org.
* Overall code cleanup and refactoring.

## Manual adding of haveged daemon

1. Login to your device as root.
2. `apt-get install haveged`
3. Reboot.

## Fixing firmware issue (previous releases)

1. Login to your device as root.
2. `mv /lib/firmware/rtl8188eufw.bin /lib/firmware/rtlwifi/rtl8188eufw.bin`
3. Reboot. Speed of access point should increase dramatically.

# Changes for 15-04-2016:
* WebUI updated to 0.2.0
    * Jade->Pug migrated
    * Dependencies upgraded to latest npm versions
    * Fixed issues in templates to comply with Pug

## Manual update of webui

1. Fetch new version from GIT
2. Stop WebUI (usually - `sudo /etc/init.d/webui stop`)
3. Backup your /opt/webui somwhere (it is **important**)
4. Delete contents /opt/webui (but keep directory)
5. Copy webui contents of git copy to /opt/webui
6. `cd /opt/webui`
7. `sudo npm install`
8. `chown webui:webui -R *` (change webui to appropriate user you use to run WebUI)
9. Copy config dir from your saved backup (3) to /opt/webui
10. Start WebUI (usually - `sudo /etc/init.d/webui start`)

# Changes for 01-04-2016:

* Orange Pi One support
* Initial image aligned to SD card
* Only script.bin for OrangePi PC and Orange Pi One left - since operation is headless. 
* I2P update to .25 version 
* Default operation mode is DIRECT - this will allow to access freshly-boot device via name defined in config (e.g. http://orangepi.torbox:3000)
