#!/bin/bash

setup_configs() {
rm -rf ~/.config/fastfetch
rm -rf ~/.config/starship
rm -rf ~/.bashrc
rm -rf ~/.config/nvim
rm -rf ~/.config/fish
mkdir -p ~/.config/fish
mkdir -p ~/.config/fastfetch
mkdir -p ~/.config/starship

cat <<'EOFFISH' > ~/.config/fish/config.fish
function fish_greeting
    fastfetch
end

# Format man pages
set -x MANROFFOPT "-c"
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

# Set settings for https://github.com/franciscolourenco/done
set -U __done_min_cmd_duration 10000
set -U __done_notification_urgency_level low

## Environment setup
# Apply .profile: use this to put fish compatible .profile stuff in
if test -f ~/.fish_profile
  source ~/.fish_profile
end

# Append common directories for executable files to /home/eric/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/var/lib/flatpak/exports/bin:/usr/lib/jvm/default/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:/usr/lib/rustup/bin
fish_add_path ~/.local/bin ~/.cargo/bin ~/Applications/depot_tools

## Functions
# Functions needed for !! and !$ https://github.com/oh-my-fish/plugin-bang-bang
function __history_previous_command
  switch (commandline -t)
  case "!"
    commandline -t [1]; commandline -f repaint
  case "*"
    commandline -i !
  end
end

function __history_previous_command_arguments
  switch (commandline -t)
  case "!"
    commandline -t ""
    commandline -f history-token-search-backward
  case "*"
    commandline -i '$'
  end
end

if [ "" = fish_vi_key_bindings ];
  bind -Minsert ! __history_previous_command
  bind -Minsert '$' __history_previous_command_arguments
else
  bind ! __history_previous_command
  bind '$' __history_previous_command_arguments
end

# Fish command history
function history
    builtin history --show-time='%F %T ' 
end

function backup --argument filename
    cp  .bak
end

# Copy DIR1 DIR2
function copy
    set count (count  | tr -d \n)
    if test "" = 2; and test -d "[1]"
        set from (echo [1] | trim-right /)
        set to (echo [2])
        command cp -r  
    else
        command cp 
    end
end

## Useful aliases
# Replace ls with eza
alias ls='eza -al --color=always --group-directories-first --icons=always' # preferred listing
alias la='eza -a --color=always --group-directories-first --icons=always'  # all files and dirs
alias ll='eza -l --color=always --group-directories-first --icons=always'  # long format
alias lt='eza -aT --color=always --group-directories-first --icons=always' # tree listing
alias l.="eza -a | grep -e '^\.'"                                     # show only dotfiles

# Common use
alias grubup="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias fixpacman="sudo rm /var/lib/pacman/db.lck"
alias tarnow='tar -acf '
alias untar='tar -zxvf '
alias wget='wget -c '
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'

alias apt='sudo apt'

alias cleanup='sudo pacman -Rns (pacman -Qtdq)'

alias jctl="journalctl -p 3 -xb"

alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"
alias dnf='sudo dnf'
alias nala='sudo nala'
alias pacman='sudo pacman'
alias xbps-install="sudo xbps-install"
alias xbps-remove="sudo xbps-remove"
alias apk='sudo apk'
alias vim='nvim'
set -Ux STARSHIP_CONFIG "/home/$USER/.config/starship/starship.toml"
alias yt-dlp='yt-dlp -f "bestaudio" -x --audio-format mp3 --embed-metadata --embed-thumbnail -o "%(title)s.%(ext)s"'
starship init fish | source
EOFFISH
	cat <<EOFF > ~/.config/fastfetch/config.jsonc
{
  "": "https://github.com/fastfetch-cli/fastfetch/raw/master/doc/json_schema.json",
  "modules": [
    "title",
	"separator",
	"os",
	"uptime",
	"host",
	"disk",
	"memory",
	"packages",
	"kernel",
	"terminal",
	"cpu",
	"gpu",
	"localip",
	"battery",
	"break",
	"colors"
  ]
}
EOFF
	cat <<'EOFS' > ~/.config/starship/starship.toml
format = """
$username$hostname$directory$git_branch$git_status$fill$python$lua$nodejs$golang$haskell$rust$package$cmd_duration
$character"""
add_newline = true
palette = 'nord'

[username]
show_always = true
style_user = 'bold white'
format = '[$user]($style)'

[hostname]
ssh_only = false
style = 'bold white'
format = '[@$hostname]($style) '


[character]
success_symbol = '[❯](bold green)'
error_symbol = '[❯](bold red)'


[directory]
style = 'bold fg:dark_blue'
format = '[$path]($style)'
truncation_length = 3
truncation_symbol = '…/'
truncate_to_repo = false

#[directory.substitutions]
#'Documents' = '󰈙'
#'Downloads' = ' '
#'Music' = ' '
#'Pictures' = ' '

[git_branch]
style = 'fg:green'
symbol = ' '
format = '[$symbol$branch]($style) '

[git_status]
style = 'fg:green'
format = '([]() )'

[fill]
symbol = ' '

[python]
style = 'teal'
symbol = ' '
format = '[( )(\(\) )]()'
pyenv_version_name = true
pyenv_prefix = ''

[lua]
symbol = ' '

[nodejs]
style = 'blue'
symbol = ' '

[golang]
style = 'blue'
symbol = ' '

[haskell]
style = 'blue'
symbol = ' '

[rust]
style = 'orange'
symbol = ' '

[ruby]
style = 'blue'
symbol = ' '

[package]
symbol = '󰏗 '

[aws]
symbol = ' '
style = 'yellow'
format = '[( )(\[\] )]()'

[docker_context]
symbol = ' '
style = 'fg:#06969A'
format = '[]() '
detect_files = ['docker-compose.yml', 'docker-compose.yaml', 'Dockerfile']
detect_extensions = ['Dockerfile']

[jobs]
symbol = ' '
style = 'red'
number_threshold = 1
format = '[]()'

[cmd_duration]
min_time = 500
style = 'fg:gray'
format = '[]()'

[palettes.nord]
dark_blue = '#5E81AC'
blue = '#81A1C1'
teal = '#88C0D0'
red = '#BF616A'
orange = '#D08770'
green = '#A3BE8C'
yellow = '#EBCB8B'
purple = '#B48EAD'
gray = '#434C5E'
black = '#2E3440'
white='#D8DEE9'

[palettes.onedark]
dark_blue='#61afef'
blue='#56b6c2'
red='#e06c75'
green='#98c379'
purple='#c678dd'
cyan='#56b6c2'
orange='#be5046'
yellow='#e5c07b'
gray='#828997'
white ='#abb2bf'
black='#2c323c'
EOFS

	cat <<EOFB > ~/.bashrc
fastfetch
## Useful aliases
# Replace ls with eza
alias ls='eza -al --color=always --group-directories-first --icons=always' # preferred listing
alias la='eza -a --color=always --group-directories-first --icons=always'  # all files and dirs
alias ll='eza -l --color=always --group-directories-first --icons=always'  # long format
alias lt='eza -aT --color=always --group-directories-first --icons=always' # tree listing
alias l.="eza -a | grep -e '^\.'"                                     # show only dotfiles

# Common use
alias grubup="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias fixpacman="sudo rm /var/lib/pacman/db.lck"
alias tarnow='tar -acf '
alias untar='tar -zxvf '
alias wget='wget -c '
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'

alias apt='sudo apt'

alias cleanup='sudo pacman -Rns (pacman -Qtdq)'

alias jctl="journalctl -p 3 -xb"

alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"
alias dnf='sudo dnf'
alias nala='sudo nala'
alias pacman='sudo pacman'
alias vim='nvim'
export STARSHIP_CONFIG="/home/$USER/.config/starship/starship.toml"
eval "$(starship init bash)"
EOFB

	cat <<EOFVIM > ~/.vimrc
set number
syntax on

set tabstop=4
set shiftwidth=4
set expandtab
set mouse=a

" Keybinds
map <F2> :wq<CR>
map <F5> :q!<CR> 
EOFVIM

	cat <<EOFNVIM > ~/.config/nvim/init.vim
set number
syntax on

set tabstop=4
set shiftwidth=4
set expandtab
set mouse=a

" Keybinds
map <F2> :wq<CR>
map <F5> :q!<CR> 
EOFNVIM
}

