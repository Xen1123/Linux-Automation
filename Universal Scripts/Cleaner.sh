#!/bin/bash
echo "This Is A Script For When You Need A Few Extra Gigabytes, But Your System Is Particularly Bloated Don't Run This While Compiling Anything, Press Any Key To Continue"
read -n 1 -s

rm -rf ~/.cache/* >/dev/null 2>&1
sudo rm -rf /root/.cache/* >/dev/null 2>&1

if command -v pacman >/dev/null 2>&1; then
    echo "Arch Linux Found!"
    sleep 1.5
    if command -v fastfetch >/dev/null 2>&1; then
        fastfetch
    fi
        sudo rm -rf /var/cache/pacman/pkg/*
        sudo pacman -Sc --noconfirm
    clear

elif command -v apt >/dev/null 2>&1; then
    echo "Debian/Ubuntu Found!"
    sleep 1.5
    if command -v fastfetch >/dev/null 2>&1; then
        fastfetch
    fi
        sudo apt clean -y
        sudo apt autoremove -y
    clear

elif command -v dnf >/dev/null 2>&1; then
    echo "Fedora Found!"
    sleep 1.5
    if command -v fastfetch >/dev/null 2>&1; then
        fastfetch
    fi
        sudo dnf clean all -y
    clear
fi

clear

echo "Your System Should Be Multiple Gigabytes (GB) Cleaner! If Not, Your System Was Already Very Lean With Caches, Good Job!"