#!/usr/bin/env bash

# PACMAN APPS ----------------------------
apps=(
  "awesome"
  "firefox"
  "flameshot" # screenshots with drawing
  "thunar"
  "telegram-desktop"

  # terminal apps
  "alacritty"
  "wezterm"
  "curl"
  "fastfetch"
  "git"
  "stow" # dotfiles linker
  "yazi" # file manager
  "zsh"
  "tmux"

  # for neovim
  "neovim"
  "lua"
  "luarocks" # for correct neovim work
  "ripgrep"
  "lazygit"
  "gdu"
  "xclip" # global clipboard

  # dev_apps
  "base-devel"
  "go"

  # awesome wm apps
  "blueman" # bluetooth
  "copyq" # clipboard 
  "network-manager-applet" # wifi
  "networkmanager"
  "pasystray" # volumeicon alternative
  "pamixer" # thinkpad awesome wm volume buttons control
  "lxappearance" # for change gui apps to dark theme
  "noto-fonts" # nice fonts
  "rofi"
  "scrot" # screenshots in awesome wm
)

sudo pacman -S "${apps[@]}"
