#!/bin/bash
set -e;

#################################
#
# Arch Linux Install Script
#
# Created:  2025-03-27
# Device:   Lenovo IdeaPad 5 15ARE05
# CPU:      AMD Ryzen 5 4500U
# GPU:      AMD Ryzen APU
# RAM:      16GB
# Storage:  512GB SSD (NVMe)
# Desktop:  Gnome
#
#################################

HOSTNAME="archlinux"
USERNAME="mrs"
FULLNAME="MoritzRS"
PASSWORD="changeme"
ROOT_PASSWORD="changeme"


########## Setup Preparation ##########
loadkeys de-latin1;
timedatectl set-ntp true;
reflector \
    --latest 5 \
    --sort rate \
    --country Austria,France,Germany,Switzerland \
    --save /etc/pacman.d/mirrorlist;
pacman -Syy --needed --noconfirm git wget unzip;


########## Partitioning ##########
pacman -S --needed --noconfirm parted;

parted /dev/nvme0n1 -- mklabel gpt;
parted /dev/nvme0n1 -- mkpart ESP fat32 1MB 512MB;
parted /dev/nvme0n1 -- mkpart primary 512MB -20GB;
parted /dev/nvme0n1 -- mkpart primary linux-swap -20GB 100%;
parted /dev/nvme0n1 -- set 1 esp on;


########## Formatting ###########
mkfs.fat -F 32 -n boot /dev/nvme0n1p1;
mkfs.ext4 -L root /dev/nvme0n1p2;
mkswap -L swap /dev/nvme0n1p3;


########## Mounting #############
mount /dev/disk/by-label/root /mnt;
mkdir -p /mnt/{efi,home};
mount /dev/disk/by-label/boot /mnt/efi;
swapon /dev/disk/by-label/swap;


########## Base Install ##########
pacstrap /mnt base base-devel linux linux-firmware;
genfstab -U /mnt >> /mnt/etc/fstab;


########## Time Setup ##########
arch-chroot /mnt ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime;
arch-chroot /mnt hwclock --systohc;


########## Locale Setup ##########
echo "en_US.UTF-8 UTF-8" >> /mnt/etc/locale.gen;
echo "de_DE.UTF-8 UTF-8" >> /mnt/etc/locale.gen;
arch-chroot /mnt locale-gen;

echo "LANG=de_DE.UTF-8" >> /mnt/etc/locale.conf;
echo "KEYMAP=de-latin1" >> /mnt/etc/vconsole.conf;


########## Host Setup ##########
echo "$HOSTNAME" > /mnt/etc/hostname;
cat <<EOF > /mnt/etc/hosts
127.0.0.1    localhost
::1          localhost
127.0.1.1    $HOSTNAME.localdomain    $HOSTNAME
EOF


########## Bootloader Setup ##########
arch-chroot /mnt pacman -S --needed --noconfirm grub efibootmgr dosfstools os-prober mtools;
arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB;
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg;

git clone --depth=1 https://github.com/catppuccin/grub.git;
cp -r grub/src/* /mnt/usr/share/grub/themes/ && rm -rf grub;
sed -i 's|^#GRUB_THEME=.*|GRUB_THEME="/usr/share/grub/themes/catppuccin-mocha-grub-theme/theme.txt"|' /mnt/etc/default/grub;
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg;


########## Services ##########
arch-chroot /mnt pacman -S --needed --noconfirm networkmanager dhcpcd acpid;
arch-chroot /mnt systemctl enable NetworkManager;
arch-chroot /mnt systemctl enable dhcpcd;
arch-chroot /mnt systemctl enable acpid;
arch-chroot /mnt systemctl enable fstrim.timer;


########## Keyring ##########
arch-chroot /mnt pacman -S --needed --noconfirm libsecret gnome-keyring;
echo "password	optional	pam_gnome_keyring.so" >> /mnt/etc/pam.d/passwd;


########## Fonts ##########
arch-chroot /mnt pacman -S --needed --noconfirm \
    noto-fonts \
    noto-fonts-cjk \
    noto-fonts-emoji \
    noto-fonts-extra;

arch-chroot /mnt pacman -S --needed --noconfirm \
    ttf-nerd-fonts-symbols \
    ttf-nerd-fonts-symbols-mono \
    ttf-hack-nerd \
    ttf-jetbrains-mono-nerd \
    ttf-meslo-nerd;


########## ZSH Shell ##########
arch-chroot /mnt pacman -S --needed --noconfirm \
    zsh \
    zsh-syntax-highlighting \
    zsh-autosuggestions \
    starship;


########## Sudo ##########
arch-chroot /mnt pacman -S --needed --noconfirm sudo;
echo "%wheel ALL=(ALL) ALL" > /mnt/etc/sudoers.d/10-installer;


########## Root Login #########
arch-chroot /mnt bash -c "echo -e \"$ROOT_PASSWORD\n$ROOT_PASSWORD\" | passwd";


########## Standard User ##########
arch-chroot /mnt useradd -m -g users -G wheel -c "$FULLNAME" -s /bin/zsh $USERNAME;
arch-chroot /mnt bash -c "echo -e \"$PASSWORD\n$PASSWORD\" | passwd $USERNAME";
arch-chroot -u $USERNAME /mnt mkdir -p /home/$USERNAME/Developer;


########## Standard Utilities ##########
arch-chroot /mnt pacman -S --needed --noconfirm \
    git \
    curl wget \
    nano \
    neovim neovide luarocks \
    podman;


########## Gnome Desktop ##########
arch-chroot /mnt pacman -S --needed --noconfirm \
    gnome-shell gdm \
    gnome-backgrounds \
    gnome-control-center \
    gnome-disk-utility \
    gnome-remote-desktop \
    gnome-software flatpak \
    gnome-system-monitor \
    gnome-tweaks \
    gnome-user-share \
    ghostty \
    gst-plugin-pipewire gst-plugins-good \
    nautilus sushi gvfs-goa gvfs-mtp \
    xdg-user-dirs-gtk xdg-desktop-portal-gnome;
arch-chroot /mnt systemctl enable gdm;


########## AMD APU ##########
arch-chroot /mnt pacman -S --needed --noconfirm \
    amd-ucode \
    vulkan-icd-loader \
    mesa vulkan-radeon;


########## Finish ##########
shutdown now;