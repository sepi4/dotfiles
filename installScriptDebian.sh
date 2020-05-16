# !/usr/bin/sh
#  add user to sudoers before running this script

# apt install sudo -yy
# /usr/bin/usermod -aG sudo $user

checkUserExists() {
    cd ~
    homeDir=/home/$USER
    [ ! -d "$homeDir" ] && echo "no user dir: " && exit 1
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
        git \
        linux-headers-$(uname -r) \
        xorg \
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
        libx11-dev \
        libxinerama-dev \
        build-essential \
        chromium \
        w3m \
        telegram-desktop \
        dkms \
        network-manager-gnome \
        zathura \
        scrot \
        sxiv \
        pulseaudio \
        pavucontrol \
        pasystray \
        pcmanfm -yy
    
}




awesomeWidgets() {
    git clone https://github.com/streetturtle/awesome-wm-widgets.git \
        ~/.config/awesome/awesome-wm-widgets
}


virtualBoxAppInstall() {
    sudo mkdir /mnt/cd
    sudo mount -t iso9660 -o ro,loop ~/Downloads/VBoxGuestAdditions_$virtualboxVersion.iso /mnt/cd/
    cp /mnt/cd/VBoxLinuxAdditions.run ~/Downloads/VBoxLinuxAdditions.run
    sudo umount /mnt/cd
    sudo ~/Downloads/./VBoxLinuxAdditions.run
}

addDotfilesGit() {
    echo ".cfg" >> .gitignore
    git clone --bare https://github.com/sepi4/dotfiles.git $HOME/.cfg

    mkdir -p .config-backup && \
        /usr/bin/git --git-dir=/home/sepi4/.cfg/ --work-tree=/home/sepi4 \
        checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
        xargs -I{} mv {} .config-backup/{}

    /usr/bin/git --git-dir=/home/sepi4/.cfg/ --work-tree=/home/sepi4 \
        checkout

    /usr/bin/git --git-dir=/home/sepi4/.cfg/ --work-tree=/home/sepi4 \
        config --local status.showUntrackedFiles no
}



echo "CHECKINGS"
checkUserExists
virtualBox

echo "NOW starts LONG INSTALL"
sleep 2

addNonFree
installApps
addDotfilesGit
awesomeWidgets
virtualBoxAppInstall

echo "FINISHED!!!! now reboot your system"
