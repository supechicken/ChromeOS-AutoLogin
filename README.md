# ChromeOS AutoLogin
Log in automatically on ChromeOS startup using your password.

## Installation
```shell
sudo bash -c "$(curl -L https://github.com/supechicken/ChromeOS-AutoLogin/raw/main/install.sh)"
```

## Uninstallation
```shell
sudo rm -rf /usr/local/etc/cros-autologin /usr/local/bin/cros-autologin /etc/init/cros-autologin.conf
```

## Building

> [!NOTE]
> This project was written in Crystal, to build this you will need to install `crystal` first

```shell
crystal build --progress --release --static src/autologin.cr
llvm-strip autologin
```
