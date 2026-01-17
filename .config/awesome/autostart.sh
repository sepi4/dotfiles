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
run pasystray # pasystray (volume) 
# -- volumeicon (would be better, but not working)

setxkbmap -option grp:win_space_toggle us,fi

# -- also:
# -- - noto-fonts (nice fonts using in awesome wm)
# -- - lxappearance (to change themes of thunar, pcmanfm...)
# -- - scrot, xclip (screenshots, nvim global clipboard)