if ! command -v systemctl >/dev/null 2>&1; then
	echo "You Don't Use Systemd, So This Script Will Fail!"
	sleep 3
	clear
	exit
fi

PS3="Would You Like To Setup Your Whole System (Includes Configs And Bluetooth w/ SSH), Change Configs, Or Setup Bluetooth & SSH?
"
options=("Setup Whole System" "Change Configs" "Bluetooth & SSH")
select opt in "${options[@]}"
do
    case $opt in
        "Setup Whole System")
if command -v pacman >/dev/null 2>&1 && command -v systemctl >/dev/null 2>&1; then
  echo "Arch Found (With Systemd) !"
    sleep 2
    clear
	cat << "EOF"

	██╗  ██╗███████╗███╗   ██╗
	╚██╗██╔╝██╔════╝████╗  ██║
	 ╚███╔╝ █████╗  ██╔██╗ ██║
	 ██╔██╗ ██╔══╝  ██║╚██╗██║
	██╔╝ ██╗███████╗██║ ╚████║
	╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝

   		    0% Done!
	Updating System And Installing Stuff!
EOF
	  sudo pacman -Syu --noconfirm >/dev/null 2>&1 || { clear; echo "You are NOT connected to the internet!"; exit 1; }
      sudo pacman -S wget kwalletmanager python plasma dolphin konsole discover sddm wl-clipboard curl git 7zip nano btop fastfetch wl-clipboard acpi power-profiles-daemon usbutils okular eog base-devel bat vim scrcpy gvfs yt-dlp networkmanager --needed --noconfirm >/dev/null 2>&1 || { echo "You are NOT connected to the internet!"; exit 1; }
