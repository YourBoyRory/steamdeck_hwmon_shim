make || make -C /lib/modules/$(uname -r)/build \
  M=$PWD \
  CC=clang \
  LD=ld.lld \
  AR=llvm-ar \
  NM=llvm-nm \
  STRIP=llvm-strip \
  OBJCOPY=llvm-objcopy \
  modules
sudo mkdir -p /opt/steamdeck_hwmon_shim
sudo cp ./* /opt/steamdeck_hwmon_shim/
sudo chmod +x /opt/steamdeck_hwmon_shim/run.sh
sudo cp ./steamdeck_hwmon_shim.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable steamdeck_hwmon_shim
