# PACMAN APPS ----------------------------
gui_apps=(
  "awesome"
  "firefox"
  "flameshot" # screenshots with drawing
  "thunar"
  "telegram-desktop"
)

terminal_apps=(
  "alacritty"
  "curl"
  "fastfetch"
  "git"
  "lazygit"
  "neovim"
  "stow" # dotfiles linker
  "wezterm"
  "yazi" # file manager
  "zsh"
)

panel_apps=(
  "blueman" # bluetooth
  "copyq" # clipboard 
  "network-manager-applet" # wifi
  "networkmanager"
  "pasystray" # volumeicon alternative
)

other_apps=(
  "lxappearance" # for change gui apps to dark theme
  "noto-fonts" # nice fonts
  "pamixer" # thinkpad awesome wm volume buttons control
  "rofi"
  "scrot" # screenshots in awesome wm
  "xclip" # global clipboard
)

dev_apps=(
  "base-devel"
  "go"
  "lua"
  "nvm"
)

sudo pacman -S "${gui_apps[@]}"
sudo pacman -S "${terminal_apps[@]}"
sudo pacman -S "${panel_apps[@]}"
sudo pacman -S "${other_apps[@]}"
sudo pacman -S "${dev_apps[@]}"

# NODE SETUP ----------------------------
source /usr/share/nvm/init-nvm.sh
nvm install --lts
nvm use --lts

# AUR APPS ------------------------------
# - yay (aur helper)
cd ~/Downloads
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ~

# brave vscode
yay -S brave-bin visual-studio-code-bin

# # zsh ohmyz
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
