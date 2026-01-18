#!/usr/bin/env bash

# AUR APPS ------------------------------
# - yay (aur helper)

cd ~
if ! [[ -d "$HOME/$folder" ]]; then
  mkdir "Downloads"
fi
cd Downloads
echo $(pwd)

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ~

# brave vscode
yay -S brave-bin visual-studio-code-bin
