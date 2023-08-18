#! /bin/bash

# parameters:
THINKFAN_CONF="/etc/thinkfan.conf"


# find the number of hwmon, e.g. "hwmon6"
HWMONNUMBER=$(ls /sys/devices/platform/thinkpad_hwmon/hwmon)

# replace "hwmon*" with the found HWMONNUMBER
sed -i "s/\\/hwmon\\/hwmon./\\/hwmon\\/$HWMONNUMBER/g" "$THINKFAN_CONF"
