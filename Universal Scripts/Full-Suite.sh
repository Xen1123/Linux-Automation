#!/bin/bash

setup_fastfetch() {
	cat <<EOF > ~/.config/fastfetch/config.jsonc
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
	cat << "EOF"
__  _______ _   _ 
\ \/ / ____| \ | |
 \  /|  _| |  \| |
 /  \| |___| |\  |
/_/\_\_____|_| \_|
   0% Done!
EOF
	echo "Updating System And Installing Some Stuff"
	  sudo pacman -Syu --noconfirm >/dev/null 2>&1 || { clear; echo "You are NOT connected to the internet!"; exit 1; }
      sudo pacman -S wget curl git 7zip nano btop fastfetch wl-clipboard acpi power-profiles-daemon usbutils okular eog base-devel bat vim scrcpy gvfs yt-dlp networkmanager --needed --noconfirm >/dev/null 2>&1 || { echo "You are NOT connected to the internet!"; exit 1; }
cd /home/"$USER" || exit
clear
	cat << "EOF"
__  _______ _   _ 
\ \/ / ____| \ | |
 \  /|  _| |  \| |
 /  \| |___| |\  |
/_/\_\_____|_| \_|
   10% Done!
EOF

PS3='Would You Like Hyprland Or KDE?
'
options=("Hyprland" "KDE")
select opt in "${options[@]}"
do
	case $opt in
		"Hyprland")
			if command -v pacman >/dev/null 2>&1; then
    sudo pacman -S --noconfirm hyprshot cava hyprpaper hyprland kitty swaync rofi wl-clipboard swaybg swaylock swayidle grim slurp mako polkit-gnome xdg-desktop-portal-hyprland >/dev/null 2>&1 || { clear; echo "You are NOT conected to the internet."; exit 1; }
    mkdir -p ~/.config/hypr >/dev/null 2>&1 || true 
    mkdir -p ~/.config/rofi >/dev/null 2>&1 || true
    mkdir -p ~/.config/kitty >/dev/null 2>&1 || true
    touch ~/.config/hypr/hyprland.conf >/dev/null 2>&1 || true
    touch ~/.config/rofi/config.rasi >/dev/null 2>&1 || true
    touch ~/.config/kitty/kitty.conf >/dev/null 2>&1 || true

echo "background_opacity 0.7" > ~/.config/kitty/kitty.conf
echo "font_size 10.5" >> ~/.config/kitty/kitty.conf

    cat <<'EOF' > ~/.config/rofi/config.rasi
* {
    font: "Figtree 13";
    g-spacing: 10px;
    g-margin: 0;
    b-color: #000000FF;
    fg-color: #FFFFFFFF;
    fgp-color: #888888FF;
    b-radius: 8px;
    g-padding: 8px;
    hl-color: #FFFFFFFF;
    hlt-color: #000000FF;
    alt-color: #111111FF;
    wbg-color: #000000CC;
    w-border: 2px solid;
    w-border-color: #FFFFFFFF;
    w-padding: 12px;
}

configuration {
    modi: "drun";
    show-icons: true;
    display-drun: "";
}

listview {
    columns: 1;
    lines: 7;
    fixed-height: true;
    fixed-columns: true;
    cycle: false;
    scrollbar: false;
    border: 0px solid;
}

window {
    transparency: "real";
    width: 700px;
    border-radius: @b-radius;
    background-color: @wbg-color;
    border: @w-border;
    border-color: @w-border-color;
    padding: @w-padding;
}

prompt {
    text-color: @fg-color;
}

inputbar {
    children: ["prompt", "entry"];
    spacing: @g-spacing;
}

entry {
    placeholder: "Search Apps";
    text-color: @fg-color;
    placeholder-color: @fgp-color;
}

mainbox {
    spacing: @g-spacing;
    margin: @g-margin;
    padding: @g-padding;
    children: ["inputbar", "listview", "message"];
}

element {
    spacing: @g-spacing;
    margin: @g-margin;
    padding: @g-padding;
    border: 0px solid;
    border-radius: @b-radius;
    border-color: @b-color;
    background-color: transparent;
    text-color: @fg-color;
}

element normal.normal {
	background-color: transparent;
	text-color: @fg-color;
}