cd /home/"$USER" || exit
clear
	cat << "EOF"

	██╗  ██╗███████╗███╗   ██╗
	╚██╗██╔╝██╔════╝████╗  ██║
	 ╚███╔╝ █████╗  ██╔██╗ ██║
	 ██╔██╗ ██╔══╝  ██║╚██╗██║
	██╔╝ ██╗███████╗██║ ╚████║
	╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝

   		    10% Done!
EOF

mv ~/paru ~/paruBackup >/dev/null 2>&1 || true
		git clone https://aur.archlinux.org/paru.git >/dev/null 2>&1 || { echo "Clone Failed! Please Install Git And Dependencies!"; exit 1; }
		cd ~/paru || { echo "Folder Paru Not Found"; exit 1; }
        clear
	cat << "EOF"

	██╗  ██╗███████╗███╗   ██╗
	╚██╗██╔╝██╔════╝████╗  ██║
	 ╚███╔╝ █████╗  ██╔██╗ ██║
	 ██╔██╗ ██╔══╝  ██║╚██╗██║
	██╔╝ ██╗███████╗██║ ╚████║
	╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝

   		    13% Done!
EOF
		echo "Installing Paru AUR Helper . . ."
		makepkg -si --noconfirm >/dev/null 2>&1 || { clear; echo "This Likely Failed Because You Ran The Script As Root Or You're The Root User Instead Of A Standard User"; cd /home/"$USER" || true; rm -rf paru; exit 1; }
	cd /home/"$USER" || exit
rm -rf ~/paru

clear
	cat << "EOF"
	cat << "EOF"

	██╗  ██╗███████╗███╗   ██╗
	╚██╗██╔╝██╔════╝████╗  ██║
	 ╚███╔╝ █████╗  ██╔██╗ ██║
	 ██╔██╗ ██╔══╝  ██║╚██╗██║
	██╔╝ ██╗███████╗██║ ╚████║
	╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝

   		    35% Done!
EOF

PS3="Would You Like Bluetooth?
"
options=("Yes" "No")
select opt in "${options[@]}"
do
	case $opt in
		"Yes")
			sudo pacman -S bluez bluez-utils --noconfirm >/dev/null 2>&1 || { echo "Failed To Install Bluetooth, Please Check Your Internet Connection!"; exit 1; }
			sudo systemctl enable --now bluetooth >/dev/null 2>&1 || true
bluetoothctl <<EOF
power on
agent on
default-agent
exit
EOF
			break
			;;
		"No")
			break
			;;
		esac
	done

clear
	cat << "EOF"

	██╗  ██╗███████╗███╗   ██╗
	╚██╗██╔╝██╔════╝████╗  ██║
	 ╚███╔╝ █████╗  ██╔██╗ ██║
	 ██╔██╗ ██╔══╝  ██║╚██╗██║
	██╔╝ ██╗███████╗██║ ╚████║
	╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝

   		    42% Done!
EOF

