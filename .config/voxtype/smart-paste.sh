#!/bin/bash
# Smart paste: Ctrl+Shift+V for terminals, Ctrl+V for GUI apps
window_class=$(kdotool getactivewindow getwindowclassname 2>/dev/null)

case "$window_class" in
  *terminal*|*konsole*|*wezterm*|*alacritty*|*kitty*|*ghostty*|*foot*|*gnome-terminal*|*xterm*)
    ydotool key ctrl+shift+v
    ;;
  *)
    ydotool key ctrl+v
    ;;
esac