element alternate.normal {
	background-color: @alt-color;
	text-color: @fg-color;
}

element selected.active {
	background-color: @hl-color;
	text-color: @hlt-color;
}

element selected.normal {
	background-color: @hl-color;
	text-color: @hlt-color;
}

message {
    background-color: red;
    border: 0px solid;
}
EOF

cat <<'EOF' > ~/.config/hypr/hyprland.conf
################
### MONITORS ###
################

# See https://wiki.hypr.land/Configuring/Monitors/
monitor=,preferred,auto,1


###################
### MY PROGRAMS ###
###################

# See https://wiki.hypr.land/Configuring/Keywords/

# Set programs that you use
$terminal = kitty
$fileManager = nautilus
$menu = rofi -show drun


#################
### AUTOSTART ###
#################

# Autostart necessary processes (like notifications daemons, status bars, etc.)
# Or execute your favorite apps at launch like this:

# exec-once = $terminal
# exec-once = nm-applet &
# exec-once = waybar & hyprpaper & firefox
exec-once = waybar
exec-once = hyprpaper
exec-once = swaync

#############################
### ENVIRONMENT VARIABLES ###
#############################

# See https://wiki.hypr.land/Configuring/Environment-variables/

env = XCURSOR_SIZE,24
env = HYPRCURSOR_SIZE,24


###################
### PERMISSIONS ###
###################

# See https://wiki.hypr.land/Configuring/Permissions/
# Please note permission changes here require a Hyprland restart and are not applied on-the-fly
# for security reasons

# ecosystem {
#   enforce_permissions = 1
# }

# permission = /usr/(bin|local/bin)/grim, screencopy, allow
# permission = /usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland, screencopy, allow
# permission = /usr/(bin|local/bin)/hyprpm, plugin, allow


#####################
### LOOK AND FEEL ###
#####################

# Refer to https://wiki.hypr.land/Configuring/Variables/

# https://wiki.hypr.land/Configuring/Variables/#general
general {
    gaps_in = 5
    gaps_out = 5

    border_size = 3

    # https://wiki.hypr.land/Configuring/Variables/#variable-types for info about colors
    col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
    col.inactive_border = rgba(595959aa)

    # Set to true enable resizing windows by clicking and dragging on borders and gaps
    resize_on_border = true

    # Please see https://wiki.hypr.land/Configuring/Tearing/ before you turn this on
    allow_tearing = false

    layout = dwindle
}

# https://wiki.hypr.land/Configuring/Variables/#decoration
decoration {
    rounding = 5
    rounding_power = 2

    # Change transparency of focused and unfocused windows
    active_opacity = 0.93
    inactive_opacity = 0.87

    shadow {
        enabled = true
        range = 4
        render_power = 3
        color = rgba(1a1a1aee)
    }

    # https://wiki.hypr.land/Configuring/Variables/#blur
    blur {
        enabled = true
        size = 1
        passes = 2

        vibrancy = 0.1696
    }
}

# https://wiki.hypr.land/Configuring/Variables/#animations
animations {
    enabled = yes, please :)

    # Default curves, see https://wiki.hypr.land/Configuring/Animations/#curves
    #        NAME,           X0,   Y0,   X1,   Y1
    bezier = easeOutQuint,   0.23, 1,    0.32, 1
    bezier = easeInOutCubic, 0.65, 0.05, 0.36, 1
    bezier = linear,         0,    0,    1,    1
    bezier = almostLinear,   0.5,  0.5,  0.75, 1
    bezier = quick,          0.15, 0,    0.1,  1

    # Default animations, see https://wiki.hypr.land/Configuring/Animations/
    #           NAME,          ONOFF, SPEED, CURVE,        [STYLE]
    animation = global,        1,     10,    default
    animation = border,        1,     5.39,  easeOutQuint
    animation = windows,       1,     4.79,  easeOutQuint
    animation = windowsIn,     1,     4.1,   easeOutQuint, popin 87%
    animation = windowsOut,    1,     1.49,  linear,       popin 87%
    animation = fadeIn,        1,     1.73,  almostLinear
    animation = fadeOut,       1,     1.46,  almostLinear
    animation = fade,          1,     3.03,  quick
    animation = layers,        1,     3.81,  easeOutQuint
    animation = layersIn,      1,     4,     easeOutQuint, fade
    animation = layersOut,     1,     1.5,   linear,       fade
    animation = fadeLayersIn,  1,     1.79,  almostLinear
    animation = fadeLayersOut, 1,     1.39,  almostLinear
    animation = workspaces,    1,     1.94,  almostLinear, fade
    animation = workspacesIn,  1,     1.21,  almostLinear, fade
    animation = workspacesOut, 1,     1.94,  almostLinear, fade
    animation = zoomFactor,    1,     7,     quick
}

