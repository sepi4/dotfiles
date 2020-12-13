#!/bin/sh

[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources
xinput disable 10 # off touchpad
xmodmap -e "keycode 135=Super_R"

# pacman -Qqe > pkglistLaptop.txt

# setxkbmap -layout "us,fi,ru" -variant ',,phonetic' -option "grp:alt_caps_toggle"
# setxkbmap -layout "us,fi" -option "grp:alt_shift_toggle"


setxkbmap -layout "us,fi" -variant -option "grp:alt_caps_toggle"
exec awesome

GTK_IM_MODULE DEFAULT=xim
QT_IM_MODULE  DEFAULT=xim

# exec openbox

# exec dwm

# exec spectrwm

# exec i3

# exec qtile

# exec startxfce4

# exec startplasma-x11

# export XDG_SESSION_TYPE=x11
# export GDK_BACKEND=x11
# exec gnome-session

## if thinkpad
 #if [[ "$(xrandr | grep VGA)" != "" ]]; then

 #while true; do
 #    # Log stderror to a file 
 #    ~/.dwm_script.sh &
 #    dwm 2> ~/.dwm.log
 #    # No error logging
 #    #dwm >/dev/null 2>&1
 #done

 #~/.dwm_script.sh &
 #exec dwm
#else
 # exec awesome
#fi





## if thinkpad
#if [[ "$(xrandr | grep VGA)" != "" ]]; then
#  setxkbmap -layout "us,fi" -option "grp:lwin_toggle"
#  xinput disable 10 # off touchpad

#  feh --bg-scale ~/Pictures/bg_image.jpg # background pictures

#  pacman -Qqe > pkglistLaptop.txt
#  exec awesome
  
#else
#  pacman -Qqe > pkglistDesktop.txt
#  setxkbmap -layout "us,fi" -option "grp:lwin_toggle"

#  exec awesome
  
#  # exec xmonad

#  # exec i3


#  # exec startlxde

#  # export XDG_SESSION_TYPE=x11
#  # export GDK_BACKEND=x11
#  # exec gnome-session
#fi