PS3="Would You Like ADB And Fastboot, Along With Heimdall? (If You Don't Know What These Are, You Don't Need Them)
"
options=("Yes" "No")
select opt in "${options[@]}"
do
	case $opt in
		"Yes")
			sudo pacman -S android-tools heimdall android-udev gvfs-mtp --noconfirm >/dev/null 2>&1 || { echo "Failed To Install ADB And Fastboot, Please Check Your Internet Connection!"; exit 1; }
			break
			;;
		"No")
			break
			;;
		esac
	done

clear
	cat << "EOF"

	██╗  ██╗███████╗███╗   ██╗
	╚██╗██╔╝██╔════╝████╗  ██║
	 ╚███╔╝ █████╗  ██╔██╗ ██║
	 ██╔██╗ ██╔══╝  ██║╚██╗██║
	██╔╝ ██╗███████╗██║ ╚████║
	╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝

   		    60% Done!
EOF
PS3="Would You Like To Install SSH? (A Program That Allows You To Type In Other Linux Computers Or Type In Your Terminal From Another Computer)
"
options=("Yes" "No")
select opt in "${options[@]}"
do
	case $opt in
		"Yes")
			sudo pacman -S openssh --noconfirm >/dev/null 2>&1 || { echo "Failed To Install SSH, Please Check Your Internet Connection!"; exit 1; }
			sudo systemctl enable sshd >/dev/null 2>&1 || true
			sudo systemctl start sshd >/dev/null 2>&1 || true
			break
			;;
		"No")
			break
			;;
		esac
	done

clear
	cat << "EOF"

	██╗  ██╗███████╗███╗   ██╗
	╚██╗██╔╝██╔════╝████╗  ██║
	 ╚███╔╝ █████╗  ██╔██╗ ██║
	 ██╔██╗ ██╔══╝  ██║╚██╗██║
	██╔╝ ██╗███████╗██║ ╚████║
	╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝

   		    65% Done!
EOF

setup_configs

clear
	cat << "EOF"

	██╗  ██╗███████╗███╗   ██╗
	╚██╗██╔╝██╔════╝████╗  ██║
	 ╚███╔╝ █████╗  ██╔██╗ ██║
	 ██╔██╗ ██╔══╝  ██║╚██╗██║
	██╔╝ ██╗███████╗██║ ╚████║
	╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝

   		    76% Done!
EOF

	paru -S balena-etcher --noconfirm >/dev/null 2>&1 || true
	paru -S ventoy-bin --noconfirm >/dev/null 2>&1 || true
	paru -S qdl --noconfirm >/dev/null 2>&1 || true
	paru -S kde-material-you-colors --noconfirm >/dev/null 2>&1 || true
cd /home/"$USER" || exit
clear
	cat << "EOF"

	██╗  ██╗███████╗███╗   ██╗
	╚██╗██╔╝██╔════╝████╗  ██║
	 ╚███╔╝ █████╗  ██╔██╗ ██║
	 ██╔██╗ ██╔══╝  ██║╚██╗██║
	██╔╝ ██╗███████╗██║ ╚████║
	╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝

   		    80% Done!
EOF

sudo systemctl enable NetworkManager sddm.service power-profiles-daemon.service >/dev/null 2>&1 || true
sudo systemctl start power-profiles-daemon.service >/dev/null 2>&1 || true

PS3='Would You Like Firefox, Chrome, None, or Something Else?
'
options=("Firefox" "Google Chrome" "Something Else" "None")

select opt in "${options[@]}"
do
	case $opt in
		"Firefox")
			sudo pacman -S firefox >/dev/null 2>&1 || true
			break
			;;
		"Google Chrome")
			paru -S google-chrome --noconfirm >/dev/null 2>&1 || true
			break
			;;
		"None")
			break
			;;
		"Something Else")
				sudo -v
				PS3='Brave, Zen Browser, Chromium, Librewolf, or None Of The Above?
				'
				options=("Brave" "Zen" "Chromium" "Librewolf" "None")

				select opt in "${options[@]}"
				do
					case $opt in
						"Brave")
							paru -S brave-bin --noconfirm >/dev/null 2>&1 || true
							break
							;;
						"Zen")
							paru -S zen-browser-bin --noconfirm >/dev/null 2>&1 || true
							break
							;;
						"Chromium")
							sudo pacman -S chromium --noconfirm >/dev/null 2>&1 || true
							break
							;;
						"Librewolf")
							paru -S librewolf-bin --noconfirm >/dev/null 2>&1 || true
							break
							;;
						"None")
							break
							;;
						*)
							echo "Invalid Option $REPLY"
							;;
						esac
						done
						break
					;;
		*)
			echo "Invalid Option $REPLY"
			;;