# Ref https://wiki.hypr.land/Configuring/Workspace-Rules/
# "Smart gaps" / "No gaps when only"
# uncomment all if you wish to use that.
# workspace = w[tv1], gapsout:0, gapsin:0
# workspace = f[1], gapsout:0, gapsin:0
# windowrule {
#     name = no-gaps-wtv1
#     match:float = false
#     match:workspace = w[tv1]
#
#     border_size = 0
#     rounding = 0
# }
#
# windowrule {
#     name = no-gaps-f1
#     match:float = true
#     match:workspace = f[1]
#
#     border_size = 0
#     rounding = 0
# }

# See https://wiki.hypr.land/Configuring/Dwindle-Layout/ for more
dwindle {
    pseudotile = true # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
    preserve_split = true # You probably want this
}

# See https://wiki.hypr.land/Configuring/Master-Layout/ for more
master {
    new_status = master
}

# https://wiki.hypr.land/Configuring/Variables/#misc
misc {
    force_default_wallpaper = 1 # Set to 0 or 1 to disable the anime mascot wallpapers
    disable_hyprland_logo = true # If true disables the random hyprland logo / anime girl background. :(
}


#############
### INPUT ###
#############

# https://wiki.hypr.land/Configuring/Variables/#input
input {
    kb_layout = us
    kb_variant =
    kb_model =
    kb_options =
    kb_rules =

    follow_mouse = 1

    sensitivity = 0 # -1.0 - 1.0, 0 means no modification.

    touchpad {
        natural_scroll = true
    }
}

# See https://wiki.hypr.land/Configuring/Gestures
gesture = 3, horizontal, workspace

# Example per-device config
# See https://wiki.hypr.land/Configuring/Keywords/#per-device-input-configs for more
device {
    name = epic-mouse-v1
    sensitivity = 0.5
}


###################
### KEYBINDINGS ###
###################

# See https://wiki.hypr.land/Configuring/Keywords/
$mainMod = SUPER # Sets "Windows" key as main modifier

# Example binds, see https://wiki.hypr.land/Configuring/Binds/ for more
bind = $mainMod, Q, exec, $terminal
bind = $mainMod, C, killactive,
bind = $mainMod, M, exec, command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit
bind = $mainMod, E, exec, $fileManager
bind = $mainMod, V, togglefloating,
bind = $mainMod, D, exec, $menu
bind = $mainMod, P, pseudo, # dwindle
bind = $mainMod, J, layoutmsg, togglesplit # dwindle
#bind = $mainMod, F10, exec, hyprshot -m region --clipboard-only

# Move focus with mainMod + arrow keys
bind = $mainMod, left, movefocus, l
bind = $mainMod, right, movefocus, r
bind = $mainMod, up, movefocus, u
bind = $mainMod, down, movefocus, d

# Switch workspaces with mainMod + [0-9]
bind = $mainMod, 1, workspace, 1
bind = $mainMod, 2, workspace, 2
bind = $mainMod, 3, workspace, 3
bind = $mainMod, 4, workspace, 4
bind = $mainMod, 5, workspace, 5
bind = $mainMod, 6, workspace, 6
bind = $mainMod, 7, workspace, 7
bind = $mainMod, 8, workspace, 8
bind = $mainMod, 9, workspace, 9
bind = $mainMod, 0, workspace, 10

# Move active window to a workspace with mainMod + SHIFT + [0-9]
bind = $mainMod SHIFT, 1, movetoworkspace, 1
bind = $mainMod SHIFT, 2, movetoworkspace, 2
bind = $mainMod SHIFT, 3, movetoworkspace, 3
bind = $mainMod SHIFT, 4, movetoworkspace, 4
bind = $mainMod SHIFT, 5, movetoworkspace, 5
bind = $mainMod SHIFT, 6, movetoworkspace, 6
bind = $mainMod SHIFT, 7, movetoworkspace, 7
bind = $mainMod SHIFT, 8, movetoworkspace, 8
bind = $mainMod SHIFT, 9, movetoworkspace, 9
bind = $mainMod SHIFT, 0, movetoworkspace, 10

