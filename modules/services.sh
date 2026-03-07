#!/usr/bin/env bash

set -euo pipefail

# Identify the original non-root user when invoked via sudo
USER_NAME="${SUDO_USER:-$(whoami)}"

# Ensure root
if [[ $EUID -ne 0 ]]; then
  echo "Run this script as root."
  exit 1
fi

echo "Updating package database..."
pacman -Syu --noconfirm

# ---------------------------------------------------
# CPU GOVERNOR
# ---------------------------------------------------
echo "Setting CPU governor to performance..."
if command -v cpupower >/dev/null 2>&1; then
  systemctl enable --now cpupower.service || true
  cpupower frequency-set -g performance || true
else
  echo "cpupower not installed; skipping CPU governor setup."
fi

# ---------------------------------------------------
# SYSCTL TUNING
# ---------------------------------------------------
echo "Applying kernel memory tuning..."

SYSCTL_FILE="/etc/sysctl.d/99-performance.conf"

cat > "$SYSCTL_FILE" <<EOF
vm.swappiness=10
vm.vfs_cache_pressure=50
vm.dirty_ratio=10
vm.dirty_background_ratio=5
EOF

sysctl --system || true

# ---------------------------------------------------
# ZRAM CONFIG
# ---------------------------------------------------
echo "Configuring zram-generator..."

ZRAM_CONF="/etc/systemd/zram-generator.conf"
mkdir -p /etc/systemd
cat > "$ZRAM_CONF" <<EOF
[zram0]
zram-size = ram / 2
compression-algorithm = zstd
EOF

# ---------------------------------------------------
# I/O SCHEDULER SETUP
# ---------------------------------------------------
echo
echo "Available block devices:"
lsblk -d -o NAME,SIZE,ROTA,TYPE | column -t

echo
read -rp "Enter the device to optimize (example: nvme0n1 or sda): " DEVICE
DEVICE_PATH="/sys/block/$DEVICE/queue/scheduler"

if [[ ! -e "$DEVICE_PATH" ]]; then
  echo "Device not found: $DEVICE_PATH"
  exit 1
fi

# Choose a sensible default based on device name
if [[ "$DEVICE" == nvme* ]]; then
  DEFAULT_SCHED="none"
elif [[ "$DEVICE" == sd* ]]; then
  DEFAULT_SCHED="mq-deadline"
else
  DEFAULT_SCHED="deadline"
fi

echo "Available schedulers: $(cat "$DEVICE_PATH")"
read -rp "Choose scheduler [default: $DEFAULT_SCHED]: " SCHED
SCHED="${SCHED:-$DEFAULT_SCHED}"

# Validate chosen scheduler
if ! grep -q "$SCHED" "$DEVICE_PATH"; then
  echo "Scheduler '$SCHED' not available for $DEVICE. Aborting."
  exit 1
fi

echo "$SCHED" > "$DEVICE_PATH" || true

# Persist scheduler using udev rule
echo "Creating persistent scheduler rule..."
cat > /etc/udev/rules.d/60-ioscheduler.rules <<EOF
ACTION=="add|change", KERNEL=="$DEVICE", ATTR{queue/scheduler}="$SCHED"
EOF
udevadm control --reload-rules || true

# ---------------------------------------------------
# DISABLE UNUSED SERVICES
# ---------------------------------------------------
echo "Disabling common unnecessary services..."

SERVICES=(bluetooth.service cups.service ModemManager.service)

for svc in "${SERVICES[@]}"; do
  if systemctl list-unit-files --type=service | grep -q "^$svc"; then
    systemctl disable --now "$svc" 2>/dev/null || true
  fi
done

# ---------------------------------------------------
# FILESYSTEM TWEAK (NOATIME)
# ---------------------------------------------------
echo "Applying noatime mount optimization..."
cp /etc/fstab /etc/fstab.backup
if grep -q "relatime" /etc/fstab; then
  sed -i 's/relatime/noatime/g' /etc/fstab
  echo "Updated /etc/fstab (backup at /etc/fstab.backup)."
else
  echo "/etc/fstab did not contain 'relatime'; no changes made."
fi

# ---------------------------------------------------
# NVIDIA PERSISTENCE MODE (if NVIDIA detected)
# ---------------------------------------------------
if command -v nvidia-smi >/dev/null 2>&1; then
  echo "Enabling NVIDIA persistence mode..."
  nvidia-smi -pm 1 || true
fi

# ---------------------------------------------------
# LIBVIRT SETUP
# ---------------------------------------------------
if command -v systemctl >/dev/null 2>&1; then
  echo "Enabling libvirtd service..."
  systemctl enable --now libvirtd || true
  echo "Adding $USER_NAME to libvirt and kvm groups..."
  usermod -aG libvirt "$USER_NAME" || true
  usermod -aG kvm "$USER_NAME" || true
  if command -v virsh >/dev/null 2>&1; then
    virsh net-start default 2>/dev/null || true
    virsh net-autostart default || true
  fi
fi

# ---------------------------------------------------
# DONE
# ---------------------------------------------------
echo
echo "==== Optimization Complete ===="
echo "Recommended reboot."
echo
echo "Summary:"
echo "- CPU governor: configured (if cpupower present)"
echo "- ZRAM: configured at $ZRAM_CONF"
echo "- Sysctl memory tuning applied at $SYSCTL_FILE"
echo "- I/O scheduler configured for $DEVICE (set to $SCHED)"
echo "- Unnecessary services disabled where present"
echo "- noatime mount optimization applied when applicable"
echo "- NVIDIA persistence enabled if NVIDIA present"
echo
echo "Please logout and login again for group changes to take effect for user: $USER_NAME"
