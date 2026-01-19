#!/usr/bin/env bash

# PACMAN APPS ----------------------------
apps=(
  "firefox"
  "flameshot" # screenshots with drawing
  "thunar"
  "telegram-desktop"

  # terminal apps
  "wezterm"
  "alacritty"
  "curl"
  "fastfetch"
  "git"
  "stow" # dotfiles linker
  "yazi" # file manager
  "zsh"
  "tmux"
  "htop"
  "btop"

  # for neovim
  "neovim"
  "lua"
  "luarocks" # for correct neovim work
  "ripgrep"
  "lazygit"
  "gdu"
  "xclip" # global clipboard

  # sys
  "networkmanager" # internet
  "pipewire-pulse" # audio
  "pipewire-alsa"
  "bluez"  # bluetooth (bluetooth.service need to be enabled)
  "bluez-utils"
  "blueman"

  # dev_apps
  "base-devel"
  "go"

  # awesome wm apps
  "awesome"
  "copyq" # clipboard 
  "lxappearance" # for change gui apps to dark theme
  "papirus-icon-theme" # nice icon gui apps
  "network-manager-applet" # for wifi icon
  "noto-fonts" # nice fonts
  "pamixer" # thinkpad awesome wm volume buttons control
  "pasystray" # volumeicon alternative
  "rofi"
  "scrot" # screenshots in awesome wm
  "xorg"
  "xorg-xinit"
)

sudo pacman -S "${apps[@]}"
