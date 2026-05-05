#!/bin/bash

setup_fastfetch() {
	cat <<EOF > ~/.config/fastfetch/config.jsonc
{
  {
  "": "https://github.com/fastfetch-cli/fastfetch/raw/master/doc/json_schema.json",
  "modules": [
    "title",
	"separator",
	"os",
	"host",
	"disk",
	"memory",
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
}

PS3="Would You Like To Setup Your Whole System (Includes Configs And Bluetooth w/ SSH), Change Configs, Or Setup Bluetooth & SSH?
"
options=("Setup Whole System" "Change Configs" "Bluetooth & SSH")
select opt in "${options[@]}"
do
    case $opt in
        "Setup Whole System")
if command -v pacman >/dev/null 2>&1 && command -v systemctl >/dev/null 2>&1; then
  echo "Arch Found (With Systemd) !"
    sleep 2
    clear
      sudo pacman -S wget curl git 7zip nano btop fastfetch wl-clipboard acpi power-profiles-daemon usbutils okular eog base-devel bat vim scrcpy gvfs yt-dlp plasma networkmanager flatpak sddm konsole dolphin --needed --noconfirm || { echo "You are NOT connected to the internet!"; exit 1; }
cd /home/"$USER" || exit
sudo -v
mv ~/paru ~/paru-backup || true
		git clone https://aur.archlinux.org/paru.git || { echo "Clone Failed! Please Install Git And Dependencies!"; exit 1; }
		cd ~/paru || exit && echo "No Folder Named Paru"
        clear
        echo "Installing paru (An AUR Helper Written In Rust) Click Any Key To Continue!"
		read -r -n 1 -s
		makepkg -si --noconfirm || { clear; echo "This Likely Failed Because You Ran The Script As Root Or You're The Root User Instead Of A Standard User"; cd /home/"$USER" || true; rm -rf paru; exit 1; }
	cd /home/"$USER" || exit
rm -rf ~/paru
			sudo -v

clear

PS3="Would You Like Bluetooth?
"
options=("Yes" "No")
select opt in "${options[@]}"
do
	case $opt in
		"Yes")
			sudo pacman -S bluez bluez-utils --noconfirm
			sudo systemctl enable --now bluetooth
bluetoothctl <<EOF
power on
agent on
default-agent
exit
EOF
			break
			;;
		"No")
			break
			;;
		esac
	done

PS3="Would You Like ADB And Fastboot, Along With Heimdall? (If You Don't Know What These Are, You Don't Need Them)
"
options=("Yes" "No")
select opt in "${options[@]}"
do
	case $opt in
		"Yes")
			sudo pacman -S android-tools heimdall android-udev gvfs-mtp --noconfirm
			break
			;;
		"No")
			break
			;;
		esac
	done

clear

PS3="Would You Like To Install SSH? (A Program That Allows You To Type In Other Linux Computers Or Type In Your Terminal From Another Computer)
"
options=("Yes" "No")
select opt in "${options[@]}"
do
	case $opt in
		"Yes")
			sudo pacman -S openssh
			sudo systemctl enable sshd
			sudo systemctl start sshd
			break
			;;
		"No")
			break
			;;
		esac
	done

clear

PS3="Would You Like To Use Fish Shell Instead Of Bash?"
options=("Yes" "No")
select opt in "${options[@]}"
do
	case $opt in
		"Yes")
			sudo pacman -S fish --noconfirm
			mkdir -p ~/.config/fish
			cat <<EOF > ~/.config/fish/config.fish
set fish_greeting ""
fastfetch --logo vanilla2
alias pacman 'sudo pacman'
EOF
			chsh -s /usr/bin/fish
			break
			;;
		"No")
			echo "alias pacman='sudo pacman'" >> ~/.bashrc
			echo "fastfetch" >> ~/.bashrc
			break
			;;
		*)
			echo "Invalid Option: $REPLY"
			;;
	esac
done

clear

	paru -S balena-etcher --noconfirm
	paru -S ventoy-bin --noconfirm
	paru -S qdl --noconfirm
	paru -S kde-material-you-colors --noconfirm
cd ~ && sudo -v
fastfetch --gen-config-force

clear

	rm -rf ~/.config/fastfetch
	mkdir -p ~/.config/fastfetch
	setup_fastfetch

sudo systemctl enable NetworkManager
sudo systemctl enable sddm.service
sudo systemctl enable power-profiles-daemon.service
sudo systemctl start power-profiles-daemon.service
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
			paru -S google-chrome --noconfirm
			break
			;;
		"None")
			break
			;;
		"Something Else")
				sudo -v
				PS3='Brave, Zen Browser, Chromium, Librewolf, or None Of The Above?
				'
				options=("Brave" "Zen" "Chromium" "Librewolf" "None")

				select opt in "${options[@]}"
				do
					case $opt in
						"Brave")
							paru -S brave-bin --noconfirm
							break
							;;
						"Zen")
							paru -S zen-browser-bin --noconfirm
							break
							;;
						"Chromium")
							sudo pacman -S chromium --noconfirm
							break
							;;
						"Librewolf")
							paru -S librewolf-bin --noconfirm
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

