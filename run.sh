#!/usr/bin/env bash

set -eu
driver="nct6798"
fan_addr="fan1_input"

path=$(dirname $(grep $driver /sys/class/hwmon/*/name | awk -F ":" '{print $1}'))
ls $path/$fan_addr
echo "Mapping $path/$fan_addr to [steamdeck_hwmon]/fan1_input..."
sudo insmod /opt/steamdeck_hwmon_shim/steamdeck_hwmon_shim.ko real_path=$path/$fan_addr || (
    cd /opt/steamdeck_hwmon_shim
    /opt/install.sh
    sudo insmod /opt/steamdeck_hwmon_shim/steamdeck_hwmon_shim.ko real_path=$path/$fan_addr
)