esac
done

clear
	cat << "EOF"

	██╗  ██╗███████╗███╗   ██╗
	╚██╗██╔╝██╔════╝████╗  ██║
	 ╚███╔╝ █████╗  ██╔██╗ ██║
	 ██╔██╗ ██╔══╝  ██║╚██╗██║
	██╔╝ ██╗███████╗██║ ╚████║
	╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝

   		    90% Done!
EOF


PS3='Would You Like Localsend, Discord, Neither, or Both?
'
options=("Localsend" "Discord" "Both" "Neither")

select opt in "${options[@]}"
do
	case $opt in
		"Localsend")
			paru -S localsend-bin --noconfirm >/dev/null 2>&1 || true
			break
			;;
		"Discord")
			sudo pacman -S discord --noconfirm >/dev/null 2>&1 || true
			break
			;;
		"Both")
			sudo pacman -S discord --noconfirm >/dev/null 2>&1 || true
			paru -S localsend-bin --noconfirm >/dev/null 2>&1 || true
			break
			;;
		"Neither")
			break
			;;
	esac
	done

clear
	cat << "EOF"

	██╗  ██╗███████╗███╗   ██╗
	╚██╗██╔╝██╔════╝████╗  ██║
	 ╚███╔╝ █████╗  ██╔██╗ ██║
	 ██╔██╗ ██╔══╝  ██║╚██╗██║
	██╔╝ ██╗███████╗██║ ╚████║
	╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝

   		    100% Done!
EOF
sudo systemctl enable NetworkManager power-profiles-daemon.service >/dev/null 2>&1 || true
if command -v sddm; then
	sudo systemctl enable sddm.service >/dev/null 2>&1 || true
fi

echo "Changing your shell typically requires a restart for it to fully take affect, would you like to reboot?"
PS3='What Would You Like To Do?
'
options=("Restart" "Exit To Typing")

select opt in "${options[@]}"
do
	case $opt in
		"Restart")
			sudo reboot now
			;;
		"Exit To Typing")
			exit
			;;
		*)
			echo "Invalid Option $REPLY"
			;;
	esac
done

elif command -v apt >/dev/null 2>&1; then
  echo "Ubuntu/Debian Found!"
    sleep 2
    clear
	cat << "EOF"

	██╗  ██╗███████╗███╗   ██╗
	╚██╗██╔╝██╔════╝████╗  ██║
	 ╚███╔╝ █████╗  ██╔██╗ ██║
	 ██╔██╗ ██╔══╝  ██║╚██╗██║
	██╔╝ ██╗███████╗██║ ╚████║
	╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝

0% Done! Currently Updating Silently!
EOF
		sudo apt update && sudo apt upgrade -y >/dev/null 2>&1 || { echo "You are NOT connected to the internet!"; exit 1; }
    clear
	cat << "EOF"

	██╗  ██╗███████╗███╗   ██╗
	╚██╗██╔╝██╔════╝████╗  ██║
	 ╚███╔╝ █████╗  ██╔██╗ ██║
	 ██╔██╗ ██╔══╝  ██║╚██╗██║
	██╔╝ ██╗███████╗██║ ╚████║
	╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝

   		    12% Done!
EOF
		sudo apt install kwalletmanager nala python3 wl-clipboard qdl network-manager libfuse2 7zip curl eog acpi flatpak vim bat nano power-profiles-daemon gvfs -y >/dev/null 2>&1 || { echo "You are NOT connected to the internet!"; exit 1; }
    clear
	cat << "EOF"

	██╗  ██╗███████╗███╗   ██╗
	╚██╗██╔╝██╔════╝████╗  ██║
	 ╚███╔╝ █████╗  ██╔██╗ ██║
	 ██╔██╗ ██╔══╝  ██║╚██╗██║
	██╔╝ ██╗███████╗██║ ╚████║
	╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝

   		    25% Done!
