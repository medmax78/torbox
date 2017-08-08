# Orange TorBOX

Этот проект - набор скриптов, который позволит установить и настроить анонимизирующий TOR/I2P MidlleBox быстро и просто.

[Файлы проекта на GitHUB](http://github.com/znoxx/torbox).

[Новости по теме Tor/I2p MiddleBox](http://znoxx.me/tag/torbox/).

## Как это работает ?

После установки ваше *Pi-устройство будет изображать точку доступа WiFi трафик _клиентов_ которой можно будет переключить на работу через TOR, а также использовать устройство для доступа к сети I2P. Устройство управляется через веб-интерфейс и не требует дополнительной настройки. Доступны режимы "всё через TOR", "всё через TOR+Privoxy (встроенный рекламорез)" и "прямое соединение".

Для пользования I2P требуется настроить http-proxy, указывающий на IP адрес устройства.

Установка TOR на оконечные устройства (компьютер, телефон, планшет) не требуется.
 

Текст ниже - перевод руководства по установке и эксплуатации

## Системные требования
Текущая версия поддерживает устройства OrangePI PC и Orange Pi One на базе процессора AllWinner H3, Orange Pi Zero на базе AllWinner H2+, платы Raspberry Pi 1, Raspberry Pi 2, Raspberry Pi 3 и подразумевает следующее:

* Все работает на Debian-подобной ОС (Debian 8+ с работающим system)
* У вас имеется совместимый USB WiFi адаптер (об этом ниже). 
* Интернет подключен через Ethernet и DHCP и интерфейс сконфигурирован, как eth0.

| Плата | Название Hardware Target | Примечания |
|-------|--------------------------|------------|
| Orange Pi PC | orangepipc |
| Orange Pi One | orangepipc |
| Orange Pi Zero | orangepi0 | Поддержан только встроенный WiFi адаптер |
| Raspberry Pi 1 (armv6) | raspberrypi1 | Поддержаны только адаптеры Realtek |
| Raspberry Pi 2 (armv7) | raspberrypi2 | Поддержаны только адаптеры Realtek |
| Raspberry Pi 3 (в режиме armv7) | raspberrypi3 | Поддержаны только собственный адаптер Broadcom, т.е. внешний донгл не требуется. |



## Аппаратные требования
### Подготовка образа
#### Готовый образ
##### Для OrangePi PC и OrangePi One
Базовый образ построен для OrangePI PC (AllWinner H3) на модифицированном ядре от Loboris.

##### Для OrangePi Zero
Базовый образ построен для OrangePI Zero (AllWinner H2+) на дистрибутиве Armbian. По сравнению с оригинальным образом - отключена поддержка 3D за ненадобностью, а также Network Manager для обеспечения ручной настройки WiFi.

##### Для Raspberry Pi 1, Raspberry Pi 2 и Raspberry Pi 3
Базовый образ базируется на проекте [Minibian](https://minibianpi.wordpress.com/), но увеличен до 2 ГБ и добавлен swap.

Требуется карточка как минимиум 2GB.

_Различные производители интерпретируют размер в 2GB по своему. Если вдруг вы увидели ошибку записи с информацией об окончании места - используйте карту либо от другого производителя, либо 4GB карту. Стоят они не дорого._

Готовый образ можно скачать:

##### Для OrangePi PC и OrangePi One
Расположен [здесь](http://znoxx.me/cgi-bin/url.cgi?2jjcGns).


##### Для OrangePi Zero
Расположен [здесь](http://znoxx.me/cgi-bin/url.cgi?2j55knh).

##### Для Raspberry Pi 1-3
Расположен [здесь](http://znoxx.me/cgi-bin/url.cgi?2jjfwJb).

Распакуйте и запишите его на microSD командой dd в Linux, или с помощью Win32DiskImager в Windows.

##### Для OrangePi PC и OrangePi One 

Подмонтируйте первую VFAT партицию (или просто переткните карту в Windows) для того, чтобы установить script.bin, соответствующей вашей плате.

Этот образ изначально настроен для Orange Pi PC. Если вы используете Orange Pi One - эту операцию __нужно__ сделать.

[![Orange Pi PC](data:image/png;base64,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)]
(http://znoxx.me/cgi-bin/url.cgi?1NS4Fcm)

##### Для OrangePi Zero и Raspberry Pi 1-3 
Дополнительных действий с образом не требуется - можно загружать систему.


#### Другие образы
Вы вполне можете использовать свой собственный образ.
Необходимо помнить следующее:

* Интерфейс eth0 должен быть преднастроен и должен использовать DHCP
* Network Manager должен быть отключен или вообще удален. Ну или хотя бы НЕ должен "рулить" вашими WiFi адаптерами.
* Потребуется установить пакеты libnl -  libnl3-200 и  libnl-genl-3-200 для корректной работы hostapd.

Проверьте Вашу карточку - вставьте в устройство, загрузитесь и попробуйте зайти по SSH.

### Поддержанные WiFi адаптеры

Система поддерживает самые доступные и популярные адаптеры

* 0bda:0179 Realtek Semiconductor Corp. RTL8188ETV Wireless LAN 802.11n Network Adapter

[![Realtek](http://znoxx.me/content/images/2016/03/rtlwifi-1.jpg)](http://znoxx.me/cgi-bin/url.cgi?1qZe7Yl)

* 0bda:8179 Realtek Semiconductor Corp. [RTL8188EUS](http://znoxx.me/cgi-bin/rurl.cgi?1UYTCqW) 802.11n Wireless Network Adapter 
* 148f:7601 Ralink Technology, Corp. MT7601U Wireless Adapter

[![MTK](http://znoxx.me/content/images/2016/03/mtkwifi.jpg)](http://znoxx.me/cgi-bin/rurl.cgi?1R2y3op)

**НЕ ПОДДЕРЖИВАЕТСЯ В RASPBERRY PI (все версии) И ORANGE PI ZERO**

* Собственный адаптер Raspberry Pi 3
* Собственный адаптер в OrangePi Zero

Вообще, список этот далеко не финальный. Другие адаптеры тоже будут работать, при условии, что для них есть во-первых драйвер, а во-вторых они умеют работать в режиме Access Point с драйверами hostapd   __"nl80211"__ или __"rtl871xdrv"__. Ну или без hostapd, как например поддержанный mt7601.

## Запуск инсталляции
Загрузите ваше устсройство, используя подготовленную SD-карту.

Логин/Пароль для Orange Pi PC, Orange Pi One и Orange Pi Zero - orangepi/orangepi

Логин/Пароль для Raspberry Pi 1-3 - pi/raspberry

Войдите через SSH и дайте следующие команды:

* `sudo apt-get update`
* `sudo apt-get install git`
* `git clone https://github.com/znoxx/torbox.git`

Когда всё скачается, дайте команду:

* `cd torbox`

Теперь отредактируйте __config.inc__ под ваши нужды.

Что менять помимо указания "hardware target" (см. таблицу выше):

* USER - если вы используете учетную запись "orangepi" (в случае ***Orange Pi PC/Orange Pi One***) - просто оставьте её как есть. Для ***Raspberry Pi 1, Raspberry Pi 2 и Raspberry Pi 3*** следует использовать учетную запись "pi". Если свою собственную - замените orangepi на свою запись.
* SSIDNAME - Собственно, ваш будущий WiFi.
* SSIDPASSWORD - пароль к WiFi.
* IPxxx and DHCPxxx- Это настройки сети. Если не нравятся чем-либо предустановленнные, просто отредактируйте их
* WEBUIxxx - настройки WEB UI.Под этим пользователем будет запускаться интерфейс, ну и откуда он будет запускаться.
* I2PUSER - наверное не надо его менять. I2P будет запускаться под вашим пользователем.
* I2PLOCATION - куда будет установлена I2P.
* USESTOCKTOR - какой TOR будем ставить. По умлочанию - тот, что живет в официальных репозитариях Ubuntu/Debian. Если хотите новейшую версию из torproject - установите этот параметр в "0". Правда, возможны проблемы совместимости с systemd.
* HOSTADDR - Этот параметр позволяет обращаться к устройству, используя имя, а не адрес. Он генерируется из параметра "hostname", так, если пример не изменялся - на устройство можно зайти по адресу http://orangepi.torbox:3000. Для этого устройство должно быть в режиме "DIRECT". 

Если редактирование завершено, решительно запускайте инсталлятор.

* `sudo ./installer.sh`

Всё полностью автоматизированно - будут установлены нужные пакеты, а также будет настроен интерфейс __wlan0__.
Инсталлятор работает довольно долго, поскольку качает и Java 8 и node.js из репозитариев.

## Тестирование системы
Как только инсталлятор завершит работу - вставьте ваш USB WiFi в устройство и "передёрните" питание. Если устройство уже имеет встроенный WiFi - просто перезагрузите устройство.
После загрузки  должна быть доступна ваша новая WiFi сеть.
Соединитесь с этой сетью и попробуйте открыть любой URL.

Теперь проверьте в брауезере следующий адрес - http://IPADDRESS:3000 - тот самый адрес, который вы указали в конфигурации или имя хоста - http://yourhost.torbox:3000. WEB-интерфейс должен быть доступен.
Логин/пароль по умлочанию - "orangepi/orangepi". Его можно сменить в самом WebUI.
Переключите режим в TOR или Privoxy и откройте страницу http://check.torproject.org - и если все в порядке, вы увидите сообщение о том, что ваш браузер работает через TOR.


## Режимы работы
Устройство поддерживает 3 режима работы:

* _TOR_ - весь траффик от  __WiFi клиентов__ направляется через TOR
* _PRIVOXY_ - весь траффик от  __WiFi клиентов__ направляется через TOR и PRIVOXY. Вы можете настроить правила для Privoxy, например для вырезания рекламы или кнопок "Like". Лучше свериться с [официальной документацией](http://privoxy.org).
* _DIRECT_ - Весь траффик проходит через точку доступа без TOR/PRIVOXY, но можно задать http/https proxy в браузере, указав IPADDRESS и порт 8118 для анонимизации интернет-траффика.

Эти настройки можно переключать в  WebUI. Помните, что траффик самого устройства не перенаправляется через TOR. Так, например запуска "apt-get" на Pi будет использовать прямое соединение с Интернетом. Итак - через TOR работают только Wifi клиенты.


## Использование I2P
После загрузки можно запустить демона I2P через WebUI. Где-то через пару минту от момента старта можно открыть URL http://IPADDRESS:7657, где, собственно и изменить настройки I2P.
Для доступа к .i2p сайту - установите proxy в системе - в качестве адреса IPADDRESS и порта значение 8118. Где-то через несколько минут вы сможете открывать .i2p сайты.

## Завершение инсталляции
После того, как все настройки проверены, в папке проекта запустите:

* `sudo ./finalize_inst.sh`
* Опционально: `sudo apt-get upgrade`

Это "закроет" firewall и почистит временные файлы.
После этого устройство доступно лишь по адресу IPADDRESS:22 в том случае, если вы соединены с вашей новой точкой доступа.

## Дополнительные сведения о драйверах

Драйвера MediaTek/Ralink НЕ используют hostapd для создания точки доступа. То есть, если вы хотите изменить настройки точки доступа - делать это нужно в соответствующем месте. Для Mediatek - в настройках драйвера. Для остальных - /etc/hostapd/hostapd.conf. Во время инсталляции первичные настройки устанавливаются в обоих локациях.
Таким образом, если ваш USB WiFi -  Mediatek - hostapd просто "тихо" отключится, и точка доступа будет работать через драйвер.
Для других WiFi устройств - используется hostapd.

## Использование других WiFi устройств

Если у вас другой WiFi драйвер, имейте ввиду:

* Убедитесь, что ваше устройство имеет как драйвер, так и firmware, если оно нужно.
* Внестие нужные изменения в  /etc/hostapd/hostapd.conf
* Переименуйте ваш интерфейс беспроводной сети в  wlan0 - это позволит минимизировать изменения.

Я достаточно успешно проверил некоторые устройства TP-Link, так что никаких проблем не ожидается.

##### Для Orange Pi PC и Orange Pi One 
_Имейте ввиду, что инсталлятор перемещает некоторые драйвера от Realtek в /lib/modules-disabled_. Если ваш донгл от Realtek - проверьте нет ли вашего драйвера в этой папке.

## Использование других платформ
В общем случае, в папке "hardware" нужно создать подпапку "myhardware"  (например) и положить в нее специфичные для платформы "артефакты", такие как драйвера, скрипт для мониторинга температуры и скрипт _powersave.sh_, который сгенерирован через powertop.

## Ссылки и благодарности
Спасибо Loboris за работающие и стабильные ядра для OrangepPI http://www.orangepi.org/orangepibbsen/forum.php?mod=viewthread&tid=342

Спасибо bronco за исправление проблем с температурой на  OrangePi http://www.orangepi.org/orangepibbsen/forum.php?mod=viewthread&tid=785

Оригинальный hostapd http://w1.fi/hostapd/  с патчем для Realtek https://github.com/pritambaral/hostapd-rtl871xdrv также используется в системе. Он собран для архитектуры ARM.

[Minibian](https://minibianpi.wordpress.com) с некоторыми изменениями для Raspberry Pi

[Armbian](http://armbian.com) отличная ОС для кучи железа.

Включенные драйвера:

* Realtek 8188eu - https://github.com/lwfinger/rtl8188eu (для Raspberry Pi 1 и Raspberry Pi 2 используется staging драйвер из комплекта ядра)
* Mediatek 7601 AP mode - https://github.com/eywalink/mt7601u (не поддерживается для Raspberry Pi и Orange Pi Zero)

## Отказ от отвественности
Стоит упомянуть:

* Скрипт протестирован и должен работать без проблем. Однако, нет никаких гарантий, что он подойдет под ваши нужды.
* Автор не несет ответственности за любой прямой или косвенный вред от продукта нанесенный как вашему устройству, так и приватности.
* TOR и I2P разработаны для защиты вашей приватности, но не являются панацеей. Использование подразумевает наличие некоторых фундаментальных знаний.