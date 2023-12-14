if status is-login
   	export PATH="$PATH:/var/lib/flatpak/exports/bin"
	export PATH="$PATH:/usr/local/libexec"
	export PATH="$PATH:/home/swomp/.local/bin"
	export PATH="$PATH:/home/swomp/.cargo/bin"
end

export VISUAL=hx

function fish_prompt
	 echo (set_color normal)'['(set_color "#b8bb26")$USER'|'$hostname(set_color normal)']-'(set_color normal)'['(set_color "#fe8019")(pwd)(set_color normal)']-'(set_color normal)"["(set_color "#fabd2f")(date +"%a %D %I:%M")(set_color normal)"]"(set_color "#83a598")'==>' (set_color normal)
end

function fish_greeting
end
