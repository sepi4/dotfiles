#!/bin/sh
setxkbmap -layout "us,fi" -option "grp:lwin_toggle"
xinput disable 10 # off touchpad

feh --bg-scale ~/Pictures/bg_image.jpg # background pictures

[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

## if thinkpad
# if [[ "$(xrandr | grep VGA)" != "" ]]; then
#  while true; do
#      # Log stderror to a file 
#      ~/.dwm_script.sh &
#      dwm 2> ~/.dwm.log
#      # No error logging
#      #dwm >/dev/null 2>&1
#  done

#  ~/.dwm_script.sh &
#  exec dwm
#else
#  exec awesome
#fi

# if thinkpad
if [[ "$(xrandr | grep VGA)" != "" ]]; then
  pacman -Qqe > pkglistLaptop.txt
else
  pacman -Qqe > pkglistDesktop.txt
fi

#exec i3
exec awesome
# exec spectrwm

