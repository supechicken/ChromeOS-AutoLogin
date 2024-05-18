#!/bin/bash
set -eu

# prevent conflict between system libraries and Chromebrew libraries
unset LD_LIBRARY_PATH
export PATH=/bin:/sbin:/usr/bin:/usr/sbin

function remount_rootfs() {
  echo '[+] Trying to remount root filesystem in read/write mode...'
  mount -o remount,rw / && return 0 || return $?
}

function remove_rootfs_verification() {
  # KERN-A B for arm  ROOT-A B for x64
  if [[ "$ARCH" =~ "arm64" ]];then
    /usr/share/vboot/bin/make_dev_ssd.sh --remove_rootfs_verification --partitions 2
    /usr/share/vboot/bin/make_dev_ssd.sh --remove_rootfs_verification --partitions 4
  else
    /usr/share/vboot/bin/make_dev_ssd.sh --remove_rootfs_verification --partitions 3
    /usr/share/vboot/bin/make_dev_ssd.sh --remove_rootfs_verification --partitions 5
  fi
  echo -e "${YELLOW}Please run this script again after reboot.${RESET}"
  echo '[+] Rebooting in 3 seconds...'
  sleep 3
  reboot
}

if [[ ${EUID} != 0 ]]; then
  echo -e "${RED}Please run this script as root.${RESET}" >&2
  exit 1
fi

if ! remount_rootfs; then
  echo -e "${YELLOW}Remount failed. Did you disable rootFS verification?${RESET}" >&2
  read -N1 -p 'Disable rootFS verification now? (This will reboot your system) [Y/n]: ' response
  echo -e "\n"

  case $response in
  Y|y)
    remove_rootfs_verification
  ;;
  *)
    echo 'No changes made.'
    exit 1
  ;;
  esac
fi

cd /tmp

echo '[+] Downloading ChromeOS-AutoLogin...'
curl -L "https://github.com/supechicken/ChromeOS-AutoLogin/releases/download/latest/cros-autologin-$(uname -m)" -o cros-autologin
curl -L "https://github.com/supechicken/ChromeOS-AutoLogin/raw/main/upstart/cros-autologin.conf" -o cros-autologin.conf

echo '[+] Installing...'
install -Dm755 cros-autologin /usr/local/bin/
install -Dm644 cros-autologin.conf /etc/init/

read -sp "Enter your Google account password (will be stored locally, protected by Unix permission): " password

mkdir -p /usr/local/etc/cros-autologin/
echo -n "${password}" > /usr/local/etc/cros-autologin/password
echo

echo '[+] Setting up file permission...'
chown -R root:root /usr/local/etc/cros-autologin
chmod -R 600 /usr/local/etc/cros-autologin

echo '[+] All done! Reboot and try if it works.'
