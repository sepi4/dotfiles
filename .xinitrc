#setxkbmap -layout "us,ru -variant phonetic" -option "grp:lwin_toggle"
feh --bg-scale ~/Pictures/bg_image.jpg


if [[ "$(xrandr | grep VGA1)" != "" ]]; then
  exec dwm
else
  [[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
  exec awesome
fi

#exec i3

# kissa istuu
