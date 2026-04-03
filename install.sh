make
sudo mkdir -p /opt/steamdeck_hwmon_shim
sudo cp ./* /opt/steamdeck_hwmon_shim/
sudo chmod +x /opt/steamdeck_hwmon_shim/run.sh
sudo cp ./steamdeck_hwmon_shim.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable steamdeck_hwmon_shim