sudo -v && clear
PS3='Would You Like Localsend, Discord, Neither, or Both? 
'
options=("Localsend" "Discord" "Both" "Neither")

select opt in "${options[@]}"
do
	case $opt in
		"Localsend")
			paru -S localsend-bin --noconfirm
			break
			;;
		"Discord")
			sudo pacman -S discord --noconfirm
			break
			;;
		"Both")
			sudo pacman -S discord --noconfirm
			paru -S localsend-bin --noconfirm
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

elif command -v apt >/dev/null 2>&1; then
  echo "Ubuntu/Debian Found!"
    sleep 2
    clear
		sudo apt update && sudo apt upgrade -y
		sudo apt install nala wl-clipboard qdl network-manager libfuse2 7zip curl eog acpi flatpak vim bat nano power-profiles-daemon gvfs -y || { echo "You are NOT connected to the internet!"; exit 1; }
		flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
		sudo apt remove konqueror -y
		sudo apt autoremove -y
	clear
	sudo systemctl enable sddm.service
	sudo systemctl enable NetworkManager
	sudo systemctl enable power-profiles-daemon.service
	sudo -v

clear

PS3="Would You Like To Install KDE? (A Desktop Environment That Actually Lets You Use Your Computer Like Windows Instead Of Living In A Black Box)
"
options=("Yes" "No")
select opt in "${options[@]}"
do
	case $opt in
		"Yes")
			sudo nala install task-kde-desktop sddm plasma-discover-backend-flatpak discover
			break
			;;
		"No")
			break
			;;
		esac
	done

clear

PS3="Would You Like ADB And Fastboot, Along With Heimdall? (If You Don't Know What These Are, You Don't Need Them)
"
options=("Yes" "No")
select opt in "${options[@]}"
do
	case $opt in
		"Yes")
			sudo nala install adb fastboot heimdall-flash -y
			break
			;;
		"No")
			break
			;;
		esac
	done

clear

PS3="Would You Like To Install SSH? (A Program That Allows You To Type In Other Linux Computers Or Type In Your Terminal From Another Computer)
"
options=("Yes" "No")
select opt in "${options[@]}"
do
	case $opt in
		"Yes")
			sudo nala install ssh -y
			sudo systemctl enable ssh
			sudo systemctl start ssh
			break
			;;
		"No")
			break
			;;
		esac
	done

clear

PS3="Would You Like To Use Fish Shell Instead Of Bash?
"
options=("Yes" "No")
select opt in "${options[@]}"
do
	case $opt in
		"Yes")
			sudo nala install fish -y
			mkdir -p ~/.config/fish
			cat <<EOF > ~/.config/fish/config.fish
set fish_greeting ""
alias apt 'sudo nala'
alias nala 'sudo nala'
EOF
			chsh -s /usr/bin/fish
			break
			;;
		"No")
			echo "alias apt='sudo nala'" >> ~/.bashrc
			echo "alias nala='sudo nala'" >> ~/.bashrc
			break
			;;
		*)
			echo "Invalid Option: $REPLY"
			;;
	esac
done

sudo -v

clear

PS3="What Browser Would You Like?
"
options=("Firefox" "Chrome" "Skip")
select opt in "${options[@]}"
do
	case $opt in
		"Firefox")
			sudo nala install firefox -y
			clear
			break
			;;
		"Chrome")
			wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
			sudo nala install ./google-chrome-stable_current_amd64.deb -y
			rm google-chrome*
			clear
			break
			;;
		"Skip")
			break
			;;
		*)
			echo "Invalid Option: $REPLY"
			;;
		esac
	done

clear

PS3="Would You Like To Reboot (Recommended), Go Straight To KDE, Or Exit The Script Now?
"
options=("Reboot" "KDE" "Exit")
select opt in "${options[@]}"
do
	case $opt in
		"Reboot")
			sudo systemctl reboot
			;;
		"KDE")
			sudo systemctl restart sddm.service
			;;
		"Exit")
			exit
			;;
		*)
			echo "Invalid Option: $REPLY"
			;;
		esac
	done

elif command -v dnf >/dev/null 2>&1; then
  echo "Fedora Found!"
  	sleep 2
  	clear
		sudo dnf update -y
		sudo -v
		sudo dnf install yt-dlp fastfetch nano vim wl-clipboard curl flatpak 7zip git acpi power-profiles-daemon usbutils -y --allowerasing
		sudo -v
		sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	clear
	sudo flatpak install flathub org.localsend.localsend_app -y

	rm -rf ~/.config/fastfetch
	mkdir -p ~/.config/fastfetch
	setup_fastfetch

clear
fastfetch

