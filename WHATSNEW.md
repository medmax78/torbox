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
