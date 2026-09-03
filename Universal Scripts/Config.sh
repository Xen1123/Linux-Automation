#!/bin/bash

echo "This Script Simply Backs Up Existing Configs And Replaces Them, Click Any Key To Continue!"
read -r -n 1 -s

mkdir -p ~/Config_Backup >/dev/null 2>&1 || true
cp -r ~/.config/fastfetch/ ~/Config_Backup >/dev/null 2>&1 || true
cp -r ~/.config/fish ~/Config_Backup >/dev/null 2>&1 || true

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

rm -rf ~/.config/fish
mkdir -p ~/.config/fish

  cat <<EOF > ~/.config/fish/config.fish
set fish_greeting
clear
alias apt 'sudo apt'
alias nala 'sudo nala'
alias dnf 'sudo dnf'
alias pacman 'sudo pacman'
alias apk 'sudo apk'
alias xbps-install 'sudo xbps-install'
alias xbps-remove 'sudo xbps-remove'
alias reboot 'sudo reboot now'
fastfetch
set -gx LS_COLORS 'di=34:ow=34:tw=34:st=34:fi=0:ex=32:ln=36:pi=33:so=35:bd=33:cd=33'
EOF

if command -v starship >/dev/null 2>&1; then
	cat <<EOF >> ~/.config/fish/config.fish
starship init fish | source
enable_transience
EOF
else
	clear
fi

if command -v vim; then
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
if command -v nvim; then
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