PS3="Would You Like ADB And Fastboot, Along With Heimdall? (If You Don't Know What These Are, You Don't Need Them)
"
options=("Yes" "No")
select opt in "${options[@]}"
do
	case $opt in
		"Yes")
			sudo dnf install android-tools heimdall gvfs-mtp -y
			break
			;;
		"No")
			break
			;;
		esac
	done

clear

PS3="Would You Like To Install SSH? (A Program That Allows You To Type In Other Linux Computers Or Type In Your Terminal From Another Computer)
"
options=("Yes" "No")
select opt in "${options[@]}"
do
	case $opt in
		"Yes")
			sudo dnf install ssh -y
			sudo systemctl enable sshd
			sudo systemctl start sshd
			break
			;;
		"No")
			break
			;;
		esac
	done

clear

PS3="Would You Like To Use Fish Shell Instead Of Bash?
"
options=("Yes" "No")
select opt in "${options[@]}"
do
	case $opt in
		"Yes")
			sudo dnf install fish -y
			mkdir -p ~/.config/fish
			cat <<EOF > ~/.config/fish/config.fish
set fish_greeting ""
fastfetch --logo vanilla2
alias dnf 'sudo dnf'
EOF
			chsh -s /usr/bin/fish
			break
			;;
		"No")
			echo "alias dnf='sudo dnf'" >> ~/.bashrc
			echo "fastfetch" >> ~/.bashrc
			break
			;;
		*)
			echo "Invalid Option: $REPLY"
			;;
	esac
done

sudo -v

clear
fastfetch
PS3="What Browser Would You Like?
"
options=("Firefox" "Chrome")
select opt in "${options[@]}"
do
	case $opt in
		"Firefox")
			sudo dnf install firefox -y
			clear
			fastfetch
			break
			;;
		"Chrome")
			wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
			sudo dnf install ./google-chrome-stable_current_x86_64.rpm -y
			rm google-chrome*
			clear
			fastfetch
			break
			;;
		*)
			echo "Invalid Option: $REPLY"
			;;
		esac
	done

clear

PS3="Would You Like To Reboot (Recommended) Or Exit The Script Now?
"
options=("Reboot" "Exit")
select opt in "${options[@]}"
do
	case $opt in
		"Reboot")
			sudo systemctl reboot
			;;
		"Exit")
			exit
			;;
		esac
	done

else
	echo "Sorry, This Script Does Not Support Your System, Either You're Using A Supported Distro Base But Don't Have Systemd, Or You Aren't Using Arch-Based, Debian Based, Or Fedora Based"
	exit 1
fi

  PS3="Would You Like To Know What Distro You Use?
	  "
	  options=("Yes" "No")
	  select opt in "${options[@]}"
	  do
	      case $opt in
	          "Yes")
	              grep "PRETTY" /etc/os-release
	              exit
	              ;;
	          "No")
	              exit
	              ;;
	        esac
	    done
            exit
            ;;
        "Change Configs")
        clear
        if command -v fastfetch LINE="fastfetch" /dev/null 2>&1; then
            FILE="$HOME/.bashrc"

            if ! grep -Fq "$LINE" "$FILE"; then
                echo "fastfetch" >> ~/.bashrc
            else
                clear
                echo "Your Bash Config Already Has Fastfetch."
            fi
        fi
        if [ -d ~/.config/fish ] >/dev/null 2>&1; then
            cp -r ~/.config/fish ~/Downloads
        fi
        if command -v fish /dev/null 2>&1; then
			rm -rf ~/.config/fish || true
        	mkdir -p ~/.config/fish
        	cat <<EOF > ~/.config/fish/config.fish
set fish_greeting ""
alias pacman 'sudo pacman'
alias apt 'sudo apt'
alias nala 'sudo nala'
alias dnf 'sudo dnf'
EOF
            fi	
				exit
            	;;
        "Bluetooth & SSH")
            if command -v pacman /dev/null 2>&1; then
                sudo pacman -S bluez bluez-utils --noconfirm
			    sudo systemctl enable --now bluetooth
bluetoothctl <<EOF
power on
agent on
default-agent
exit
EOF
                sudo pacman -S openssh --noconfirm
                    sudo systemctl enable sshd && sudo systemctl start sshd
                fi
            if command -v apt /dev/null 2>&1; then
                sudo apt install bluetooth bluez
                sudo systemctl enable bluetooth
                sudo systemctl start bluetooth
                bluetoothctl <<EOF
power on
agent on
default-agent
exit
EOF
                sudo apt install ssh -y
			          sudo systemctl enable ssh
			          sudo systemctl start sshd
			          fi
            if command -v dnf /dev/null 2>&1; then
                sudo dnf install bluez bluez-tools
                sudo systemctl enable bluetooth
                sudo systemctl start bluetooth
                bluetoothctl <<EOF
power on
agent on
default-agent
exit
EOF
                sudo dnf install ssh -y
			          sudo systemctl enable sshd
			          sudo systemctl start sshd
			     fi
                exit
                ;;
            esac
        done
