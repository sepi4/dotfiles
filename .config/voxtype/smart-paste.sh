#!/bin/bash
# Smart paste: Ctrl+Shift+V for terminals, Ctrl+V for GUI apps
window_class=$(kdotool getactivewindow getwindowclassname 2>/dev/null)

case "$window_class" in
  *terminal*|*konsole*|*wezterm*|*alacritty*|*kitty*|*ghostty*|*foot*|*gnome-terminal*|*xterm*)
    # Linux input keycodes: 29=Ctrl, 42=Shift, 47=V. :1 is down, :0 is up.
    ydotool key 29:1 42:1 47:1 47:0 42:0 29:0
    ;;
  *)
    # Linux input keycodes: 29=Ctrl, 47=V. :1 is down, :0 is up.
    ydotool key 29:1 47:1 47:0 29:0
    ;;
esac
