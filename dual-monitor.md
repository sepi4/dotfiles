sudo pacman -S autorandr


# laptop only
autorandr --save single

# dual monitor pluged
xrandr --output VGA-1 --auto --right-of LVDS-1

autorandr --save dual


sudo systemctl enable --now autorandr.service
