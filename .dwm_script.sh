#! /bin/bash

while true
do
  power_now=`cat /sys/class/power_supply/BAT0/power_now`
  if [[ -z "$power_now" ]]; then
    xsetroot -name "${date}"
  else
    energy_now=`cat /sys/class/power_supply/BAT0/energy_now`
    energy_full=`cat /sys/class/power_supply/BAT0/energy_full`
    status=`cat /sys/class/power_supply/BAT0/status`

    if [ "$status" = "Discharging" ]; then
      bat=`echo "scale=2;$energy_now/$power_now" | bc`
      bat="${bat}h"
      sign="-"

    else
      bat="AC"
      sign="+"
    fi

    power_now_watts=`echo "scale=2;$power_now/1000000" | bc`


    date="$(date +"%d.%m %a %H:%M")"

    pro=`echo "scale=2;$energy_now/$energy_full" | bc`
    pro="${pro:1}"

    net=`iw dev wlp3s0 link | awk '/SSID/{print $2}'`
    xsetroot -name " ${net} | ${pro}% ${bat} ${sign}${power_now_watts}W | ${date}"
  fi


	sleep 2
done

