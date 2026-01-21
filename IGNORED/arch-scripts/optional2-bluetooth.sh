#!/usr/bin/env bash
# bluethooth for laptops

sudo pacman -S bluez bluez-utils blueman

sudo systemctl enable bluetooth.service

