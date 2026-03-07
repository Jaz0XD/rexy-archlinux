#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/zen0x/rex-os/main/install.sh)"
#!/bin/bash
set -e

export TERM=xterm

read -rp "EFI disk: " EFIDISK
read -rp "Root partition: " ROOTPART
read -rp "Second disk: " SECONDDISK
read -rp "Hostname: " HOSTNAME
read -rp "Username: " USERNAME
read -rp "Timezone (e.g. Asia/Kolkata): " TIMEZONE

while true; do
  read -rsp "Root password: " ROOT_PASS
  echo
  read -rsp "Confirm root password: " ROOT_PASS_CONFIRM
  echo
  [ "$ROOT_PASS" = "$ROOT_PASS_CONFIRM" ] && break
  echo "Passwords do not match. Try again."
done

while true; do
  read -rsp "Password for user $USERNAME: " USER_PASS
  echo
  read -rsp "Confirm password for user $USERNAME: " USER_PASS_CONFIRM
  echo
  [ "$USER_PASS" = "$USER_PASS_CONFIRM" ] && break
  echo "Passwords do not match. Try again."
done

mkfs.fat -F32 "${EFIDISK}p1"

mkfs.btrfs -f -L archpool "$ROOTPART"
mount "$ROOTPART" /mnt

btrfs device add -f "$SECONDDISK" /mnt

btrfs subvolume create /mnt/@root
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@snapshots
btrfs subvolume create /mnt/@var
btrfs subvolume create /mnt/@log

umount /mnt

mount -o subvol=@root,compress=zstd,noatime LABEL=archpool /mnt
mkdir -p /mnt/{home,.snapshots,var,boot}
mount -o subvol=@home,compress=zstd,noatime LABEL=archpool /mnt/home
mount -o subvol=@snapshots,compress=zstd,noatime LABEL=archpool /mnt/.snapshots
mount -o subvol=@var,compress=zstd,noatime LABEL=archpool /mnt/var
mount "${EFIDISK}p1" /mnt/boot

pacstrap -K /mnt base linux-zen linux-zen-headers linux-firmware btrfs-progs networkmanager sudo

genfstab -U /mnt > /mnt/etc/fstab

UUID=$(blkid -s UUID -o value /dev/disk/by-label/archpool)

arch-chroot /mnt /bin/bash <<EOF
ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
hwclock --systohc

sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

echo "$HOSTNAME" > /etc/hostname

useradd -m -G wheel $USERNAME

echo "root:$ROOT_PASS" | chpasswd
echo "$USERNAME:$USER_PASS" | chpasswd

sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

bootctl install

cat > /boot/loader/entries/arch.conf <<BOOT
title Arch BTW
linux /vmlinuz-linux-zen
initrd /initramfs-linux-zen.img
options root=UUID=$UUID rootflags=subvol=@root rw
BOOT

cat > /boot/loader/loader.conf <<LOADER
default arch
timeout 3
LOADER

echo "KEYMAP=us" > /etc/vconsole.conf

systemctl enable NetworkManager

su - $USERNAME -c "
cd /home/$USERNAME
git clone https://github.com/zen0x00/dotfiles.git
"

mkinitcpio -P
EOF

echo "Installation complete. Reboot when ready."
