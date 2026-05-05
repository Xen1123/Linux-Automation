#!/bin/bash
echo "This Is A Script For When You Need A Few Extra Gigabytes, But Your System Is Particularly Bloated Don't Run This While Compiling Anything, Press Any Key To Continue"
read -n 1 -s

rm -rf ~/.cache/* >/dev/null 2>&1 || true
sudo rm -rf /root/.cache/* >/dev/null 2>&1 || true

if command -v pacman >/dev/null 2>&1; then
    echo "Arch Linux Found!"
    if command -v fastfetch >/dev/null 2>&1; then
        fastfetch
    fi
        
        sudo rm -rf /var/cache/pacman/pkg/* >/dev/null 2>&1 || true
        sudo pacman -Sc --noconfirm >/dev/null 2>&1 || true
    clear

elif command -v apt >/dev/null 2>&1; then
    echo "Debian/Ubuntu Found!"
    if command -v fastfetch >/dev/null 2>&1; then
        fastfetch
    fi
        
        sudo apt clean -y >/dev/null 2>&1 || true
        sudo apt autoremove -y >/dev/null 2>&1 || true
    clear

elif command -v dnf >/dev/null 2>&1; then
    echo "Fedora Found!"
    if command -v fastfetch >/dev/null 2>&1; then
        fastfetch
    fi
        
        sudo dnf clean all -y >/dev/null 2>&1 || true
    clear
fi

clear

echo "Your System Should Be Multiple Gigabytes (GB) Cleaner! If Not, Your System Was Already Very Lean With Caches, Good Job!"
