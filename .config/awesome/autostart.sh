#!/bin/bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

run nm-applet # networkmanager, network-manager-applet (wifi)
run copyq # copyq
run blueman-applet # blueman (bluetooth)
# run volumeicon # for voidlinux
run pasystray # for archlinux (volumeicon not working)

setxkbmap -option grp:win_space_toggle us,fi

# -- also:
# -- - lxappearance (to change themes of thunar, pcmanfm...)
# -- - scrot, xclip (screenshots, nvim global clipboard)