# Example special workspace (scratchpad)
bind = $mainMod, S, togglespecialworkspace, magic
bind = $mainMod SHIFT, S, movetoworkspace, special:magic

# Scroll through existing workspaces with mainMod + scroll
bind = $mainMod, mouse_down, workspace, e+1
bind = $mainMod, mouse_up, workspace, e-1

# Move/resize windows with mainMod + LMB/RMB and dragging
bindm = $mainMod, mouse:272, movewindow
bindm = $mainMod, mouse:273, resizewindow

# Laptop multimedia keys for volume and LCD brightness
bindel = , XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
bindel = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
bindel = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
bindel = , XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
bindel = , XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+
bindel = , XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-

# Requires playerctl
bindl = , XF86AudioNext, exec, playerctl next
bindl = , XF86AudioPause, exec, playerctl play-pause
bindl = , XF86AudioPlay, exec, playerctl play-pause
bindl = , XF86AudioPrev, exec, playerctl previous

##############################
### WINDOWS AND WORKSPACES ###
##############################

# See https://wiki.hypr.land/Configuring/Window-Rules/ for more
# See https://wiki.hypr.land/Configuring/Workspace-Rules/ for workspace rules

# Example windowrules that are useful

windowrule {
    # Ignore maximize requests from all apps. You'll probably like this.
    name = suppress-maximize-events
    match:class = .*

    suppress_event = maximize
}

windowrule {
    # Fix some dragging issues with XWayland
    name = fix-xwayland-drags
    match:class = ^$
    match:title = ^$
    match:xwayland = true
    match:float = true
    match:fullscreen = false
    match:pin = false

    no_focus = true
}

# Hyprland-run windowrule
windowrule {
    name = move-hyprland-run

    match:class = hyprland-run

    move = 20 monitor_h-120
    float = yes
}

EOF

echo "#################################"
echo "# Installing SDDM Login Manager #"
echo "#################################"
read -rp "Install And Enable SDDM? (Y/N) " SDDM_RESP
case "$SDDM_RESP" in
    [yY])
        echo "Installing SDDM . . ."
        sudo pacman -S sddm --noconfirm >/dev/null 2>&1 || { clear; echo "You are NOT conected to the internet."; exit 1; }
        sudo systemctl enable sddm.service
        clear
        ;;
    [nN])
        clear;;
    *)
        echo "Invalid Input, Skipping . . ."
        ;;
    esac
clear
echo "In Hyprland, By Default, Use SUPER (Windows Key) + D To Use App Launcher, SUPER + Q To Open Terminal, SUPER + C To Close App, And SUPER + SHIFT + Q To Exit Hyprland. You Can Change These In ~/.config/hypr/hyprland.conf"
echo "If You're In SDDM, Switch Your Desktop To Hyprland, If You're In A TTY, Run 'start-hyprland' To Start Hyprland. Enjoy :)"
fi
break
;;
KDE)
	if command -v pacman >/dev/null 2>&1; then
	sudo pacman -S --noconfirm plasma dolphin konsole discover sddm --noconfirm >/dev/null 2>&1 || { clear; echo "You are NOT conected to the internet."; exit 1; }
	fi
	break
	;;
*)
echo "Invalid Option: $REPLY"
;;
esac
done
mv ~/paru ~/paru-backup >/dev/null 2>&1 || true
		git clone https://aur.archlinux.org/paru.git >/dev/null 2>&1 || { echo "Clone Failed! Please Install Git And Dependencies!"; exit 1; }
		cd ~/paru || { echo "Folder Paru Not Found"; exit 1; }
        clear
			cat << "EOF"
__  _______ _   _ 
\ \/ / ____| \ | |
 \  /|  _| |  \| |
 /  \| |___| |\  |
/_/\_\_____|_| \_|
  13% Done!
