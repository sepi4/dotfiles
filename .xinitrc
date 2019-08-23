#setxkbmap -layout "us,ru -variant phonetic" -option "grp:lwin_toggle"
feh --bg-scale ~/Pictures/bg_image.jpg


if [[ "$(xrandr | grep VGA)" != "" ]]; then

  while true; do
      # Log stderror to a file 
      # ~/.dwmScript.sh &
      dwm 2> ~/.dwm.log
      # No error logging
      #dwm >/dev/null 2>&1
  done

  ~/.dwmScript.sh &
  exec dwm

else
  [[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
  exec awesome
fi

#exec i3
