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


fastfetch --logo arch3

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

else
	clear
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
$directory\
$git_branch\
$git_status\
$fill\
$python\
$lua\
$nodejs\
$golang\
$haskell\
$rust\
$ruby\
$package\
$aws\
$docker_context\
$jobs\
$cmd_duration\
$line_break\
$character"""

add_newline = true
palette = 'nord'

[directory]
style = 'bold fg:dark_blue'
format = '[$path ]($style)'
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
format = '[on](white) [$symbol$branch ]($style)'

[git_status]
style = 'fg:green'
format = '([$all_status$ahead_behind]($style) )'

[fill]
symbol = ' '

[python]
style = 'teal'
symbol = ' '
format = '[${symbol}${pyenv_prefix}(${version} )(\($virtualenv\) )]($style)'
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
format = '[$symbol($profile )(\[$duration\] )]($style)'

[docker_context]
symbol = ' '
style = 'fg:#06969A'
format = '[$symbol]($style) $path'
detect_files = ['docker-compose.yml', 'docker-compose.yaml', 'Dockerfile']
detect_extensions = ['Dockerfile']

[jobs]
symbol = ' '
style = 'red'
number_threshold = 1
format = '[$symbol]($style)'

[cmd_duration]
min_time = 500
style = 'fg:gray'
format = '[$duration]($style)'

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