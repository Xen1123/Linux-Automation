#!/bin/bash
echo "This Script Updates Your Arch, Debian, Or Fedora System! Press Any Key To Continue!"
    read -n 1 -s
        clear && sudo -v

if command -v pacman >/dev/null 2>&1; then
    echo "Arch Linux Found!"
        sleep 1.5
    sudo pacman -Syyu --noconfirm
clear

elif command -v apt >/dev/null 2>&1; then
    echo "Debian Discovered!"
        sleep 1.5
            if command -v nala >/dev/null 2>&1; then
                sudo nala upgrade -y
            fi

            if ! command -v nala >/dev/null 2>&1; then
                sudo apt update -y && sudo apt upgrade -y
            fi
clear

elif command -v dnf >/dev/null 2>&1; then
    echo "Fedora Found!"
        sleep 1.5
    sudo dnf update -y
clear
fi

    if command -v fastfetch >/dev/null 2>&1; then
        fastfetch
    fi

PS3="Would You Like To Update Any Flatpak Applications?
"
options=("Yes" "No")
select opt in "${options[@]}"
do
    case $opt in
        "Yes")
            if ! command -v flatpak >/dev/null 2>&1; then
                PS3="Flatpak Is Not Installed, Would You Like To Install It?
                "
                options=("Yes" "No")
                select opt in "${options[@]}"
                do
                    case $opt in
                        "Yes")
                            if command -v apt >/dev/null 2>&1; then
                                sudo apt install flatpak -y
                            fi
                            if command -v pacman >/dev/null 2>&1; then
                                sudo pacman -S flatpak --noconfirm
                            fi
                            if command -v dnf >/dev/null 2>&1; then
                                sudo dnf install flatpak -y
                            fi
                            flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
                            break
                        esac
                    done
            fi
            flatpak update -y
            exit
            ;;
        "No")
            exit
            ;;
        esac
    done
clear
echo "You're Updated! :)"