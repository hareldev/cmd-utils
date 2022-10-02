#! /bin/bash

# parameters:
THINKFAN_CONF="/etc/thinkfan.conf"

# get 1st hwmon line number:
line_number=$(grep hwmon --line-number -r $THINKFAN_CONF | cut -f1 -d: | head -1)
if  [[ ! -z $line_number ]] && (( $line_number > 0 )); then
    existing_record=true
    line_number_to_enter=$line_number
else
    line_number_to_enter=1
fi

# find all hwmon
new_entries=$(find /sys/devices -type f -name "temp*_input"| grep platform |sed 's/^/hwmon /g')
new_entries_lines=$(echo "$new_entries" | wc -l)

if (( $new_entries_lines > 2 )); then
    add_new_entries=true
else 
    echo "no devices found using regular find, script will exit"
    exit 1
fi

if [[ $add_new_entries == true ]]; then
    # delete current hwmon
    if [[ $existing_record == true ]]; then
        sudo sed -i '/^hwmon/d' "$THINKFAN_CONF"
    fi

    # add hwmon lines to file
    entries_sed_formatted=${new_entries//$'\n'/\\n}
    sudo sed -i -e "${line_number_to_enter} s,.*,$entries_sed_formatted\n," "$THINKFAN_CONF"
fi