EOF
		echo "Installing Paru AUR Helper . . ."
		makepkg -si --noconfirm >/dev/null 2>&1 || { clear; echo "This Likely Failed Because You Ran The Script As Root Or You're The Root User Instead Of A Standard User"; cd /home/"$USER" || true; rm -rf paru; exit 1; }
	cd /home/"$USER" || exit
rm -rf ~/paru

clear
	cat << "EOF"
__  _______ _   _ 
\ \/ / ____| \ | |
 \  /|  _| |  \| |
 /  \| |___| |\  |
/_/\_\_____|_| \_|
  35% Done!
EOF

PS3="Would You Like Bluetooth?
"
options=("Yes" "No")
select opt in "${options[@]}"
do
	case $opt in
		"Yes")
			sudo pacman -S bluez bluez-utils --noconfirm >/dev/null 2>&1 || { echo "Failed To Install Bluetooth, Please Check Your Internet Connection!"; exit 1; }
			sudo systemctl enable --now bluetooth >/dev/null 2>&1 || true
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

clear
	cat << "EOF"
__  _______ _   _ 
\ \/ / ____| \ | |
 \  /|  _| |  \| |
 /  \| |___| |\  |
/_/\_\_____|_| \_|
  42% Done!
EOF

PS3="Would You Like ADB And Fastboot, Along With Heimdall? (If You Don't Know What These Are, You Don't Need Them)
"
options=("Yes" "No")
select opt in "${options[@]}"
do
	case $opt in
		"Yes")
			sudo pacman -S android-tools heimdall android-udev gvfs-mtp --noconfirm >/dev/null 2>&1 || { echo "Failed To Install ADB And Fastboot, Please Check Your Internet Connection!"; exit 1; }
			break
			;;
		"No")
			break
			;;
		esac
	done

clear
	cat << "EOF"
__  _______ _   _ 
\ \/ / ____| \ | |
 \  /|  _| |  \| |
 /  \| |___| |\  |
/_/\_\_____|_| \_|
  60% Done!
EOF

PS3="Would You Like To Install SSH? (A Program That Allows You To Type In Other Linux Computers Or Type In Your Terminal From Another Computer)
"
options=("Yes" "No")
select opt in "${options[@]}"
do
	case $opt in
		"Yes")
			sudo pacman -S openssh --noconfirm >/dev/null 2>&1 || { echo "Failed To Install SSH, Please Check Your Internet Connection!"; exit 1; }
			sudo systemctl enable sshd >/dev/null 2>&1 || true
			sudo systemctl start sshd >/dev/null 2>&1 || true
			break
			;;
		"No")
			break
			;;
		esac
	done

clear
	cat << "EOF"
__  _______ _   _ 
\ \/ / ____| \ | |
 \  /|  _| |  \| |
 /  \| |___| |\  |
/_/\_\_____|_| \_|
  65% Done!
EOF

PS3="Would You Like To Use Fish Shell Instead Of Bash?
"
options=("Yes" "No")
select opt in "${options[@]}"
do
	case $opt in
		"Yes")
			sudo pacman -S fish --noconfirm >/dev/null 2>&1 || { echo "Failed To Install Fish Shell, Please Check Your Internet Connection!"; exit 1; }
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
	cat << "EOF"
__  _______ _   _ 
\ \/ / ____| \ | |
 \  /|  _| |  \| |
 /  \| |___| |\  |
/_/\_\_____|_| \_|
  76% Done!
EOF

	paru -S balena-etcher --noconfirm >/dev/null 2>&1 || true
	paru -S ventoy-bin --noconfirm >/dev/null 2>&1 || true
	paru -S qdl --noconfirm >/dev/null 2>&1 || true
cd /home/"$USER" || exit
fastfetch --gen-config-force >/dev/null 2>&1 || true
clear
	cat << "EOF"
__  _______ _   _ 
\ \/ / ____| \ | |
 \  /|  _| |  \| |
 /  \| |___| |\  |
/_/\_\_____|_| \_|
  80% Done!
EOF

	rm -rf ~/.config/fastfetch
	mkdir -p ~/.config/fastfetch
	setup_fastfetch

sudo systemctl enable NetworkManager sddm.service power-profiles-daemon.service >/dev/null 2>&1 || true
sudo systemctl start power-profiles-daemon.service >/dev/null 2>&1 || true