EOF
		flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
		sudo apt remove konqueror -y >/dev/null 2>&1 || true
		sudo apt autoremove -y >/dev/null 2>&1 || true
    clear
	cat << "EOF"

	██╗  ██╗███████╗███╗   ██╗
	╚██╗██╔╝██╔════╝████╗  ██║
	 ╚███╔╝ █████╗  ██╔██╗ ██║
	 ██╔██╗ ██╔══╝  ██║╚██╗██║
	██╔╝ ██╗███████╗██║ ╚████║
	╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝

   		    33% Done!
EOF
	sudo systemctl enable NetworkManager power-profiles-daemon.service >/dev/null 2>&1 || true

PS3="Would You Like To Install KDE? (A Desktop Environment That Actually Lets You Use Your Computer Like Windows Instead Of Living In A Black Box)
"
options=("Yes" "No")
select opt in "${options[@]}"
do
	case $opt in
		"Yes")
			sudo nala install task-kde-desktop sddm plasma-discover-backend-flatpak discover -y >/dev/null 2>&1 || { echo "Failed To Install KDE, Please Check Your Internet Connection!"; exit 1; }
			break
			;;
		"No")
			break
			;;
		esac
	done

    clear
	cat << "EOF"

	██╗  ██╗███████╗███╗   ██╗
	╚██╗██╔╝██╔════╝████╗  ██║
	 ╚███╔╝ █████╗  ██╔██╗ ██║
	 ██╔██╗ ██╔══╝  ██║╚██╗██║
	██╔╝ ██╗███████╗██║ ╚████║
	╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝

   		    46% Done!
EOF

PS3="Would You Like ADB And Fastboot, Along With Heimdall? (If You Don't Know What These Are, You Don't Need Them)
"
options=("Yes" "No")
select opt in "${options[@]}"
do
	case $opt in
		"Yes")
			sudo nala install adb fastboot heimdall-flash -y >/dev/null 2>&1 || { echo "Failed To Install ADB And Fastboot, Please Check Your Internet Connection!"; exit 1; }
			break
			;;
		"No")
			break
			;;
		esac
	done

    clear
	cat << "EOF"

	██╗  ██╗███████╗███╗   ██╗
	╚██╗██╔╝██╔════╝████╗  ██║
	 ╚███╔╝ █████╗  ██╔██╗ ██║
	 ██╔██╗ ██╔══╝  ██║╚██╗██║
	██╔╝ ██╗███████╗██║ ╚████║
	╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝

   		    55% Done!
EOF

PS3="Would You Like To Install SSH? (A Program That Allows You To Type In Other Linux Computers Or Type In Your Terminal From Another Computer)
"
options=("Yes" "No")
select opt in "${options[@]}"
do
	case $opt in
		"Yes")
			sudo nala install ssh -y >/dev/null 2>&1 || { echo "Failed To Install SSH, Please Check Your Internet Connection!"; exit 1; }
			sudo systemctl enable ssh >/dev/null 2>&1 || true
			sudo systemctl start ssh >/dev/null 2>&1 || true
			break
			;;
		"No")
			break
			;;
		esac
	done

    clear
	cat << "EOF"

	██╗  ██╗███████╗███╗   ██╗
	╚██╗██╔╝██╔════╝████╗  ██║
	 ╚███╔╝ █████╗  ██╔██╗ ██║
	 ██╔██╗ ██╔══╝  ██║╚██╗██║
	██╔╝ ██╗███████╗██║ ╚████║
	╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝

   		    67% Done!
EOF

setup_configs

    clear
	cat << "EOF"

	██╗  ██╗███████╗███╗   ██╗
	╚██╗██╔╝██╔════╝████╗  ██║
	 ╚███╔╝ █████╗  ██╔██╗ ██║
	 ██╔██╗ ██╔══╝  ██║╚██╗██║
	██╔╝ ██╗███████╗██║ ╚████║
	╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝

   		    75% Done!
EOF

PS3="What Browser Would You Like?
"
options=("Firefox" "Chrome" "Skip")
select opt in "${options[@]}"
do
	case $opt in
		"Firefox")
			sudo nala install firefox -y >/dev/null 2>&1 || { echo "Failed To Install Firefox, Please Check Your Internet Connection!"; exit 1; }
			clear
			break
			;;
		"Chrome")
			wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb >/dev/null 2>&1 || { echo "Failed To Download Chrome, Please Check Your Internet Connection!"; exit 1; }
			sudo nala install ./google-chrome-stable_current_amd64.deb -y >/dev/null 2>&1 || { echo "Failed To Install Chrome, Please Check Your Internet Connection!"; exit 1; }
			rm google-chrome* >/dev/null 2>&1 || true
			clear
			break
			;;
		"Skip")
			break
			;;
		*)
			echo "Invalid Option: $REPLY"
			;;
		esac
	done

    clear
	cat << "EOF"

	██╗  ██╗███████╗███╗   ██╗
	╚██╗██╔╝██╔════╝████╗  ██║
	 ╚███╔╝ █████╗  ██╔██╗ ██║
	 ██╔██╗ ██╔══╝  ██║╚██╗██║
	██╔╝ ██╗███████╗██║ ╚████║
	╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝

   		    90% Done!
