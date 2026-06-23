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
	"packages",
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
set fish_greeting ""
fastfetch --logo vanilla2
alias pacman 'sudo pacman'
alias apt 'sudo apt'
alias dnf 'sudo dnf'
alias reboot 'sudo reboot now'
EOF