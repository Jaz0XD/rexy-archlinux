#!/bin/bash
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/zen0x/rex-os/main/install.sh)"
set -e

export TERM=xterm

read -rp "EFI disk (e.g. /dev/nvme0n1): " EFIDISK
read -rp "Root disk (e.g. /dev/nvme0n1p2): " ROOTPART
read -rp "Second disk (e.g. /dev/nvme1n1): " SECONDDISK
read -rp "Hostname: " HOSTNAME
read -rp "Username: " USERNAME
read -rp "Timezone (e.g. Asia/Kolkata): " TIMEZONE

mkfs.fat -F32 "${EFIDISK}p1"

mkfs.btrfs -f -L archpool "$ROOTPART"
mount "$ROOTPART" /mnt

btrfs device add "$SECONDDISK" /mnt

btrfs subvolume create /mnt/@root
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@snapshots
btrfs subvolume create /mnt/@var
btrfs subvolume create /mnt/@log

umount /mnt

mount -o subvol=@root,compress=zstd,noatime LABEL=archpool /mnt
mkdir -p /mnt/{home,.snapshots,var,var/log,boot}
mount -o subvol=@home,compress=zstd,noatime LABEL=archpool /mnt/home
mount -o subvol=@snapshots,compress=zstd,noatime LABEL=archpool /mnt/.snapshots
mount -o subvol=@var,compress=zstd,noatime LABEL=archpool /mnt/var
mkdir -p /mnt/var/log
mount -o subvol=@log,compress=zstd,noatime LABEL=archpool /mnt/var/log
mount "${EFIDISK}p1" /mnt/boot

pacstrap -K /mnt base linux-zen linux-zen-headers linux-firmware btrfs-progs networkmanager

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt /bin/bash <<EOF
ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
hwclock --systohc

sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

echo "$HOSTNAME" > /etc/hostname

useradd -m -G wheel $USERNAME
passwd $USERNAME
passwd

sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

bootctl install

UUID=$(blkid -s UUID -o value "$ROOTPART")

cat > /boot/loader/entries/arch-zen.conf <<BOOT
title Arch Linux (Zen)
linux /vmlinuz-linux-zen
initrd /initramfs-linux-zen.img
options root=UUID=$UUID rootflags=subvol=@root rw
BOOT

cat > /boot/loader/loader.conf <<LOADER
default arch-zen
timeout 3
LOADER

systemctl enable NetworkManager

echo "KEYMAP=us" > /etc/vconsole.conf

mkinitcpio -P
EOF

echo "Installation complete. You can reboot now."
