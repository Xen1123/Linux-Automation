#!/bin/bash
echo "This Script Updates Your Arch, Debian, Or Fedora System! Press Any Key To Continue!"
    read -r -n 1 -s
        clear && sudo -v

if command -v pacman >/dev/null 2>&1; then
    echo "Arch Linux Found! Now Updating Silently!"
        sleep 1.5
    sudo pacman -Syu --noconfirm || { clear; echo "You Have No Internet Or You Lack Sudo!"; exit 1; }
        if command -v paru >/dev/null 2>&1; then
            paru -Syu --noconfirm
        fi
        if command -v yay >/dev/null 2>&1; then
            yay -Syu --noconfirm
        fi
clear

elif command -v apt >/dev/null 2>&1; then
    echo "Debian Found! Now Updating Silently!"
        sleep 1.5
            if command -v nala >/dev/null 2>&1; then
                sudo nala upgrade -y >/dev/null 2>>"$HOME/apt_error.log" || { clear; echo "You Have No Internet Or You Lack Sudo!"; exit 1; }
            fi

            if ! command -v nala >/dev/null 2>&1; then
                sudo apt update -y && sudo apt upgrade -y >/dev/null 2>>"$HOME/apt_error.log" || { clear; echo "You Have No Internet Or You Lack Sudo!"; exit 1; }
            fi
clear

elif command -v dnf >/dev/null 2>&1; then
    echo "Fedora Found! Now Updating Silently!"
        sleep 1.5
    sudo dnf update -y >/dev/null 2>>"$HOME/dnf_error.log" || { clear; echo "You Have No Internet Or You Lack Sudo!"; exit 1; }
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
                                sudo apt install flatpak -y >/dev/null 2>>"$HOME/apt_error.log" || { clear; echo "You Have No Internet Or You Lack Sudo!"; exit 1; }
                            elif command -v pacman >/dev/null 2>&1; then
                                sudo pacman -S flatpak --noconfirm >/dev/null 2>>"$HOME/pacman_error.log" || { clear; echo "You Have No Internet Or You Lack Sudo!"; exit 1; }
                            elif command -v dnf >/dev/null 2>&1; then
                                sudo dnf install flatpak -y >/dev/null 2>>"$HOME/dnf_error.log" || { clear; echo "You Have No Internet Or You Lack Sudo!"; exit 1; }
                            fi
                            flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
                            break
                        esac
                    done
            fi
            echo "Updating Flatpak Applications Silently!"
            flatpak update -y >/dev/null 2>>"$HOME/flatpak_error.log"
            exit
            ;;
        "No")
            exit
            ;;
        esac
    done
clear
echo "You're Updated! :)"