PS3='Would You Like Firefox, Chrome, None, or Something Else?
'
options=("Firefox" "Google Chrome" "Something Else" "None")

select opt in "${options[@]}"
do
	case $opt in
		"Firefox")
			sudo pacman -S firefox >/dev/null 2>&1 || true
			break
			;;
		"Google Chrome")
			paru -S google-chrome --noconfirm >/dev/null 2>&1 || true
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
							paru -S brave-bin --noconfirm >/dev/null 2>&1 || true
							break
							;;
						"Zen")
							paru -S zen-browser-bin --noconfirm >/dev/null 2>&1 || true
							break
							;;
						"Chromium")
							sudo pacman -S chromium --noconfirm >/dev/null 2>&1 || true
							break
							;;
						"Librewolf")
							paru -S librewolf-bin --noconfirm >/dev/null 2>&1 || true
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
	cat << "EOF"
__  _______ _   _ 
\ \/ / ____| \ | |
 \  /|  _| |  \| |
 /  \| |___| |\  |
/_/\_\_____|_| \_|
  90% Done!
EOF


PS3='Would You Like Localsend, Discord, Neither, or Both? 
'
options=("Localsend" "Discord" "Both" "Neither")

select opt in "${options[@]}"
do
	case $opt in
		"Localsend")
			paru -S localsend-bin --noconfirm >/dev/null 2>&1 || true
			break
			;;
		"Discord")
			sudo pacman -S discord --noconfirm >/dev/null 2>&1 || true
			break
			;;
		"Both")
			sudo pacman -S discord --noconfirm >/dev/null 2>&1 || true
			paru -S localsend-bin --noconfirm >/dev/null 2>&1 || true
			break
			;;
		"Neither")
			break
			;;
	esac
	done

if command -v konsole >/dev/null 2>&1; then
	paru -S kde-material-you-colors --noconfirm
fi

clear
	cat << "EOF"
__  _______ _   _ 
\ \/ / ____| \ | |
 \  /|  _| |  \| |
 /  \| |___| |\  |
/_/\_\_____|_| \_|
  100% Done!
EOF
sudo systemctl enable NetworkManager power-profiles-daemon.service >/dev/null 2>&1 || true
if command -v sddm; then
	sudo systemctl enable sddm.service >/dev/null 2>&1 || true
fi

echo "Changing your shell typically requires a restart for it to fully take affect, would you like to reboot?"
PS3='What Would You Like To Do?
'
options=("Restart" "Exit To Typing")

select opt in "${options[@]}"
do
	case $opt in
		"Restart")
			sudo reboot now
			;;
		"Exit To Typing")
			exit
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
	cat << "EOF"
__  _______ _   _ 	
\ \/ / ____| \ | |
 \  /|  _| |  \| |
/  \| |___| |\  |
/_/\_\_____|_| \_|
0% Done! Currently Working!
EOF
		sudo apt update && sudo apt upgrade -y >/dev/null 2>&1 || { echo "You are NOT connected to the internet!"; exit 1; }
    clear
	cat << "EOF"
__  _______ _   _ 	
\ \/ / ____| \ | |
 \  /|  _| |  \| |
/  \| |___| |\  |
/_/\_\_____|_| \_|
   12% Done!
EOF
		sudo apt install nala wl-clipboard qdl network-manager libfuse2 7zip curl eog acpi flatpak vim bat nano power-profiles-daemon gvfs -y >/dev/null 2>&1 || { echo "You are NOT connected to the internet!"; exit 1; }
    clear
	cat << "EOF"
__  _______ _   _ 	
\ \/ / ____| \ | |
 \  /|  _| |  \| |
/  \| |___| |\  |
/_/\_\_____|_| \_|
   25% Done!
EOF
		flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
		sudo apt remove konqueror -y >/dev/null 2>&1 || true
		sudo apt autoremove -y >/dev/null 2>&1 || true
    clear
	cat << "EOF"
__  _______ _   _ 	
\ \/ / ____| \ | |
 \  /|  _| |  \| |
/  \| |___| |\  |
/_/\_\_____|_| \_|
   33% Done!
EOF
	sudo systemctl enable NetworkManager power-profiles-daemon.service >/dev/null 2>&1 || true

