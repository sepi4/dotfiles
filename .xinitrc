xinput disable 10 # off touchpad
setxkbmap -layout "us,fi" -option "grp:lwin_toggle"
feh --bg-scale ~/Pictures/bg_image.jpg # background pictures


if [[ "$(xrandr | grep VGA)" != "" ]]; then

  while true; do
      # Log stderror to a file 
      ~/.dwm_script.sh &
      dwm 2> ~/.dwm.log
      # No error logging
      #dwm >/dev/null 2>&1
  done

  ~/.dwm_script.sh &
  exec dwm

else
  [[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
  exec awesome
fi

#exec i3
