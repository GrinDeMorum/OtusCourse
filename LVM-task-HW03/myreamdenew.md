pvcreate /dev/sdb
  Physical volume "/dev/sdb" successfully created.
[root@otuslinux vagrant]# vgcreate vg_root /dev/sdb
  Volume group "vg_root" successfully created
[root@otuslinux vagrant]# lvcreate -l +100%FREE -n lv_root /dev/vg_root
  Logical volume "lv_root" created.
[root@otuslinux vagrant]# mkfs.xfs /dev/vg_root/lv_root
meta-data=/dev/vg_root/lv_root   isize=512    agcount=4, agsize=786176 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=0, sparse=0
data     =                       bsize=4096   blocks=3144704, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
[root@otuslinux vagrant]# script /home/vagrant/readme.txt
Script started, file is /home/vagrant/readme.txt
[root@otuslinux vagrant]# whoami
root
[root@otuslinux vagrant]# exit
exit
Script done, file is /home/vagrant/readme.txt
[root@otuslinux vagrant]# clear
[root@otuslinux vagrant]# cat /vagrant/myreadme2.txt
[root@otuslinux vagrant]# cat /vagrant/myreadme.txt
cat: /vagrant/myreadme.txt: No such file or directory
[root@otuslinux vagrant]# cat /vagrant/myreadme.md
pvcreate /dev/sdb
  WARNING: Running as a non-root user. Functionality may be unavailable.
  /run/lvm/lvmetad.socket: access failed: Permission denied
  WARNING: Failed to connect to lvmetad. Falling back to device scanning.
  /run/lock/lvm/P_orphans:aux: open failed: Permission denied
  Can't get lock for orphan PVs.
[vagrant@otuslinux ~]$ sudo su
[root@otuslinux vagrant]# script /vagrant/myreadme.md
Script started, file is /vagrant/myreadme.md
[root@otuslinux vagrant]# pvcreate /dev/sdb
  Physical volume "/dev/sdb" successfully created.
[root@otuslinux vagrant]# vgcreate vg_root /dev/sdb
  Volume group "vg_root" successfully created
[root@otuslinux vagrant]# lvcreate -l +100%FREE -n lv_root /dev/vg_root
  Logical volume "lv_root" created.