PS3="Would You Like To Install KDE? (A Desktop Environment That Actually Lets You Use Your Computer Like Windows Instead Of Living In A Black Box)
"
options=("Yes" "No")
select opt in "${options[@]}"
do
	case $opt in
		"Yes")
			sudo nala install task-kde-desktop sddm plasma-discover-backend-flatpak discover -y >/dev/null 2>&1 || { echo "Failed To Install KDE, Please Check Your Internet Connection!"; exit 1; }
			break
			;;
		"No")
			break
			;;
		esac
	done

    clear
	cat << "EOF"
__  _______ _   _ 	
\ \/ / ____| \ | |
 \  /|  _| |  \| |
/  \| |___| |\  |
/_/\_\_____|_| \_|
   46% Done!
EOF

PS3="Would You Like ADB And Fastboot, Along With Heimdall? (If You Don't Know What These Are, You Don't Need Them)
"
options=("Yes" "No")
select opt in "${options[@]}"
do
	case $opt in
		"Yes")
			sudo nala install adb fastboot heimdall-flash -y >/dev/null 2>&1 || { echo "Failed To Install ADB And Fastboot, Please Check Your Internet Connection!"; exit 1; }
			break
			;;
		"No")
			break
			;;
		esac
	done

    clear
	cat << "EOF"
__  _______ _   _ 	
\ \/ / ____| \ | |
 \  /|  _| |  \| |
/  \| |___| |\  |
/_/\_\_____|_| \_|
   55% Done!
EOF

PS3="Would You Like To Install SSH? (A Program That Allows You To Type In Other Linux Computers Or Type In Your Terminal From Another Computer)
"
options=("Yes" "No")
select opt in "${options[@]}"
do
	case $opt in
		"Yes")
			sudo nala install ssh -y >/dev/null 2>&1 || { echo "Failed To Install SSH, Please Check Your Internet Connection!"; exit 1; }
			sudo systemctl enable ssh >/dev/null 2>&1 || true
			sudo systemctl start ssh >/dev/null 2>&1 || true
			break
			;;
		"No")
			break
			;;
		esac
	done

    clear
	cat << "EOF"
__  _______ _   _ 	
\ \/ / ____| \ | |
 \  /|  _| |  \| |
/  \| |___| |\  |
/_/\_\_____|_| \_|
   67% Done!
EOF

PS3="Would You Like To Use Fish Shell Instead Of Bash?
"
options=("Yes" "No")
select opt in "${options[@]}"
do
	case $opt in
		"Yes")
			sudo nala install fish -y >/dev/null 2>&1 || { echo "Failed To Install Fish Shell, Please Check Your Internet Connection!"; exit 1; }
			mkdir -p ~/.config/fish >/dev/null 2>&1 || true
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

    clear
	cat << "EOF"
__  _______ _   _ 	
\ \/ / ____| \ | |
 \  /|  _| |  \| |
/  \| |___| |\  |
/_/\_\_____|_| \_|
   75% Done!
EOF

PS3="What Browser Would You Like?
"
options=("Firefox" "Chrome" "Skip")
select opt in "${options[@]}"
do
	case $opt in
		"Firefox")
			sudo nala install firefox -y >/dev/null 2>&1 || { echo "Failed To Install Firefox, Please Check Your Internet Connection!"; exit 1; }
			clear
			break
			;;
		"Chrome")
			wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb >/dev/null 2>&1 || { echo "Failed To Download Chrome, Please Check Your Internet Connection!"; exit 1; }
			sudo nala install ./google-chrome-stable_current_amd64.deb -y >/dev/null 2>&1 || { echo "Failed To Install Chrome, Please Check Your Internet Connection!"; exit 1; }
			rm google-chrome* >/dev/null 2>&1 || true
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
	cat << "EOF"
__  _______ _   _ 	
\ \/ / ____| \ | |
 \  /|  _| |  \| |
/  \| |___| |\  |
/_/\_\_____|_| \_|
   90% Done!
EOF

PS3="Would You Like To Reboot (Recommended), Go Straight To KDE, Or Exit The Script Now?
"
options=("Reboot" "KDE" "Exit")
select opt in "${options[@]}"
do
	case $opt in
		"Reboot")
			sudo systemctl enable sddm.service >/dev/null 2>&1 || true
			sudo systemctl reboot
			;;
		"KDE")
			sudo systemctl start sddm.service
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
	cat << "EOF"
