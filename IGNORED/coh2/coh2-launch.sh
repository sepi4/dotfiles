#!/usr/bin/env bash
# Runs a command (the game) with Kanata keybindings that are active only
# while the game window has focus.
# Steam launch options for Company of Heroes 2:
#   /home/sepi4/dotfiles/IGNORED/coh2/coh2-launch.sh gamemoderun mangohud %command% -nomovies -window -fullwindow -forceactive -lockmouse

dir=$(dirname "$(readlink -f "$0")")
kanata="$HOME/.cargo/bin/kanata"
port=7070
# Proton names the game window after the Steam app id of CoH2.
game_class=steam_app_231430

"$kanata" -c "$dir/coh2.kbd" -p "127.0.0.1:$port" &
kanata_pid=$!

set_layer() {
    printf '{"ChangeLayer":{"new":"%s"}}\n' "$1" >"/dev/tcp/127.0.0.1/$port"
}

watch_focus() {
    local current="" wanted
    while true; do
        if [ "$(kdotool getactivewindow getwindowclassname 2>/dev/null)" = "$game_class" ]; then
            wanted=coh0
        else
            wanted=base
        fi
        # Kanata opens its port only after a short startup delay, so a failed
        # send is retried on the next round.
        if [ "$wanted" != "$current" ] && set_layer "$wanted" 2>/dev/null; then
            current=$wanted
        fi
        sleep 0.5
    done
}

watch_focus &
watch_pid=$!

"$@"

kill "$watch_pid" "$kanata_pid"
