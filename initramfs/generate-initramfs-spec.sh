# Script to create list of files and device nodes to be included in initramfs #
#
# There's only one reason that this script is better than maintaining the
# list directly-- when updating to a new version of busybox, the list of
# symbolic links can be created using "ls -1" on the hierarchy created by
# the "make install" of busybox.

INITRAMFS_SOURCE_DIR=initramfs
exec > rascal-initramfs-spec.txt

# Create device nodes
echo "dir /dev 755 0 0"
echo "nod /dev/console 644 0 0 c 5 1"
echo "nod /dev/loop0 644 0 0 b 7 0"
echo "nod /dev/mmcblk0 644 0 0 b 179 0"
echo "nod /dev/mmcblk0p1 644 0 0 b 179 1"
echo "nod /dev/mmcblk0p2 644 0 0 b 179 2"
echo "nod /dev/mmcblk0p3 644 0 0 b 179 3"
echo "nod /dev/mmcblk0p4 644 0 0 b 179 4"

# Create directories for binaries
echo "dir /bin 755 0 0"
echo "dir /sbin 755 0 0"
echo "dir /usr 755 0 0"
echo "dir /usr/bin 755 0 0"
echo "dir /usr/sbin 755 0 0"

# Add Busybox
echo "slink /bin/sh busybox 777 0 0"
echo "file /bin/busybox $INITRAMFS_SOURCE_DIR/bin/busybox 755 0 0"

# Create other directories
echo "dir /proc 755 0 0"
echo "dir /sys 755 0 0"
echo "dir /mnt 755 0 0"
echo "dir /mnt/root 755 0 0"
echo "dir /lib 755 0 0"
echo "dir /lib/modules 755 0 0"
echo "file /init $INITRAMFS_SOURCE_DIR/init.sh 755 0 0"

# Create symlinks to make Busybox easier to use
for a in addgroup adduser ash cat catv chattr chgrp chmod chown cp cpio cttyhack date dd delgroup deluser df dmesg dnsdomainname dumpkmap echo ed egrep false fdflush fgrep fsync getopt grep gunzip gzip hostname hush ionice ip ipaddr ipcalc iplink iproute iprule iptunnel kill linux32 linux64 ln login ls lsattr lzop makemime mkdir mknod mktemp more mount mountpoint mt mv netstat nice pidof ping ping6 pipe_progress printenv ps pwd reformime rev rm rmdir rpm run-parts scriptreplay sed setarch sh sleep stat stty su sync tar touch true umount uname usleep vi watch zcat ; do echo "slink /bin/$a /bin/busybox 0755 0 0"; done

for b in acpid adjtimex arp blkid bootchartd depmod devmem fbsplash fdisk findfs freeramdisk fsck fsck.minix getty halt hdparm hwclock ifconfig ifdown ifenslave ifup init insmod klogd loadkmap logread losetup lsmod makedevs man mdev mkdosfs mke2fs mkfs.ext2 mkfs.minix mkfs.vfat mkswap modinfo modprobe nameif pivot_root poweroff raidautorun reboot rmmod route runlevel setconsole slattach start-stop-daemon sulogin swapoff swapon switch_root sysctl syslogd tunctl udhcpc vconfig watchdog zcip ; do echo "slink /sbin/$b /bin/busybox 0755 0 0"; done

for c in [ [[ arping awk basename beep bunzip2 bzcat bzip2 cal chat chpst chrt chvt cksum clear cmp comm crontab cryptpw cut dc deallocvt diff dirname dos2unix du dumpleases eject env envdir envuidgid ether-wake expand expr fdformat fgconsole find flock fold free ftpget ftpput fuser hd head hexdump hostid id ifplugd install ipcrm ipcs kbd_mode killall killall5 last length less logger logname lpq lpr lspci lsusb lzcat lzma lzopcat md5sum mesg microcom mkfifo mkpasswd nc nmeter nohup nslookup od openvt passwd patch pgrep pkill printf pscan readahead readlink realpath renice reset resize rpm2cpio rtcwake runsv runsvdir rx script seq setkeycodes setsid setuidgid sha1sum sha256sum sha512sum showkey smemcap softlimit sort split strings sum sv tac tail tcpsvd tee telnet test tftp tftpd time timeout top tr traceroute traceroute6 tty ttysize udpsvd unexpand uniq unix2dos unlzma unlzop unxz unzip uptime uudecode uuencode vlock volname wall wc wget which who whoami xargs xz xzcat yes ; do echo "slink /usr/bin/$c /bin/busybox 0755 0 0"; done

for d in brctl chpasswd chroot crond dhcprelay dnsd fakeidentd fbset ftpd httpd inetd loadfont lpd ntpd popmaildir rdate rdev readprofile sendmail setfont setlogcons svlogd telnetd udhcpd ; do echo "slink /usr/sbin/$d /bin/busybox 0755 0 0"; done
