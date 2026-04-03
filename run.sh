#!/usr/bin/env bash

set -eu
driver="amdgpu"
fan_addr="fan1_input"

path=$(dirname $(grep $driver /sys/class/hwmon/*/name | awk -F ":" '{print $1}'))
echo "Mapping $path/$fan_addr to [steamdeck_hwmon]/fan1_input..."
sudo insmod /opt/steamdeck_hwmon_shim/steamdeck_hwmon_shim.ko real_path=$path/$fan_addr
