# ChromeOS AutoLogin
Log in automatically on ChromeOS startup using your password.

## How it works?
This simple program starts on ChromeOS boot and waits for the ChromeOS UI load.
Once the ChromeOS login prompt shows, the program creates a virtual keyboard and helps you type the password automatically.

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
