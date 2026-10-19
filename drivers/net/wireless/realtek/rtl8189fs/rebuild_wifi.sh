#!/usr/bin/env bash
# rebuild_wifi.sh — Rebuild & reinstall rtl8189fs for current kernel
# Run: sudo bash /home/aisixzuperlabs/wifi-driver/rebuild_wifi.sh
# Use after a kernel upgrade (apt upgrade that changes `uname -r`).
set -e

SRC=/home/aisixzuperlabs/wifi-driver/rtl8189fs
KVER=$(uname -r)
KSRC=/lib/modules/$KVER/build

echo "[*] Kernel: $KVER"
if [ ! -d "$KSRC" ]; then
  echo "[!] Kernel headers for $KVER not found. Install: sudo apt-get install linux-headers-$KVER"
  exit 1
fi

# pick compiler: gcc-14 if present (needed for 6.12+), else gcc
CC=gcc-14
command -v $CC >/dev/null 2>&1 || CC=gcc
echo "[*] Using compiler: $CC"

cd "$SRC"
echo "[*] Clean"
make clean >/dev/null 2>&1 || true

echo "[*] Build"
make ARCH=arm64 CC=$CC KSRC="$KSRC" 2>&1 | tail -n 5
if [ ! -f 8189fs.ko ]; then
  echo "[!] Build failed — see output above"
  exit 1
fi

echo "[*] Install module"
mkdir -p /lib/modules/$KVER/kernel/drivers/net/wireless/
cp -f 8189fs.ko /lib/modules/$KVER/kernel/drivers/net/wireless/8189fs.ko
depmod -a

echo "[*] Load"
modprobe -r 8189fs 2>/dev/null || true
modprobe 8189fs

sleep 2
if ip -o link show wlan0 >/dev/null 2>&1; then
  echo "[✓] wlan0 is up. WiFi driver rebuilt & loaded for $KVER"
else
  echo "[!] wlan0 not present — check dmesg | grep 8189fs"
fi
