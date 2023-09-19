#! /bin/bash

# parameters:
THINKFAN_CONF="/etc/thinkfan.conf"


# find the number of hwmon, e.g. "hwmon6" -> 6
HWMONNUMBER=$(ls /sys/devices/platform/thinkpad_hwmon/hwmon | grep -o '[0-9]')

# replace with the found HWMONNUMBER
sed -i "s/\\/hwmon\\/hwmon./\\/hwmon\\/hwmon$HWMONNUMBER/g" "$THINKFAN_CONF"
