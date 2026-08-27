#!/bin/bash
# Battery status for the wibox: state (battery / wall power), charge
# percentage, and time estimate.
#   On battery: " 83% 2h15m"   (time remaining, icon tracks charge level)
#   Charging:   "⚡ 83% 1h20m"  (time to full)
#   Full:       " 100%"        (plug icon, wall power connected)

set -u

# Nerd Font glyphs (fontconfig falls back to them for the default monospace)
ICON_BATT_FULL=$'\uf240'          # battery full (>= 90%)
ICON_BATT_THREE=$'\uf241'         # three quarters (60-89%)
ICON_BATT_HALF=$'\uf242'          # half (40-59%)
ICON_BATT_QUARTER=$'\uf243'       # quarter (20-39%)
ICON_BATT_EMPTY=$'\uf244'         # empty (< 20%)
ICON_AC_CHARGING=$'\uf0e7'        # lightning bolt = charging from wall power
ICON_AC_PLUGGED=$'\uf1e6'         # plug = wall power connected

# Detect the battery independently of its device name (BAT0, BAT1, ...)
BAT=$(ls -d /sys/class/power_supply/BAT* 2>/dev/null | head -n1)
[ -n "${BAT}" ] || exit 0

STATUS=$(cat "$BAT/status" 2>/dev/null) || STATUS=Unknown
CAP=$(cat "$BAT/capacity" 2>/dev/null) || CAP=0

# Time estimate in minutes. energy (µWh) / power (µW) gives hours; * 60 = minutes.
# With the "full" argument, compute time to full (energy_full - energy_now).
time_minutes() {
	local enow pwr full
	enow=$(cat "$BAT/energy_now" 2>/dev/null) || return 1
	pwr=$(cat "$BAT/power_now" 2>/dev/null) || return 1
	[ "$pwr" -gt 0 ] 2>/dev/null || return 1
	if [ "${1:-}" = "full" ]; then
		full=$(cat "$BAT/energy_full" 2>/dev/null) || return 1
		enow=$(( full - enow ))
		[ "$enow" -gt 0 ] 2>/dev/null || return 1
	fi
	echo $(( enow * 60 / pwr ))
}

fmt_time() { # $1 = minutes -> "2h15m"
	printf '%dh%02dm' $(( $1 / 60 )) $(( $1 % 60 ))
}

case "${CAP}" in
	[9][0-9]|100) ICON=$ICON_BATT_FULL ;;
	[6-8][0-9])   ICON=$ICON_BATT_THREE ;;
	[4-5][0-9])   ICON=$ICON_BATT_HALF ;;
	[2-3][0-9])   ICON=$ICON_BATT_QUARTER ;;
	*)            ICON=$ICON_BATT_EMPTY ;;
esac

case "$STATUS" in
	Discharging)
		OUT="$ICON ${CAP}%"
		if M=$(time_minutes); then
			OUT="$OUT $(fmt_time "$M")"
		fi
		;;
	Charging)
		OUT="$ICON_AC_CHARGING ${CAP}%"
		if M=$(time_minutes full); then
			OUT="$OUT $(fmt_time "$M")"
		fi
		;;
	*) # Full, Not charging, Unknown: wall power is connected
		OUT="$ICON_AC_PLUGGED ${CAP}%"
		;;
esac

echo " $OUT"
