#!/bin/bash

printf "This Script Simply Backs Up Existing Configs And Replaces Them, Click Any Key To Continue!\n"
read -r -n 1 -s

mkdir -p ~/Config_Backup >/dev/null 2>&1 || true
cp -r ~/.config/fastfetch/ ~/Config_Backup >/dev/null 2>&1 || true
cp -r ~/.bashrc ~/Config_Backup >/dev/null 2>&1 || true
cp -r ~/.vimrc ~/Config_Backup >/dev/null 2>&1 || true
cp -r ~/.config/nvim/ ~/Config_Backup >/dev/null 2>&1 || true
cp -r ~/.config/starship/ ~/Config_Backup >/dev/null 2>&1 || true

if command -v pacman >/dev/null 2>&1; then
    sudo pacman -Sy vim fish fastfetch eza neovim starship --noconfirm || true
elif command -v nala >/dev/null 2>&1; then
    sudo nala install -y vim fish fastfetch eza neovim starship || true
elif command -v apt >/dev/null 2>&1; then
    sudo apt install -y vim fish fastfetch eza neovim nala starship || true
elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install vim fish neovim fastfetch eza starship || true
elif command -v xbps-install >/dev/null 2>&1; then
    sudo xbps-install -Sy vim fish-shell neovim fastfetch eza starship || true
elif command -v apk >/dev/null 2>&1; then
    sudo apk add vim fish-shell neovim fastfetch eza starship || true
fi

rm -rf ~/.config/fastfetch
mkdir ~/.config/fastfetch/
touch ~/.config/fastfetch/config.jsonc
cat <<FASTFETCH > ~/.config/fastfetch/config.jsonc
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
FASTFETCH

rm -rf ~/.config/fish
mkdir -p ~/.config/fish/
cat <<'FISH' > ~/.config/fish/config.fish
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
alias ls='eza -l --color=always --group-directories-first --icons=always' # preferred listing
alias lsr='eza -al --color=always --group-directories-first --icons=always'
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
FISH
rm -rf ~/.config/nvim
rm -f ~/.vimrc
sudo rm -rf /root/.config/nvim
sudo rm -rf /root/.vimrc
mkdir -p ~/.config/nvim
sudo mkdir -p /root/.config/nvim
cat > ~/.vimrc <<VIM
set number
syntax on

set tabstop=4
set shiftwidth=4
set expandtab
set mouse=a
colorscheme habamax
highlight Normal guibg=NONE ctermbg=NONE

" Keybinds
map <F2> :wq<CR>
map <F5> :q!<CR> 
VIM
cp ~/.vimrc ~/.config/nvim/init.vim
sudo cp ~/.vimrc /root/.vimrc
sudo cp ~/.vimrc /root/.config/nvim/init.vim

rm -rf ~/.config/starship
mkdir -p ~/.config/starship
cat <<'STAR' > ~/.config/starship/starship.toml
add_newline = true
# Pipes ╰─ ╭─
# Powerline symbols                                     
# Wedges 🭧🭒 🭣🭧🭓
# Random noise 🬖🬥🬔🬗
# Cool stuff 󰜥   

# format = """
# $directory $fill $git_branch $cmd_duration
#  $character"""
format = """
$cmd_duration $directory$git_branch
  $character"""

[fill]
symbol = '-'
style = 'fg:245'

# Replace the "❯" symbol in the prompt with "➜"
[character]                            # The name of the module we are configuring is "character"
success_symbol = "[ ](bold fg:243)"
error_symbol = "[ ](bold fg:244)"

# Disable the package module, hiding it from the prompt completely
[package]
disabled = true

[git_branch]
style = "bg: 252"
symbol = "󰘬"
truncation_length = 12
truncation_symbol = ""
format = " 󰜥 [](bold fg:252)[$symbol $branch(:$remote_branch)](fg:235 bg:252)[ ](bold fg:252)"

[git_commit]
commit_hash_length = 4
tag_symbol = " "

[git_state]
format = '[\($state( $progress_current of $progress_total)\)]($style) '
cherry_pick = "[🍒 PICKING](bold red)"

[git_status]
conflicted = " 🏳 "
ahead = " 🏎💨 "
behind = " 😰 "
diverged = " 😵 "
untracked = " 🤷 ‍"
stashed = " 📦 "
modified = " 📝 "
staged = '[++\($count\)](green)'
renamed = " ✍️ "
deleted = " 🗑️ "

[hostname]
ssh_only = false
format =  "[•$hostname](bg:252 bold fg:235)[](bold fg:252)"
trim_at = ".companyname.com"
disabled = false

[line_break]
disabled = false

[memory_usage]
disabled = true
threshold = -1
symbol = " "
style = "bold dimmed green"

[time]
disabled = true
format = '🕙[\[ $time \]]($style) '
time_format = "%T"

[username]
style_user = "bold bg:252 fg:235"
style_root = "red bold"
format = "[](bold fg:252)[$user]($style)"
disabled = false
show_always = true

[directory]
home_symbol = " "
read_only = "  "
style = "bg:255 fg:240"
truncation_length = 2
truncation_symbol = ".../"
format = '[](bold fg:255)[󰉋 → $path]($style)[](bold fg:255)'


[directory.substitutions]
"Desktop" = "  "
"Documents" = "  "
"Downloads" = "  "
"Music" = " 󰎈 "
"Pictures" = "  "
"Videos" = "  "
"GitHub" = " 󰊤 "

[cmd_duration]
min_time = 0
format = '[](bold fg:252)[󰪢 $duration](bold bg:252 fg:235)[](bold fg:252)'
STAR
cat <<'BASH' > ~/.bashrc
fastfetch
## Useful aliases
# Replace ls with eza
alias ls='eza -l --color=always --group-directories-first --icons=always' # preferred listing
alias lsr='eza -al --color=always --group-directories-first --icons=always'
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
alias xbps-install='sudo xbps-install'
alias xbps-remove='sudo xbps-remove'
alias apk='sudo apk'
alias vim='nvim'
export STARSHIP_CONFIG="/home/$USER/.config/starship/starship.toml"
eval "$(starship init bash)"
BASH

