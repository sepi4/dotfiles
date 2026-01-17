# Hiberation (arch, debian/ubuntu)

## Arch

check swap size
`swapon --show`

get swap uuid
`lsblk -f`

edit grub file, add resume uuid
`sudo nano /etc/default/grub`
`GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet resume=UUID=<SWAP-UUID>"`

update grub
`sudo grub-mkconfig -o /boot/grub/grub.cfg`

enable resume hook
`sudo nano /etc/mkinitcpio.conf`

add `resume` in ( )
`HOOKS=(base udev autodetect modconf block filesystems resume fsck)`

rebuild initramfs
`sudo mkinitcpio -P`

reboot and try hiberate

## Debian/Ubuntu

check swap size
`swapon --show`

get swap uuid
`lsblk -f`

add swap uuid
`sudo nano /etc/initramfs-tools/conf.d/resume`
this text
`resume=UUID=<swap-uuid>`

update grud
`sudo update-grub`

rebuild initramfs
`sudo update-initramfs -u`

## Key difference

| Arch               | Debian / Ubuntu              |
| ------------------ | ---------------------------- |
| mkinitcpio         | initramfs-tools              |
| manual resume hook | resume handled automatically |
| grub-mkconfig      | update-grub                  |



