#!/bin/bash
set -eu

cd /tmp

echo "[+] Downloading cros-autologin..."
curl -L "https://github.com/supechicken/cros-autologin/releases/download/v0.1/cros-autologin_$(uname -m)" -o cros-autologin
curl -L "https://github.com/supechicken/cros-autologin/raw/main/upstart/cros-autologin.conf" -o cros-autologin.conf

echo "[+] Installing..."
install -Dm755 cros-autologin /usr/local/bin/
install -Dm644 cros-autologin.conf /etc/init/

read -p "Enter your Google account password (will be stored locally, protected by Unix permission): " password

mkdir -p /usr/local/etc/cros-autologin/
echo -n "${password}" > /usr/local/etc/cros-autologin/password

chown -R root:root /usr/local/etc/cros-autologin
chmod -R 600 /usr/local/etc/cros-autologin
