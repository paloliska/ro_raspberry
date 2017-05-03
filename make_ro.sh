#!/bin/sh
dphys-swapfile swapoff
dphys-swapfile uninstall
update-rc.d dphys-swapfile disable
systemctl disable systemd-readahead-collect
systemctl disable systemd-random-seed

apt-get -y install busybox-syslogd -force-yes
dpkg --purge rsyslog
apt-get -y install unionfs-fuse -force-yes

cp mount_unionfs /usr/local/bin/mount_unionfs
chmod +x /usr/local/bin/mount_unionfs

cp /boot/cmdline.txt /boot/cmdline.txt.bck
echo -n " ro" >> /boot/cmdline.txt

cp /etc/fstab /etc/fstab.bck
cp fstab.new /etc/fstab

cp -al /etc /etc_org
mv /var /var_org
mkdir /etc_rw
mkdir /var /var_rw

chmod +x /home/pi/rw.sh
reboot
