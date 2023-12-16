#!/bin/fish

set answer (echo "Скриншот всего экрана"\n"Скриншот активного окна"\n"Скриншот области" | bemenu --nb "#282828" --nf "#fbf1c7" --tb "#98971a" --tf "#282828" --fb "#282828" --ff "#fbf1c7" --hb "#98971a" --hf "#282828" --ab "#282828" --af "#fbf1c7" -H 10 -M 1100 -c --border 2 --bdr "#98971a" --prompt="Выбери действие: " --list 4 -i --fn "Ubuntu Regular 10")

if test $answer = "Скриншот всего экрана"
   pgrep -x sway || hyprshot -m output
   pgrep -x Hyprland || grim ~/Pictures/screenshots/$(date +"%Y-%m-%d %H:%M")_screenshot.png && dunstify -i ~/Pictures/screenshots/$(date +"%Y-%m-%d %H:%M")_screenshot.png "Скриншот сделан"
else if test $answer = "Скриншот области"
   pgrep -x sway || hyprshot -m region
   pgrep -x Hyprland || grim -g "$(slurp)" ~/Pictures/screenshots/$(date +"%Y-%m-%d %H:%M")_area_screenshot.png && dunstify -i ~/Pictures/screenshots/$(date +"%Y-%m-%d %H:%M")_area_screenshot.png "Скриншот сделан"
else if test $answer = "Скриншот активного окна"
   pgrep -x sway || hyprshot -m window
   pgrep -x Hyprland || grim -g "$(swaymsg -t get_tree | jq -j '.. | select(.type?) | select(.focused).rect | "\(.x),\(.y) \(.width)x\(.height)"')" ~/Pictures/screenshots/$(date +"%Y-%m-%d %H:%M")_window_screenshot.png && dunstify -i ~/Pictures/screenshots/$(date +"%Y-%m-%d %H:%M")_window_screenshot.png "Скриншот сделан"
end
