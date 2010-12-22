#!/bin/busybox sh

rescue_shell() {
    echo "Something went wrong. Dropping you to a shell."
    busybox --install -s
    exec /bin/sh
}

echo "Starting initramfs init script with busybox..."

# Mount the /proc and /sys filesystems.
mount -t proc none /proc || rescue_shell
mount -t sysfs none /sys || rescue_shell
echo "Mounted /proc and /sys"

# Mount the root filesystem.
mount -t ext3 /dev/mmcblk0p1 /mnt/root || sleep 1
mount -t ext3 /dev/mmcblk0p1 /mnt/root || sleep 1
mount -t ext3 /dev/mmcblk0p1 /mnt/root || sleep 1

# Clean up.
umount /proc || rescue_shell
umount /sys || rescue_shell

# Boot the real thing.
exec switch_root -c /dev/console /mnt/root /sbin/init
