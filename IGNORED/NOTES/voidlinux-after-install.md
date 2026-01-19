# Voidlinux
- use `glibc` version (`musl` had issues with `nvm` and neovim)
- mostly same packages like in `arch` installation for awesome
- use dotfiles repo and `stow`:
  - clone `dotfiles` to `~` folder
  - make sure `.config` exists

### Services
- enabled services are links in /var/service
- to see status of all services `sv status /var/service/*`
- enable service is just creating a link
- enable `acpid` service: `ln -s /etc/sv/acpid /var/service`

### Network
- voidinstaller uses `wpa` for wifi
- use NetworkManager, much nicer and easier than other options
- https://docs.voidlinux.org/config/network/networkmanager.html
- in terminal can use `nmcli`
- https://wiki.archlinux.org/title/NetworkManager
- install `polkit` for normal user to have access to wifi changes

### Bluetooth
- just install `bluez` and enable the `bluetoothd` and `dbus` services
- https://docs.voidlinux.org/config/bluetooth.html

### DEB packages
- you can install deb packages with `xdeb`
- https://github.com/xdeb-org/xdeb
- this converts deb -> xbps format, and installs with xbps
- this packages can be removed normally with xbps
- packages i need to install like this: 
  1. vscode
  2. brave

### Laptop
- for better laptop battery use `tlp` service
- https://linrunner.de/tlp/support/optimizing.html