EOF

PS3="Would You Like To Reboot (Recommended), Go Straight To KDE, Or Exit The Script Now?
"
options=("Reboot" "KDE" "Exit")
select opt in "${options[@]}"
do
	case $opt in
		"Reboot")
			sudo systemctl enable sddm.service >/dev/null 2>&1 || true
			sudo systemctl reboot
			;;
		"KDE")
			sudo systemctl start sddm.service
			;;
		"Exit")
			exit
			;;
		*)
			echo "Invalid Option: $REPLY"
			;;
		esac
	done

elif command -v dnf >/dev/null 2>&1; then
  echo "Fedora Found!"
  	sleep 2
  	    clear
	cat << "EOF"

	██╗  ██╗███████╗███╗   ██╗
	╚██╗██╔╝██╔════╝████╗  ██║
	 ╚███╔╝ █████╗  ██╔██╗ ██║
	 ██╔██╗ ██╔══╝  ██║╚██╗██║
	██╔╝ ██╗███████╗██║ ╚████║
	╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝

   	0% Done! Updating Silently!
EOF
		sudo dnf update -y >/dev/null 2>&1 || { echo "You are NOT connected to the internet!"; exit 1; }
		sudo dnf install kwalletmanager python3 yt-dlp fastfetch nano vim wl-clipboard curl flatpak 7zip git acpi power-profiles-daemon usbutils -y --allowerasing >/dev/null 2>&1 || { echo "You are NOT connected to the internet!"; exit 1; }
    clear
	cat << "EOF"

	██╗  ██╗███████╗███╗   ██╗
	╚██╗██╔╝██╔════╝████╗  ██║
	 ╚███╔╝ █████╗  ██╔██╗ ██║
	 ██╔██╗ ██╔══╝  ██║╚██╗██║
	██╔╝ ██╗███████╗██║ ╚████║
	╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝

   		    12% Done!
EOF
		sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	clear
	sudo flatpak install flathub org.localsend.localsend_app -y >/dev/null 2>&1 || true
    clear
	cat << "EOF"

	██╗  ██╗███████╗███╗   ██╗
	╚██╗██╔╝██╔════╝████╗  ██║
	 ╚███╔╝ █████╗  ██╔██╗ ██║
	 ██╔██╗ ██╔══╝  ██║╚██╗██║
	██╔╝ ██╗███████╗██║ ╚████║
	╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝

   		    19% Done!
EOF

PS3="Would You Like ADB And Fastboot, Along With Heimdall? (If You Don't Know What These Are, You Don't Need Them)
"
options=("Yes" "No")
select opt in "${options[@]}"
do
	case $opt in
		"Yes")
			sudo dnf install android-tools heimdall gvfs-mtp -y >/dev/null 2>&1 || { echo "Failed To Install ADB And Fastboot, Please Check Your Internet Connection!"; exit 1; }
			break
			;;
		"No")
			break
			;;
		esac
	done

    clear
	cat << "EOF"

	██╗  ██╗███████╗███╗   ██╗
	╚██╗██╔╝██╔════╝████╗  ██║
	 ╚███╔╝ █████╗  ██╔██╗ ██║
	 ██╔██╗ ██╔══╝  ██║╚██╗██║
	██╔╝ ██╗███████╗██║ ╚████║
	╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝

   		    24% Done!
EOF

