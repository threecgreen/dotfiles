# Basic guide for install Arch Linux with UEFI and disk encryption
# Based https://gist.github.com/mattiaslundberg/8620837
# Connect to wifi
wifi-menu

# See current disks and partitions
lsblk
# Configure partitions
# 1. 100MB EFI partition # Hex code ef00
# 2. 250MB /boot partition # Hex code 8300
# 3. 100% remaining to be encrypted # Hex code 8300
cgdisk /dev/sda

# Format EFI and /boot
mkfs.vfat -F32 /dev/sdX1
mkfs.ext2 /dev/sdX2

# Setup encryption
cryptsetup -c aes-xts-plain64 -y --use-random luksFormat /dev/sdX3
# Type YES
cryptsetup luksOpen /dev/sdX3 luks

# Create encrypted partitions
# Create partitions for /home and /
# Also create one for swap if not swapping on another drive
pvcreate /dev/mapper/luks
vgcreate vg0 /dev/mapper/luks
# Root
lvcreate --size 50GB vg0 --name root
# Home with remaining space
lvcreate -l +100%FREE vg0 --name home

# Create filesystems for encrypted partitions
mkfs.ext4 /dev/mapper/vg0-root
mkfs.ext4 /dev/mapper/vg0-home

# Swap where swapping
mkswap /path/to/swap
swapon /path/to/swap

# Mount filesystem
mount /dev/mapper/vg0-root /mnt
# Create /boot and mount
mkdir /mnt/boot
mount /dev/sdX2 /mnt/boot
mkdir /mnt/boot/efi
mount /dev/sdX1 /mnt/boot/efi
# Create /home and mount
mkdir /mnt/home
mount /dev/mapper/vg0-home /mnt/home

# Bootstrap the basic system dependencies, z shell, efi utils and wifi packages
pacstrap /mnt base base-devel grub-efi-x86_64 zsh vim git efibootmgr dialog wpa_supplicant

# Generate filesystem table
genfstab -pU /mnt >> /mnt/etc/fstab

# Enter the new system
arch-chroot /mnt /bin/bash

# Set time zone
# See all zones
ls /usr/share/zoneinfo
ln -s /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
# Set hardware clock
hwclock --systohc --utc

# Set hostname
echo SOMEHOSTNAME > /etc/hostname

# Set locale
vim /etc/locale.gen
# Uncomment en_US.UTF-8
vim /etc/locale.conf
# LANG=en_US.UTF-8

# Set root password
passwd

# Add users with zsh shell as default
useradd -m -g users -G wheel -s /bin/zsh MYUSERNAME
# Set user password
passwd MYUSERNAME

# Enable wheel members to use sudo
visudo

# Configure default wifi network
# netctl enable name-of-profile

# Configure mkinitcpio with modules needed for the initrd image
vim /etc/mkinitcpio.conf
# HOOKS="base udev autodetect modconf block keymap encrypt lvm2 resume filesystems keyboard fsck"
# Generate initrd image
mkinitcpio -p linux

# Configure grub
grub-install
# Edit the line GRUB_CMDLINE_LINUX to GRUB_CMDLINE_LINUX="cryptdevice=/dev/sdX3:luks:allow-discards" then run:
vim /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

# Update system
pacman -Syu

# Exit new system and go into the cd shell
exit

# Unmount all partitions
umount -R /mnt
swapoff -a

# Reboot into the new system, don't forget to remove the cd/usb
reboot

# Install NVIDIA graphics driver
# Determine graphics card
lspci -k | grep -A 2 -E "(VGA|3D)"

# Install X server, window manager, download dotfiles
pacman -S xorg xorg-server xorg-xinit
# Clone and install aurman to manage AUR packages
git clone git@github.com:polygamma/aurman
# Install i3-gaps, polybar, compton, redshift, rofi, plymouth
aurman -S i3-gaps polybar compton redshift rofi plymouth
