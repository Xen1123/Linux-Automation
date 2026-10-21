<h1 align=center>This Is A Linux Command Sheet!</h1>
<h3 align=center>With Explanations & Examples<h3>
<h2 align="center">
  <img src="https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black" />
</h2>
  
<h2 align=center>Data Management</h2>
  
- **DD**
  - Used to write data bit-by-bit
    - `sudo dd if=/path/to/your/file of=/dev/device bs=4M conv=fsync status=progress`
  - Zeroing Out A Drive **(Completely Erasing It)**
    - `sudo dd if=/dev/zero of=/dev/device bs=4M conv=fsync status=progress`
- **MV**
  - Used to move data (scripts, images, folders, etc.) across your device
    - `mv ~/Downloads/Arch-Linux.iso ~/Operating-Systems/Arch-Linux.iso`
  - You can also rename items with the "mv" command
    - `mv ~/Downloads/Arch-Linux.iso ~/Operating-Systems/Arch.iso`
      - **CP** is the copy command, it works the same as `mv`, but it copies the item over instead of just transferring it.
- **CAT**
  - Used to show the file content of text files like .txt and .sh
    - `cat ~/Android/Phone-Debloat.sh`
    - `cat ~/Documents/Grocery-Bill.txt`
      - You may also use pipes with "|", this will redirect your command to whatever you put after the pipe.
        - `cat ~/Documents/Grocery-Bill.txt | wl-copy` would copy the contents to your clipboard if you had `wl-clipboard` installed.
- **RM**
  - Used to delete files (remove) PERMANENTLY, do not expect for there to be a trash where you can pull your files out!
    - `rm ~/Documents/Grocery-Bill.txt`
  - Adding the `-rf` flag allows rm to delete folders
    - `rm -rf ~/Documents`
- **CD**
  - Used to change your directory, this makes typing easier, as you won't have to type out long names
    - `cd ~/Downloads/Pictures` Puts you in the `Pictures` folder inside of `Downloads`
- **PWD**
  - Simply tells you where you are
```bash
eric@larpaholic ~> pwd
/home/eric
eric@larpaholic ~> 
```
- **LS**
  - Known as `list`, it lists the files in your working directory.
```bash
eric@larpaholic ~/Android> ls
Magisk.apk  Magisk.zip  Nothing3a/  Root-Help/  android-flasher.sh  phone-debloat.sh
eric@larpaholic ~/Android> 
```
<details>
  <summary>Click To See The Recursive Summary</summary>

```bash
eric@larpaholic ~/Android> ls -R
.:
Magisk.apk  Magisk.zip  Nothing3a/  Root-Help/  android-flasher.sh  phone-debloat.sh

./Nothing3a:
abl.img         cpucp_dtb.img    imagefv.img      product.img   system_dlkm.img  vbmeta_system.img  xbl_config.img
aop.img         devcfg.img       init_boot.img    pvmfw.img     system_ext.img   vbmeta_vendor.img  xbl_ramdump.img
aop_config.img  dsp.img          keymaster.img    qupfw.img     tz.img           vendor.img
bluetooth.img   dtbo.img         modem.img        recovery.img  uefi.img         vendor_boot.img
boot.img        featenabler.img  multiimgoem.img  shrm.img      uefisecapp.img   vendor_dlkm.img
cpucp.img       hyp.img          odm.img          system.img    vbmeta.img       xbl.img

./Root-Help:
 AdAway.apk       KsuWebUI.apk           LawnIcons.apk   Strong-Integrity.zip   Yurikey.zip
 GlobalIcon.apk  'LSPosed(Vector).zip'   Rezygisk.zip    Tricky-Store.zip
eric@larpaholic ~/Android> 
```
</details>

<h2 align=center>Utility & App Management</h2>

- **LSBLK**
  - Lists block devices (typically other storage devices/partitions)
<details>
  <summary>Click To See Block List Demonstration</summary>

```bash
eric@larpaholic ~> lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda           8:0    1 119.5G  0 disk 
|-sda1        8:1    1 119.5G  0 part 
`-sda2        8:2    1    32M  0 part 
nvme0n1     259:0    0 476.9G  0 disk 
|-nvme0n1p1 259:1    0     1G  0 part /boot
`-nvme0n1p2 259:2    0 475.9G  0 part /
eric@larpaholic ~> 
```
</details>

- **LSUSB**
  - This command lists USB devices and other connected devices, not just USBs.
<details>
  <summary>Click To See LSUSB Demonstration</summary>

```bash
eric@larpaholic ~> lsusb
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 003 Device 002: ID 1bcf:28c4 Sunplus Innovation Technology Inc. Integrated_Webcam_HD
Bus 003 Device 003: ID 0a5c:5843 Broadcom Corp. BCM58200 ControlVault 3 (FingerPrint sensor + Contacted SmartCard)
Bus 003 Device 004: ID 8087:0a2b Intel Corp. Bluetooth wireless interface
Bus 004 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 004 Device 002: ID 04e8:6300 Samsung Electronics Co., Ltd Flash Drive
eric@larpaholic ~> 
```
</details>

<h2 align=center>Running Items & Permissions</h2>

- **CHMOD**
  - Changes what a file can do or what you can do to it
    - `chmod +x <file_name>` will make your file executable, which is how you run scripts
    - You can also use chmod to change what someone can do to the file with numbers.
      - chmod adds up to 7, for example, `chmod 7 <file>` would make it so you can read it, write to it, and execute it, 6 is just read and write, 5 is read and execute, and 4 just lets you read it.

<h2 align=center>Main Package Managers</h2>

- **APT**
  - Used on Debian/Ubuntu based systems
    - `sudo apt install`
    - `sudo apt update`
    - `sudo apt upgrade`
    - `sudo apt remove`
- **DNF**
  - Used on Fedora based systems
    - `sudo dnf install`
    - `sudo dnf update`
    - `sudo dnf remove`
- **Pacman**
  - Used on Arch based systems
    - `sudo pacman -S` (Install)
    - `sudo pacman -Rnc` (Remove/Uninstall)
    - `sudo pacman -Sy` (Update)
      - `sudo pacman -Syu`
      - `sudo pacman -Syyu` 
<h2 align=center>Miscellaneous Info</h2>

- **UNAME**
  - The `uname` command shows critical system info
    - Typically used as `uname -a` to show all info
    - The information this command shows includes date and time, CPU architecture, and your kernel
- **TIPS**
  - Using `TAB` in an unfinished command will typically finish it, like if you're trying to move to a directory, and you type `cd do`, and there are two or more directories that start with `do`, and you type `TAB`, it will show you your options, if there is only one option, it will autofill the command.
  - You can change shells, bash isn't the only shell in Linux, there are two other largely used shells, `fish` and `zsh`, you can download them with your package manager and then use `chsh -s /usr/bin/the_shell_you_want` to change your default shell.