PS3="Would You Like To Install SSH? (A Program That Allows You To Type In Other Linux Computers Or Type In Your Terminal From Another Computer)
"
options=("Yes" "No")
select opt in "${options[@]}"
do
	case $opt in
		"Yes")
			sudo dnf install ssh -y >/dev/null 2>&1 || { echo "Failed To Install SSH, Please Check Your Internet Connection!"; exit 1; }
			sudo systemctl enable sshd >/dev/null 2>&1 || true
			sudo systemctl start sshd >/dev/null 2>&1 || true
			break
			;;
		"No")
			break
			;;
		esac
	done

    clear
	cat << "EOF"

	██╗  ██╗███████╗███╗   ██╗
	╚██╗██╔╝██╔════╝████╗  ██║
	 ╚███╔╝ █████╗  ██╔██╗ ██║
	 ██╔██╗ ██╔══╝  ██║╚██╗██║
	██╔╝ ██╗███████╗██║ ╚████║
	╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝

   		    30% Done!
EOF

setup_configs

    clear
	cat << "EOF"

	██╗  ██╗███████╗███╗   ██╗
	╚██╗██╔╝██╔════╝████╗  ██║
	 ╚███╔╝ █████╗  ██╔██╗ ██║
	 ██╔██╗ ██╔══╝  ██║╚██╗██║
	██╔╝ ██╗███████╗██║ ╚████║
	╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝

   		    57% Done!
EOF

PS3="What Browser Would You Like?
"
options=("Firefox" "Chrome")
select opt in "${options[@]}"
do
	case $opt in
		"Firefox")
			sudo dnf install firefox -y >/dev/null 2>&1 || { echo "Failed To Install Firefox, Please Check Your Internet Connection!"; exit 1; }
			break
			;;
		"Chrome")
			wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm >/dev/null 2>&1 || { echo "Failed To Download Chrome, Please Check Your Internet Connection!"; exit 1; }
			sudo dnf install ./google-chrome-stable_current_x86_64.rpm -y >/dev/null 2>&1 || true
			rm google-chrome* >/dev/null 2>&1 || true
			clear
			break
			;;
		*)
			echo "Invalid Option: $REPLY"
			;;
		esac
	done

    clear
	cat << "EOF"

	██╗  ██╗███████╗███╗   ██╗
	╚██╗██╔╝██╔════╝████╗  ██║
	 ╚███╔╝ █████╗  ██╔██╗ ██║
	 ██╔██╗ ██╔══╝  ██║╚██╗██║
	██╔╝ ██╗███████╗██║ ╚████║
	╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝

   		    90% Done!
EOF

PS3="Would You Like To Reboot (Recommended) Or Exit The Script Now?
"
options=("Reboot" "Exit")
select opt in "${options[@]}"
do
	case $opt in
		"Reboot")
			sudo systemctl reboot
			;;
		"Exit")
			exit
			;;
		esac
	done

else
	echo "Sorry, This Script Does Not Support Your System, Either You're Using A Supported Distro Base But Don't Have Systemd, Or You Aren't Using Arch-Based, Debian Based, Or Fedora Based"
	exit 1
fi

  PS3="Would You Like To Know What Distro You Use?
	  "
	  options=("Yes" "No")
	  select opt in "${options[@]}"
	  do
	      case $opt in
	          "Yes")
	              grep "PRETTY" /etc/os-release
	              exit
	              ;;
	          "No")
	              exit
	              ;;
	        esac
	    done
            exit
            ;;
        "Change Configs")
        clear
        setup_configs

            fi
				exit
            	;;
        "Bluetooth & SSH")
            if command -v pacman /dev/null 2>&1; then
                sudo pacman -S bluez bluez-utils --noconfirm
			    sudo systemctl enable --now bluetooth
bluetoothctl <<EOF
power on
agent on
default-agent
exit
EOF
                sudo pacman -S openssh --noconfirm
                    sudo systemctl enable sshd && sudo systemctl start sshd
                fi
            if command -v apt /dev/null 2>&1; then
                sudo apt install bluetooth bluez -y
                sudo systemctl enable bluetooth
                sudo systemctl start bluetooth
                bluetoothctl <<EOF
power on
agent on
default-agent
exit
EOF
                sudo apt install ssh -y
			          sudo systemctl enable ssh
			          sudo systemctl start sshd
			          fi
            if command -v dnf /dev/null 2>&1; then
                sudo dnf install bluez bluez-tools -y
                sudo systemctl enable bluetooth
                sudo systemctl start bluetooth
                bluetoothctl <<EOF
power on
agent on
default-agent
exit
EOF
                sudo dnf install ssh -y
			          sudo systemctl enable sshd
			          sudo systemctl start sshd
			     fi
                exit
                ;;
            esac
        done
