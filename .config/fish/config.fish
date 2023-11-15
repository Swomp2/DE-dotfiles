if status is-login
   	export PATH="$PATH:/var/lib/flatpak/exports/bin"
	export PATH="$PATH:/usr/local/libexec"
	export PATH="$PATH:/home/swomp/.local/bin"
	export PATH="$PATH:/home/swomp/.cargo/bin"
	export QT_QPA_PLATFORMTHEME="qt5ct"
	export VDPAU_DRIVER="radeonsi"
	export HYPRLAND_CMD=Hyprland
	export XDG_SESSION_TYPE=wayland
	export XDG_CURRENT_DESKTOP=Hyprland
	export HYPRSHOT_DIR="/home/swomp/Pictures/screenshots"
	exec dbus-run-session Hyprland	
end

alias hx="helix"

function fish_prompt
	 echo (set_color normal)'['(set_color "#a3be8c")$USER'|'$hostname(set_color normal)']-'(set_color normal)'['(set_color "#d08770")(pwd)(set_color normal)']-'(set_color normal)"["(set_color "#ebcb8b")(date +"%a %D %I:%M")(set_color normal)"]"(set_color "#8fbcbb")'==>' (set_color normal)
end

function fish_greeting
end
