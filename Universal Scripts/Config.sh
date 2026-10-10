#!/bin/bash

printf "This Script Simply Backs Up Existing Configs And Replaces Them, Click Any Key To Continue!\n"
read -r -n 1 -s

mkdir -p ~/Config_Backup >/dev/null 2>&1 || true
cp -r ~/.config/fastfetch/ ~/Config_Backup >/dev/null 2>&1 || true
cp -r ~/.bashrc ~/Config_Backup >/dev/null 2>&1 || true

rm -rf ~/.config/fastfetch
	mkdir -p ~/.config/fastfetch
	cat <<EOF > ~/.config/fastfetch/config.jsonc
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
EOF

  cat <<EOF > ~/..bashrc
#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
clear

alias apt='sudo apt'
alias nala='sudo nala'
alias dnf='sudo dnf'
alias pacman='sudo pacman'
alias apk='sudo apk'
alias xbps-install='sudo xbps-install'
alias xbps-remove='sudo xbps-remove'
alias reboot='sudo reboot now'
alias vim='nvim'


fastfetch

export LS_COLORS='di=34:ow=34:tw=34:st=34:fi=0:ex=32:ln=36:pi=33:so=35:bd=33:cd=33'

alias ls='eza --icons=auto'

export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init bash)"

EOF

if command -v pacman >/dev/null 2>&1; then
	sudo pacman -S eza nvim starship vim --noconfirm
elif command -v apt >/dev/null 2>&1; then
	sudo apt install eza nvim starship vim -y
elif command -v dnf >/dev/null 2>&1; then
	sudo dnf install eza nvim starship vim -y
elif command -v apk >/dev/null 2>&1; then
	sudo apk add eza neovim starship vim
elif command -v xbps-install >/dev/null 2>&1; then
	sudo xbps-install -Sy eza neovim starship vim
fi

if command -v vim >/dev/null 2>&1; then
    cat <<EOF > ~/.vimrc
set number
syntax on

set tabstop=4
set shiftwidth=4
set expandtab
set mouse=a

" Keybinds
map <F2> :wq<CR>
map <F5> :q!<CR> 
EOF
fi
if command -v nvim >/dev/null 2>&1; then
rm -rf ~/.config/nvim
mkdir ~/.config/nvim
    cat <<EOF > ~/.config/nvim/init.vim
set number
syntax on

set tabstop=4
set shiftwidth=4
set expandtab
set mouse=a

" Keybinds
map <F2> :wq<CR>
map <F5> :q!<CR> 
EOF
fi

rm -rf ~/.config/starship/starship.toml
mkdir -p ~/.config/starship
    cat <<EOF > ~/.config/starship/starship.toml
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
EOF
rm -rf ~/.config/fish/config.fish
mkdir -p ~/.config/fish
if command -v fish >/dev/null 2>&1; then
	cat <<FISH > ~/.config/fish/config.fish
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
alias vim='nvim'
set -Ux STARSHIP_CONFIG "$HOME/.config/starship/starship.toml"
alias yt-dlp='yt-dlp -x --audio-format mp3 --audio-quality 2 --embed-metadata --embed-thumbnail -o "%(title)s.%(ext)s"'
starship init fish | source
FISH
fi
