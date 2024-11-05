#!/usr/bin/env bash
# Configure live iso
# 
set -e -u -x
shopt -s extglob

# Set locales
sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

# Allow Parallel Downloads in pacman
sed -i "s/^#Parallel/Parallel/g" /etc/pacman.conf 

# Un-comment mirrorlist to allow pacman to work live....
sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist

# Sudo to allow no password
sed -i 's/# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/g' /etc/sudoers
chown -c root:root /etc/sudoers
chmod -c 0440 /etc/sudoers

# Hostname
echo "archbang" > /etc/hostname

# Vconsole
echo "KEYMAP=us" > /etc/vconsole.conf
echo "FONT=" >> /etc/vconsole.conf

# Locale
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "LC_COLLATE=C" >> /etc/locale.conf

# Set clock to UTC
hwclock --systohc --utc

# Timezone
ln -sf /usr/share/zoneinfo/Canada/Montreal /etc/localtime

# Add live user
useradd -m -p "" -G "wheel" -s /bin/bash -g users ablive
chown ablive /home/ablive

# Link for xterm to allow htop to work in xdg_menu
ln -s /usr/bin/alacritty /usr/bin/xterm

# Start required systemd services
systemctl enable {pacman-init,NetworkManager}.service -f

#systemctl set-default multi-user.target
systemctl set-default graphical.target

# Revert from archiso preset to default preset
cp -rf "/usr/share/mkinitcpio/hook.preset" "/etc/mkinitcpio.d/linux.preset"
sed -i 's?%PKGBASE%?linux?' "/etc/mkinitcpio.d/linux.preset"

