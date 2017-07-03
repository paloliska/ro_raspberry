#!/bin/sh
dphys-swapfile swapoff
dphys-swapfile uninstall
update-rc.d dphys-swapfile disable
systemctl disable systemd-readahead-collect
systemctl disable systemd-random-seed

apt-get -y install busybox-syslogd --force-yes
dpkg --purge rsyslog
apt-get -y install unionfs-fuse --force-yes

PKG_OK=$(dpkg-query -W --showformat='${Status}\n' busybox-syslogd|grep "install ok installed")
echo Checking for busybox-syslogd: $PKG_OK
if [ "" == "$PKG_OK" ]; then
  echo "No busybox-syslogd. Exiting."
  echo "FAILED, PROCEED MANUALY."
fi

PKG_OK=$(dpkg-query -W --showformat='${Status}\n' unionfs-fuse|grep "install ok installed")
echo Checking for unionfs-fuse: $PKG_OK
if [ "" == "$PKG_OK" ]; then
  echo "No unionfs-fuse. Exiting."
  echo "FAILED, PROCEED MANUALY."
fi

cp mount_unionfs /usr/local/bin/mount_unionfs
chmod +x /usr/local/bin/mount_unionfs

cp /boot/cmdline.txt /boot/cmdline.txt.bck
sed 's/$/ ro/' /boot/cmdline.txt > /boot/cmdline.txt

cp /etc/fstab /etc/fstab.bck
cp fstab.new /etc/fstab

cp -al /etc /etc_org
mv /var /var_org
mkdir /etc_rw
mkdir /var /var_rw

chmod +x /home/pi/rw.sh

echo "Check your /etc/fstab (compare with backup /etc/fstab.bck)!"
echo "Check your /boot/cmdline.txt, should be same like cmdline.txt.bck, with ro added at the end!"
echo "After check reboot."

#reboot
