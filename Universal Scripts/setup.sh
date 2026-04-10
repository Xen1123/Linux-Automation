#!/bin/bash
echo "This Script Sets Up Your System If You Use Arch, Debian, OR Fedora!"
read -n 1 -s
if command -v pacman >/dev/null 2>&1; then
  echo "Arch Found!"
    sleep 2
    clear
      sudo pacman -S wget okular eog wl-clipboard curl git power-profiles-daemon base-devel bat nano btop vim scrcpy fastfetch android-tools android-udev gvfs gvfs-mtp heimdall usbutils fish yt-dlp plasma networkmanager flatpak sddm openssh konsole dolphin --needed --noconfirm || { echo "You are NOT connected to the internet!"; exit 1; }
cd
rm -rf ~/yay
		git clone https://aur.archlinux.org/yay.git || { echo "Clone Failed! Please Install Git And Dependencies!"; exit 1; }
		cd ~/yay
		makepkg -si --noconfirm
mkdir -p ~/.config/fish

(
echo 'set fish_greeting ""'
echo "fastfetch"
echo "alias pacman 'sudo pacman'"
) > ~/.config/fish/config.fish

	yay -S balena-etcher --noconfirm
	yay -S ventoy-bin --noconfirm
	yay -S qdl --noconfirm
	yay -S kde-material-you-colors --noconfirm
cd /home/$USER
fastfetch --gen-config
(
echo "{"
echo '"$schema": "https://github.com/fastfetch-cli/fastfetch/raw/master/doc/json_schema.json",'
echo '"modules": ['
echo '"title",'
echo '"separator",'
echo '"os",'
echo '"host",'
echo '"kernel",'
echo '"uptime",'
echo '"packages",'
echo '"terminal",'
echo '"cpu",'
echo '"gpu",'
echo '"memory",'
echo '"swap",'
echo '"disk",'
echo '"localip",'
echo '"battery",'
echo '"break",'
echo '"colors"'
echo "]"
echo "}"
) > ~/.config/fastfetch/config.jsonc
sudo systemctl enable NetworkManager
sudo systemctl enable sshd
sudo systemctl start sshd
sudo systemctl enable sddm.service
sudo systemctl enable power-profiles-daemon.service
sudo systemctl start power-profiles-daemon.service
chsh -s /usr/bin/fish
clear
PS3='Would You Like Firefox, Chrome, None, or Something Else?
'
options=("Firefox" "Google Chrome" "Something Else" "None")

select opt in "${options[@]}"
do
	case $opt in
		"Firefox")
			sudo pacman -S firefox
			break
			;;
		"Google Chrome")
			yay -S google-chrome --noconfirm
			break
			;;
		"None")
			break
			;;
		"Something Else")
				PS3='Brave, Zen Browser, Chromium, Librewolf, or None Of The Above?
				'
				options=("Brave" "Zen" "Chromium" "Librewolf" "None")

				select opt in "${options[@]}"
				do
					case $opt in
						"Brave")
							yay -S brave-bin --noconfirm
							break
							;;
						"Zen")
							yay -S zen-browser-bin --noconfirm
							break
							;;
						"Chromium")
							sudo pacman -S chromium --noconfirm
							break
							;;
						"Librewolf")
							yay -S librewolf-bin --noconfirm
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
PS3='Would You Like Localsend, Discord, Neither, or Both? 
'
options=("Localsend" "Discord" "Both" "Neither")

select opt in "${options[@]}"
do
	case $opt in
		"Localsend")
			yay -S localsend-bin --noconfirm
			break
			;;
		"Discord")
			sudo pacman -S discord --noconfirm
			break
			;;
		"Both")
			sudo pacman -S discord --noconfirm
			yay -S localsend-bin --noconfirm
			break
			;;
		"Neither")
			break
			;;
	esac
	done

clear
echo "Changing your shell typically requires a restart for it to fully take affect, would you like to reboot?"
PS3='What Would You Like To Do?
'
options=("Restart" "Go To KDE" "Exit To Typing")

select opt in "${options[@]}"
do
	case $opt in
		"Restart")
			sudo reboot now
			;;
		"Exit To Typing")
			exit
			;;
		"Go To KDE")
			sudo systemctl start NetworkManager
			sudo systemctl start sddm.service
			;;
		*)
			echo "Invalid Option $REPLY"
			;;
	esac
	done
#########################################
#########################################
#########################################
#########################################
#########################################
#########################################
#########################################
elif command -v apt >/dev/null 2>&1; then
  echo "Ubuntu/Debian Found!"
    sleep 2
    clear
      sudo apt install adb fastboot
