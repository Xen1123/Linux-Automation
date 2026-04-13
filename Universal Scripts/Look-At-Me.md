<h1 align=center>Do These Before Running The Universal Setup Script!</h1>

<h3 align=center>This Ensures The Script Works Without Error On Newly Installed Systems</h3>

<h2 align=center>Arch Linux</h2>

- Ensure Your User Can Run Sudo
    - Login As Root Or Type `su -`
    - `pacman -S sudo --noconfirm`
    - `EDITOR=<your-choice-of-text-editor> visudo`
        - Go To The Bottom Of The File And Type This
            - `<YOUR USER> ALL=(ALL) NOPASSWD:ALL`
            - Save And Exit
            - Log In As Your User
- Make Sure You Are Connected To The Internet!
    - If You Have Already Connected, Make Sure It Is Active By Typing This
        - `ping ping.archlinux.org`
            - If You Don't Get Bytes, You Are Not Connected
    - Either Connect To Ethernet Or Get A Device That Can Share It's Network Over USB
        - Login As Root Or Type `su -`
            - `pacman -S networkmanager` Or `pacman -S iwd` (Network Manager Is Simpler To Use)
                - `systemctl enable NetworkManager && systemctl start NetworkManager`
                - `systemctl enable iwd && systemctl start iwd`
                - Open With `nmtui` For Network Manager And `iwctl`

<h2 align=center>Debian/Ubuntu</h2>

- Ensure Your User Can Run Sudo
    - Login As Root Or Type `su -`
    - `apt install sudo -y`
    - `visudo`
        - Go To The Bottom Of The File And Type This
            - `<YOUR USER> ALL=(ALL) NOPASSWD:ALL`
            - Save And Exit
            - Log In As Your User
- Make Sure You Have An Internet Connection!
    - If You Have Already Connected, Try To Ping A Server
        - `ping ping.archlinux.org`
            - If You Don't Get Bytes, You Are Not Connected
    - Either Connect To Ethernet Or Get A Device That Can Share It's Network Over USB
        - Login As Root Or Type `su -`
            - `apt install network-manager -y`
            - `systemctl enable NetworkManager && systemctl start NetworkManager`
            - Open With `nmtui` And Connect To Your Internet
    