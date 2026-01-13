# AUR APPS ------------------------------
# - yay (aur helper)

cd ~/Downloads
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ~

# brave vscode
yay -S brave-bin visual-studio-code-bin
