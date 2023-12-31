#!/bin/fish

grim ~/Pictures/lockscreen/screenshot.png && convert -blur 18,4 ~/Pictures/lockscreen/screenshot.png ~/Pictures/lockscreen/screenshot.png

playerctl stop

swaylock -i ~/Pictures/lockscreen/screenshot.png -k -l -L --font "Ubuntu Regular" --font-size 15 --inside-color 282828 --inside-clear-color fabd2f --inside-caps-lock-color d65d0e --inside-ver-color 282828 --inside-wrong-color cc241d --key-hl-color ebdbb2 --ring-color 504945 --ring-clear-color fabd2f --ring-caps-lock-color d65d0e --ring-ver-color 504945 --ring-wrong-color cc241d --text-color ebdbb2 --text-clear-color 282828 --text-caps-lock-color 282828 --text-ver-color ebdbb2 --text-wrong-color 282828 --caps-lock-key-hl-color cc241d --bs-hl-color cc241d --caps-lock-bs-hl-color cc241d --line-color 282828 --line-clear-color 282828 --line-caps-lock-color 282828 --line-ver-color 282828 --line-wrong-color 282828 --layout-bg-color 504945 --layout-border-color 282828 --layout-text-color ebdbb2 --indicator-idle-visible --indicator-radius 70 --indicator-thickness 5 --separator 282828
