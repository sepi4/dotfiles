#!/usr/bin/env bash
# power management for laptops

# https://linrunner.de/tlp/installation/arch.html
sudo pacman -S tlp tlp-pd tlp-rdw

sudo systemctl enable tlp.service
sudo systemctl enable --now tlp-pd.service

