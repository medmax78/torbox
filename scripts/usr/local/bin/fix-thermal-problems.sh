#!/bin/bash

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

if [ "$(id -u)" != "0" ]; then
        echo "This script must be executed as root. Exiting" >&2
        exit 1
fi

Fex2Bin="$(which fex2bin)"
if [ "X${Fex2Bin}" = "X" ]; then
        apt-get -f -q -y install sunxi-tools >/dev/null 2>&1
fi

Path2ScriptBin="$(df | awk -F" " '/^\/dev\/mmcblk0p1/ {print $6}')"
if [ ! -f "${Path2ScriptBin}/script.bin" ]; then
        echo "Can not find script.bin. Ensure boot partition is mounted" >&2
        exit 1
fi

MyTmpFile="$(mktemp /tmp/${0##*/}.XXXXXX)"
trap "rm \"${MyTmpFile}\" ; exit 0" 0 1 2 3 15

bin2fex <"${Path2ScriptBin}/script.bin" 2>/dev/null | grep -v "^LV" \
	| grep -v "^max_freq" | grep -v "^min_freq" | grep -v "^extremity_freq" \
	| grep -v "^ths_" | grep -v "^cooler" | grep -v "^boot_clock" >"${MyTmpFile}"
if [ $? -ne 0 ]; then
	echo "Could not convert script.bin to fex. Exiting" >&2
	exit 1
fi
cp -p "${Path2ScriptBin}/script.bin" "${Path2ScriptBin}/script.bin.bak"

# headless settings -- heavily undervolted and not recommended for normal useage
# sed -i '/\[dvfs_table\]/a \
# extremity_freq = 1296000000\
# max_freq = 1200000000\
# min_freq = 480000000\
# LV_count = 7\
# LV1_freq = 1296000000\
# LV1_volt = 1320\
# LV2_freq = 1200000000\
# LV2_volt = 1180\
# LV3_freq = 1104000000\
# LV3_volt = 1120\
# LV4_freq = 1008000000\
# LV4_volt = 1080\
# LV5_freq = 960000000\
# LV5_volt = 1020\
# LV6_freq = 816000000\
# LV6_volt = 960\
# LV7_freq = 480000000\
# LV7_volt = 940' "${MyTmpFile}"

sed -i '/\[dvfs_table\]/a \
;extremity_freq = 1296000000\
max_freq = 1296000000\
min_freq = 648000000\
LV_count = 8\
LV1_freq = 1296000000\
LV1_volt = 1340\
LV2_freq = 1200000000\
LV2_volt = 1320\
LV3_freq = 1008000000\
LV3_volt = 1200\
LV4_freq = 816000000\
LV4_volt = 1100\
LV5_freq = 648000000\
LV5_volt = 1040\
LV6_freq = 0\
LV6_volt = 1040\
LV7_freq = 0\
LV7_volt = 1040\
LV8_freq = 0\
LV8_volt = 1040' "${MyTmpFile}"

sed -i '/\[ths_para\]/a \
ths_used = 1\
ths_trip1_count = 6\
ths_trip1_0 = 75\
ths_trip1_1 = 80\
ths_trip1_2 = 85\
ths_trip1_3 = 90\
ths_trip1_4 = 95\
ths_trip1_5 = 100\
ths_trip1_6 = 0\
ths_trip1_7 = 0\
ths_trip1_0_min = 0\
ths_trip1_0_max = 1\
ths_trip1_1_min = 1\
ths_trip1_1_max = 2\
ths_trip1_2_min = 2\
ths_trip1_2_max = 3\
ths_trip1_3_min = 3\
ths_trip1_3_max = 4\
ths_trip1_4_min = 4\
ths_trip1_4_max = 5\
ths_trip1_5_min = 5\
ths_trip1_5_max = 5\
ths_trip1_6_min = 0\
ths_trip1_6_max = 0\
ths_trip2_count = 1\
ths_trip2_0 = 105' "${MyTmpFile}"

sed -i '/\[cooler_table\]/a \
cooler_count = 6\
cooler0 = "1296000 4 4294967295 0"\
cooler1 = "1200000 4 4294967295 0"\
cooler2 = "1008000 4 4294967295 0"\
cooler3 =  "816000 4 4294967295 0"\
cooler4 =  "648000 4 4294967295 0"\
cooler5 =  "480000 1 4294967295 0"' "${MyTmpFile}"

sed -i '/\[target\]/a \
boot_clock = 1008' "${MyTmpFile}"

fex2bin "${MyTmpFile}" "${Path2ScriptBin}/script.bin" 2>/dev/null
if [ $? -ne 0 ]; then
        mv "${Path2ScriptBin}/script.bin.bak" "${Path2ScriptBin}/script.bin"
        echo "Writing script.bin went wrong. Nothing changed" >&2
        exit 1
fi

echo "Successfully repaired broken overvolting/overclocking settings. Reboot necessary for changes to take effect"