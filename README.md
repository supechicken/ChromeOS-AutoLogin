# ChromeOS AutoLogin
Log in automatically on ChromeOS startup using your password.

### Installation
```shell
sudo bash -c "$(curl -L https://github.com/supechicken/ChromeOS-AutoLogin/raw/main/install.sh)"
```

## Building

> [!NOTE]
> This project was written in Crystal, to build this you will need to install `crystal` first

```shell
crystal build --release --static src/autologin.cr
llvm-strip autologin
```
