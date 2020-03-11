# !/usr/bin/sh
#  add user to sudoers before running this script

# apt install sudo -yy
# /usr/bin/usermod -aG sudo $user

checkUserExists() {
    cd ~
    homeDir=/home/$USER
    [ ! -d "$homeDir" ] && echo "no user dir: " && exit 1
}


checkDotfilesNotExist() {
    dir=$user/dotfiles
    [ -d "$dir" ]  && echo "'~/dotfiles' dir already exists, delete it" && exit 1
}

virtualBox() {
    echo "give virtualbox version:"
    read virtualboxVersion

    mkdir ~/Downloads
    address=https://download.virtualbox.org/virtualbox/$virtualboxVersion/VBoxGuestAdditions_$virtualboxVersion.iso
    cd ~/Downloads
    wget $address
    file=VBoxGuestAdditions_$virtualboxVersion.iso
    [ ! -f "$file" ] && echo "no file: $file" && exit 1
    cd ~
}





addNonFree() {
    echo '# deb http://deb.debian.org/debian/ buster main

deb http://deb.debian.org/debian/ buster main contrib non-free
deb-src http://deb.debian.org/debian/ buster main contrib non-free

deb http://security.debian.org/debian-security buster/updates main contrib non-free
deb-src http://security.debian.org/debian-security buster/updates main contrib non-free

# buster-updates, previously known as 'volatile'
deb http://deb.debian.org/debian/ buster-updates main contrib non-free
deb-src http://deb.debian.org/debian/ buster-updates main contrib non-free
' | sudo tee /etc/apt/sources.list
}

installApps()
{
    sudo apt update && sudo apt upgrade -yy

    sudo apt install \
        linux-headers-$(uname -r) \
        xorg \
        git \
        ranger \
        firefox-esr \
        htop \
        net-tools \
        awesome \
        neovim \
        copyq \
        vlc \
        npm \
        xterm \
        zsh \
        curl \
        dwm \
        suckless-tools \
        chromium \
        w3m \
        telegram-desktop \
        libx11-dev \
        libxinerama-dev \
        build-essential \
        dkms \
        network-manager-gnome \
        zathura \
        volumeicon-alsa \
        scrot \
        sxiv \
        pulseaudio \
        thunar -yy
    
}

installVsCode() {
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/ -yy
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list' -yy

    sudo apt-get install apt-transport-https -yy
    sudo apt-get update -yy
    sudo apt-get install code -yy
}


getDotfiles() {
    git clone https://github.com/sepi4/dotfiles.git ~/dotfiles
}


copyFromDotfiles() {
    mkdir -p ~/.config
    cp -r ~/dotfiles/.config/awesome/ ~/.config

    git clone https://github.com/streetturtle/awesome-wm-widgets.git \
        ~/.config/awesome/awesome-wm-widgets

    cp -r ~/dotfiles/.config/nvim/ ~/.config



    cat ~/dotfiles/.bashrc > ~/.bashrc



    cp ~/dotfiles/.Xresources ~/.Xresources
    cp ~/dotfiles/git-prompt.sh ~/git-prompt.sh
}


addXinitrc() {
    echo '#!/bin/sh

    [ -f ~/.Xresources ] && xrdb -merge ~/.Xresources
    exec awesome
    ' > ~/.xinitrc
}


virtualBoxAppInstall() {
    sudo mkdir /mnt/cd
    sudo mount -t iso9660 -o ro,loop ~/Downloads/VBoxGuestAdditions_$virtualboxVersion.iso /mnt/cd/
    cp /mnt/cd/VBoxLinuxAdditions.run ~/Downloads/VBoxLinuxAdditions.run
    sudo umount /mnt/cd
    sudo ~/Downloads/./VBoxLinuxAdditions.run
}


echo "NOW starts LONG INSTALL"
sleep 2

checkUserExists
checkDotfilesNotExist
virtualBox
addNonFree
installApps
installVsCode
getDotfiles
copyFromDotfiles
addXinitrc
virtualBoxAppInstall

echo "FINISHED!!!! now reboot your system"
