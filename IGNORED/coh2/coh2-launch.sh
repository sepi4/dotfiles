#!/usr/bin/env bash
# Runs a command (the game) with Kanata keybindings active while it runs.
# Steam launch options for Company of Heroes 2:
#   /home/sepi4/dotfiles/IGNORED/coh2/coh2-launch.sh gamemoderun mangohud %command% -nomovies -window -fullwindow -forceactive -lockmouse

dir=$(dirname "$(readlink -f "$0")")
kanata="$HOME/.cargo/bin/kanata"
"$kanata" -c "$dir/coh2.kbd" &
kanata_pid=$!

"$@"

kill "$kanata_pid"