[root@otuslinux vagrant]# mkfs.xfs /dev/vg_root/lv_root
meta-data=/dev/vg_root/lv_root   isize=512    agcount=4, agsize=786176 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=0, sparse=0
data     =                       bsize=4096   blocks=3144704, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
[root@otuslinux vagrant]# script /vagrant/myreadme2.txt
Script started, file is /vagrant/myreadme2.txt
[root@otuslinux vagrant]# mkdir /mnt/temp_root
[root@otuslinux vagrant]# mount /dev/vg_root/lv_root /mnt/temp_root
[root@otuslinux vagrant]# xfsdump -J - /dev/VolGroup00/LogVol00 | xfsrestore -J - /mnt/temp_root
xfsdump: using file dump (drive_simple) strategy
xfsdump: version 3.1.7 (dump format 3.0)
xfsdump: level 0 dump of otuslinux:/
xfsdump: dump date: Thu Aug 10 07:46:21 2023
xfsdump: session id: 2e0f54e0-e546-4a48-bfc2-42e190a91b2e
xfsdump: session label: ""
xfsrestore: using file dump (drive_simple) strategy
xfsrestore: version 3.1.7 (dump format 3.0)
xfsrestore: searching media for dump
xfsdump: ino map phase 1: constructing initial dump list
xfsdump: ino map phase 2: skipping (no pruning necessary)
xfsdump: ino map phase 3: skipping (only one dump stream)
xfsdump: ino map construction complete
xfsdump: estimated dump size: 10551713920 bytes
xfsdump: creating dump session media file 0 (media 0, file 0)
xfsdump: dumping ino map
xfsdump: dumping directories
xfsrestore: examining media file 0
xfsrestore: dump description:
xfsrestore: hostname: otuslinux
xfsrestore: mount point: /
xfsrestore: volume: /dev/mapper/VolGroup00-LogVol00
xfsrestore: session time: Thu Aug 10 07:46:21 2023
xfsrestore: level: 0
xfsrestore: session label: ""
xfsrestore: media label: ""
xfsrestore: file system id: b60e9498-0baa-4d9f-90aa-069048217fee
xfsrestore: session id: 2e0f54e0-e546-4a48-bfc2-42e190a91b2e
xfsrestore: media id: 1f3b126f-d9b6-4aeb-b62b-c8ad25e2ee5e
xfsrestore: searching media for directory dump
xfsrestore: reading directories
xfsdump: dumping non-directory files
xfsrestore: 2808 directories and 23962 entries processed
xfsrestore: directory post-processing
xfsrestore: restoring non-directory files
xfsdump: ending media file
xfsdump: media file size 10530850840 bytes
xfsdump: dump size (non-dir files) : 10517290632 bytes
xfsdump: dump complete: 36 seconds elapsed
xfsdump: Dump Status: SUCCESS
xfsrestore: restore complete: 36 seconds elapsed
xfsrestore: Restore Status: SUCCESS
[root@otuslinux vagrant]# ls /mnt/temp_root/
bin  boot  data-snap  dev  etc  home  lib  lib64  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  vagrant  var
[root@otuslinux vagrant]# for i in /proc/ /sys/ /dev/ /run/ /boot/; do mount --bind $i /mnt/temp_root/$i; done
[root@otuslinux vagrant]# chroot /mnt/temp_root/
[root@otuslinux /]# grub2-mkconfig -o /boot/grub2/grub.cfg
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-3.10.0-862.2.3.el7.x86_64
Found initrd image: /boot/initramfs-3.10.0-862.2.3.el7.x86_64.img
done
[root@otuslinux /]# cd /boot ; for i in `ls initramfs-*img`; do dracut -v $i `echo $i|sed "s/initramfs-//g;
> s/.img//g"` --force; done
Executing: /sbin/dracut -v initramfs-3.10.0-862.2.3.el7.x86_64.img 3.10.0-862.2.3.el7.x86_64 --force
dracut module 'busybox' will not be installed, because command 'busybox' could not be found!
dracut module 'crypt' will not be installed, because command 'cryptsetup' could not be found!
dracut module 'dmraid' will not be installed, because command 'dmraid' could not be found!
dracut module 'dmsquash-live-ntfs' will not be installed, because command 'ntfs-3g' could not be found!
dracut module 'multipath' will not be installed, because command 'multipath' could not be found!
dracut module 'busybox' will not be installed, because command 'busybox' could not be found!
dracut module 'crypt' will not be installed, because command 'cryptsetup' could not be found!
dracut module 'dmraid' will not be installed, because command 'dmraid' could not be found!
dracut module 'dmsquash-live-ntfs' will not be installed, because command 'ntfs-3g' could not be found!
dracut module 'multipath' will not be installed, because command 'multipath' could not be found!
*** Including module: bash ***
*** Including module: nss-softokn ***
*** Including module: i18n ***
*** Including module: drm ***
*** Including module: plymouth ***
*** Including module: dm ***
Skipping udev rule: 64-device-mapper.rules
Skipping udev rule: 60-persistent-storage-dm.rules
Skipping udev rule: 55-dm.rules
*** Including module: kernel-modules ***
Omitting driver floppy
*** Including module: lvm ***
Skipping udev rule: 64-device-mapper.rules
Skipping udev rule: 56-lvm.rules
Skipping udev rule: 60-persistent-storage-lvm.rules
*** Including module: qemu ***
*** Including module: resume ***
*** Including module: rootfs-block ***
*** Including module: terminfo ***
*** Including module: udev-rules ***
Skipping udev rule: 40-redhat-cpu-hotplug.rules
Skipping udev rule: 91-permissions.rules
*** Including module: biosdevname ***
*** Including module: systemd ***
*** Including module: usrmount ***
*** Including module: base ***
*** Including module: fs-lib ***
*** Including module: shutdown ***
*** Including modules done ***
*** Installing kernel module dependencies and firmware ***
*** Installing kernel module dependencies and firmware done ***
*** Resolving executable dependencies ***
*** Resolving executable dependencies done***
*** Hardlinking files ***
*** Hardlinking files done ***
*** Stripping files ***
*** Stripping files done ***
*** Generating early-microcode cpio image contents ***
*** Constructing AuthenticAMD.bin ****
*** No early-microcode cpio image needed ***
*** Store current command line parameters ***
*** Creating image file ***
*** Creating image file done ***
*** Creating initramfs image file '/boot/initramfs-3.10.0-862.2.3.el7.x86_64.img' done ***
[root@otuslinux boot]# sed -i 's/"rd.lvm.lv=VolGroup00/LogVol00"/"rd.lvm.lv=vg_root/lv_root"/g' /boot/grub2/grub.cfg
sed: -e expression #1, char 35: unknown option to `s'
[root@otuslinux boot]# sed -i 's+rd.lvm.lv=VolGroup00/LogVol00+rd.lvm.lv=vg_root/lv_root+g' /boot/grub2/grub.cfg
[root@otuslinux boot]# exit
[root@otuslinux ~]# echo "`blkid | grep var: | awk '{print $2}'` /var btrfs defaults 0 0" >> /etc/fstab
[root@otuslinux ~]# reboot
sudo su
[root@otuslinux vagrant]# vgs
  VG         #PV #LV #SN Attr   VSize   VFree
  VolGroup00   1   2   0 wz--n- <38.97g <25.47g
  vg_root      1   1   0 wz--n- <12.00g      0
  vg_var       2   1   0 wz--n-   1.99g 128.00m
