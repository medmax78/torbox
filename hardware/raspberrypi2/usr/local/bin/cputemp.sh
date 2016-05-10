#!/bin/sh
vcgencmd measure_temp | sed -e "s/temp=//" | sed -e "s/'C//"