__  _______ _   _ 	
\ \/ / ____| \ | |
 \  /|  _| |  \| |
/  \| |___| |\  |
/_/\_\_____|_| \_|
   0% Done!
EOF
		sudo dnf update -y >/dev/null 2>&1 || { echo "You are NOT connected to the internet!"; exit 1; }
		sudo dnf install yt-dlp fastfetch nano vim wl-clipboard curl flatpak 7zip git acpi power-profiles-daemon usbutils -y --allowerasing >/dev/null 2>&1 || { echo "You are NOT connected to the internet!"; exit 1; }
    clear
	cat << "EOF"
__  _______ _   _ 	
\ \/ / ____| \ | |
 \  /|  _| |  \| |
/  \| |___| |\  |
/_/\_\_____|_| \_|
   12% Done!
EOF
		sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	clear
	sudo flatpak install flathub org.localsend.localsend_app -y >/dev/null 2>&1 || true
    clear
	cat << "EOF"
__  _______ _   _ 	
\ \/ / ____| \ | |
 \  /|  _| |  \| |
/  \| |___| |\  |
/_/\_\_____|_| \_|
   19% Done!
EOF
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
			sudo dnf install android-tools heimdall gvfs-mtp -y >/dev/null 2>&1 || { echo "Failed To Install ADB And Fastboot, Please Check Your Internet Connection!"; exit 1; }
			break
			;;
		"No")
			break
			;;
		esac
	done

    clear
	cat << "EOF"
__  _______ _   _ 	
\ \/ / ____| \ | |
 \  /|  _| |  \| |
/  \| |___| |\  |
/_/\_\_____|_| \_|
   24% Done!
EOF

PS3="Would You Like To Install SSH? (A Program That Allows You To Type In Other Linux Computers Or Type In Your Terminal From Another Computer)
"
options=("Yes" "No")
select opt in "${options[@]}"
do
	case $opt in
		"Yes")
			sudo dnf install ssh -y >/dev/null 2>&1 || { echo "Failed To Install SSH, Please Check Your Internet Connection!"; exit 1; }
			sudo systemctl enable sshd >/dev/null 2>&1 || true
			sudo systemctl start sshd >/dev/null 2>&1 || true
			break
			;;
		"No")
			break
			;;
		esac
	done

    clear
	cat << "EOF"
__  _______ _   _ 	
\ \/ / ____| \ | |
 \  /|  _| |  \| |
/  \| |___| |\  |
/_/\_\_____|_| \_|
   30% Done!
EOF

PS3="Would You Like To Use Fish Shell Instead Of Bash?
"
options=("Yes" "No")
select opt in "${options[@]}"
do
	case $opt in
		"Yes")
			sudo dnf install fish -y >/dev/null 2>&1 || { echo "Failed To Install Fish Shell, Please Check Your Internet Connection!"; exit 1; }
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

    clear
	cat << "EOF"
__  _______ _   _ 	
\ \/ / ____| \ | |
 \  /|  _| |  \| |
/  \| |___| |\  |
/_/\_\_____|_| \_|
   57% Done!
EOF

PS3="What Browser Would You Like?
"
options=("Firefox" "Chrome")
select opt in "${options[@]}"
do
	case $opt in
		"Firefox")
			sudo dnf install firefox -y >/dev/null 2>&1 || { echo "Failed To Install Firefox, Please Check Your Internet Connection!"; exit 1; }
			break
			;;
		"Chrome")
			wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm >/dev/null 2>&1 || { echo "Failed To Download Chrome, Please Check Your Internet Connection!"; exit 1; }
			sudo dnf install ./google-chrome-stable_current_x86_64.rpm -y >/dev/null 2>&1 || true
			rm google-chrome* >/dev/null 2>&1 || true
			clear
			break
			;;
		*)
			echo "Invalid Option: $REPLY"
			;;
		esac
	done

    clear
	cat << "EOF"
__  _______ _   _ 	
\ \/ / ____| \ | |
 \  /|  _| |  \| |
/  \| |___| |\  |
/_/\_\_____|_| \_|
   90% Done!
EOF

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
                sudo apt install bluetooth bluez -y
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
                sudo dnf install bluez bluez-tools -y
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