[root@otuslinux vagrant]# lvs
  LV       VG         Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  LogVol00 VolGroup00 -wi-ao----  12.00g
  LogVol01 VolGroup00 -wi-ao----   1.50g
  lv_root  vg_root    -wi-a----- <12.00g
  lv_var   vg_var     rwi-aor--- 952.00m                                    100.00
[root@otuslinux vagrant]# lvremove /dev/vg_root/lv_root
Do you really want to remove active logical volume vg_root/lv_root? [y/n]: y
  Logical volume "lv_root" successfully removed
[root@otuslinux vagrant]# vgremove /dev/vg_root
  Volume group "vg_root" successfully removed
[root@otuslinux vagrant]# pvremove /dev/sdb
  Labels on physical volume "/dev/sdb" successfully wiped.
[root@otuslinux home]# lvcreate -n LogVol_Home -L 10G /dev/VolGroup00
  Logical volume "LogVol_Home" created.
[root@otuslinux vagrant]# mkfs.xfs /dev/VolGroup00/LogVol_Home
meta-data=/dev/VolGroup00/LogVol_Home isize=512    agcount=4, agsize=655360 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=0, sparse=0
data     =                       bsize=4096   blocks=2621440, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
[root@otuslinux vagrant]# mount /dev/VolGroup00/LogVol_Home /mnt/
[root@otuslinux vagrant]# cp -aR /home/* /mnt/
[root@otuslinux vagrant]# rm -rf /home/*
[root@otuslinux vagrant]# umount /mnt
[root@otuslinux vagrant]# mount /dev/VolGroup00/LogVol_Home /home/
[root@otuslinux vagrant]# echo "`blkid | grep Home | awk '{print $2}'` /home xfs defaults 0 0" >> /etc/fstab
[root@otuslinux vagrant]# touch /home/file{1..20}
[root@otuslinux vagrant]# cd /home/
[root@otuslinux home]# ls
file1  file10  file11  file12  file13  file14  file15  file16  file17  file18  file19  file2  file20  file3  file4  file5  file6  file7  file8  file9  vagrant
[root@otuslinux home]# lvcreate -L 1G -s -n home_snap /dev/VolGroup00/LogVol_Home
  Logical volume "home_snap" created.
[root@otuslinux home]# rm -f /home/file{11..20}
[vagrant@otuslinux /]$ sudo lvconvert --merge /dev/VolGroup00/home_snap
  Delaying merge since origin is open.
  Merging of snapshot VolGroup00/home_snap will occur on next activation of VolGroup00/LogVol_Home.
[vagrant@otuslinux /]$ ls /home
file1  file10  file2  file3  file4  file5  file6  file7  file8  file9  vagrant
[vagrant@otuslinux /]$ sudo reboot
[vagrant@otuslinux ~]$ sudo su
[root@otuslinux vagrant]# ls /home
file1  file10  file11  file12  file13  file14  file15  file16  file17  file18  file19  file2  file20  file3  file4  file5  file6  file7  file8  file9  vagrant
[root@otuslinux vagrant]# lvs
  LV          VG         Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  LogVol00    VolGroup00 -wi-ao----  12.00g
  LogVol01    VolGroup00 -wi-ao----   1.50g
  LogVol_Home VolGroup00 -wi-ao----  10.00g
  lv_root     vg_root    -wi-a----- <12.00g
  lv_var      vg_var     rwi-aor--- 952.00m                                    100.00
[root@otuslinux vagrant]# flblk
bash: flblk: command not found
[root@otuslinux vagrant]# lsblk
NAME                       MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                          8:0    0   40G  0 disk
├─sda1                       8:1    0    1M  0 part
├─sda2                       8:2    0    1G  0 part /boot
└─sda3                       8:3    0   39G  0 part
  ├─VolGroup00-LogVol00    253:0    0   12G  0 lvm  /
  ├─VolGroup00-LogVol01    253:1    0  1.5G  0 lvm  [SWAP]
  └─VolGroup00-LogVol_Home 253:5    0   10G  0 lvm  /home
sdb                          8:16   0   12G  0 disk
└─vg_root-lv_root          253:2    0   12G  0 lvm
sdc                          8:32   0    5G  0 disk
sdd                          8:48   0    2G  0 disk
sde                          8:64   0    1G  0 disk
├─vg_var-lv_var_rmeta_0    253:7    0    4M  0 lvm
│ └─vg_var-lv_var          253:11   0  952M  0 lvm  /var
└─vg_var-lv_var_rimage_0   253:8    0  952M  0 lvm
  └─vg_var-lv_var          253:11   0  952M  0 lvm  /var
sdf                          8:80   0    1G  0 disk
├─vg_var-lv_var_rmeta_1    253:9    0    4M  0 lvm
│ └─vg_var-lv_var          253:11   0  952M  0 lvm  /var
└─vg_var-lv_var_rimage_1   253:10   0  952M  0 lvm
  └─vg_var-lv_var          253:11   0  952M  0 lvm  /var

