#!/bin/sh
echo '1500' > '/proc/sys/vm/dirty_writeback_centisecs'
echo '0' > '/proc/sys/kernel/nmi_watchdog'
echo '1' > '/sys/devices/system/cpu/sched_mc_power_savings'

