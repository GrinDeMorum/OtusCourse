#Уменьшить том под / до 8G

**Подготовим временнýй том длā / раздела:**

[root@otuslinux vagrant]# pvcreate /dev/sdb
  Physical volume "/dev/sdb" successfully created.

[root@otuslinux vagrant]# vgcreate vg_root /dev/sdb
  Volume group "vg_root" successfully created

[root@otuslinux vagrant]# lvcreate -l +100%FREE -n lv_root /dev/vg_root
  Logical volume "lv_root" created.

**Создадим на нем файловую систему и смонтируем его, чтобы перенести туда данные:**

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

[root@otuslinux vagrant]# mkdir /mnt/temp_root

[root@otuslinux vagrant]# mount /dev/vg_root/lv_root /mnt/temp_root

**Этой командой скопируем все данные с / раздела в /mnt:**

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

**Затем переконфигурируем grub длā того, чтобý при старте перейти в новýй /
Сýмитируем текущий root -> сделаем в него chroot и обновим grub:**

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

**Ну и длā того, чтобý при загрузке бýл смонтирован нужнý root нужно в файле
/boot/grub2/grub.cfg заменитþ rd.lvm.lv=VolGroup00/LogVol00 на rd.lvm.lv=vg_root/lv_root**

[root@otuslinux boot]# sed -i 's+rd.lvm.lv=VolGroup00/LogVol00+rd.lvm.lv=vg_root/lv_root+g' /boot/grub2/grub.cfg
[root@otuslinux boot]# exit

**Перезагружаемся успешно с новым рут томом**

[vagrant@otuslinux ~]$ lsblk
NAME                    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                       8:0    0   40G  0 disk
├─sda1                    8:1    0    1M  0 part
├─sda2                    8:2    0    1G  0 part /boot
└─sda3                    8:3    0   39G  0 part
  ├─VolGroup00-LogVol01 253:1    0  1.5G  0 lvm  [SWAP]
  └─VolGroup00-LogVol00 253:2    0 37.5G  0 lvm
sdb                       8:16   0   18G  0 disk
└─vg_root-lv_root       253:0    0   18G  0 lvm  /
sdc                       8:32   0    2G  0 disk
sdd                       8:48   0    1G  0 disk
sde                       8:64   0    1G  0 disk

**Теперь нам нужно изменить размер старой VG и вернуть на него рут. Длā этого удаляем
старый LV размеров в 40G и создаем новый на 18G:**

[vagrant@otuslinux ~]$ sudo su
[root@otuslinux vagrant]# lvremove /dev/VolGroup00/LogVol00
Do you really want to remove active logical volume VolGroup00/LogVol00? [y/n]: y
  Logical volume "LogVol00" successfully removed

[root@otuslinux vagrant]# lvcreate -n VolGroup00/LogVol00 -L 18G /dev/VolGroup00
WARNING: xfs signature detected on /dev/VolGroup00/LogVol00 at offset 0. Wipe it? [y/n]: y
  Wiping xfs signature on /dev/VolGroup00/LogVol00.
  Logical volume "LogVol00" created.

**Проделываем на нем те же операции, что и в первый раз:**

[root@otuslinux vagrant]# mkfs.xfs /dev/VolGroup00/LogVol00
meta-data=/dev/VolGroup00/LogVol00 isize=512    agcount=4, agsize=1179648 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=0, sparse=0
data     =                       bsize=4096   blocks=4718592, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

[root@otuslinux vagrant]# mount /dev/VolGroup00/LogVol00 /mnt/temp_root/

[root@otuslinux vagrant]# xfsdump -J - /dev/vg_root/lv_root | xfsrestore -J - /mnt/temp_root/
xfsrestore: using file dump (drive_simple) strategy
xfsrestore: version 3.1.7 (dump format 3.0)
xfsdump: using file dump (drive_simple) strategy
xfsdump: version 3.1.7 (dump format 3.0)
xfsdump: level 0 dump of otuslinux:/
xfsdump: dump date: Fri Aug 11 04:14:50 2023
xfsdump: session id: 8a824745-bbf7-4659-ae2d-b7a9bca4fb8e
xfsdump: session label: ""
xfsrestore: searching media for dump
xfsdump: ino map phase 1: constructing initial dump list
xfsdump: ino map phase 2: skipping (no pruning necessary)
xfsdump: ino map phase 3: skipping (only one dump stream)
xfsdump: ino map construction complete
xfsdump: estimated dump size: 18062917696 bytes
xfsdump: creating dump session media file 0 (media 0, file 0)
xfsdump: dumping ino map
xfsdump: dumping directories
xfsrestore: examining media file 0
xfsrestore: dump description:
xfsrestore: hostname: otuslinux
xfsrestore: mount point: /
xfsrestore: volume: /dev/mapper/vg_root-lv_root
xfsrestore: session time: Fri Aug 11 04:14:50 2023
xfsrestore: level: 0
xfsrestore: session label: ""
xfsrestore: media label: ""
xfsrestore: file system id: 61485ce9-1c7f-4f7a-940d-c3d8cf85cf16
xfsrestore: session id: 8a824745-bbf7-4659-ae2d-b7a9bca4fb8e
xfsrestore: media id: f9afe873-913e-44ee-9013-918661e0d8f3
xfsrestore: searching media for directory dump
xfsrestore: reading directories
xfsdump: dumping non-directory files
xfsrestore: 2760 directories and 23821 entries processed
xfsrestore: directory post-processing
xfsrestore: restoring non-directory files
xfsdump: ending media file
xfsdump: media file size 18041385328 bytes
xfsdump: dump size (non-dir files) : 18027787744 bytes
xfsdump: dump complete: 45 seconds elapsed
xfsdump: Dump Status: SUCCESS
xfsrestore: restore complete: 45 seconds elapsed
xfsrestore: Restore Status: SUCCESS


**Так же как в первýй раз переконфигурируем grub, за исклĀчением правки /etc/grub2/grub.cfg**

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

**Пока не перезагружаемся и не выходим из под chroot - мы можем заодно перенести /var**

#Выделить том под /var в зеркало

**На свободнýх дисках создаем зеркало:**

[root@otuslinux boot]# pvcreate /dev/sdd /dev/sde
  Physical volume "/dev/sdd" successfully created.
  Physical volume "/dev/sde" successfully created.

[root@otuslinux boot]# vgcreate vg_var /dev/sdd /dev/sde
  Volume group "vg_var" successfully created

[root@otuslinux boot]# lvcreate -L 950M -m1 -n lv_var vg_var
  Rounding up size to full physical extent 952.00 MiB
  Logical volume "lv_var" created.

**Создаем на нем ФС и перемещаем туда /var:**

[root@otuslinux boot]# mkfs.btrfs /dev/vg_var/lv_var
btrfs-progs v4.9.1
See http://btrfs.wiki.kernel.org for more information.

Label:              (null)
UUID:               1f5e104b-458d-4fcc-8af3-eaced5f7b2bf
Node size:          16384
Sector size:        4096
Filesystem size:    952.00MiB
Block group profiles:
  Data:             single            8.00MiB
  Metadata:         DUP              47.56MiB
  System:           DUP               8.00MiB
SSD detected:       no
Incompat features:  extref, skinny-metadata
Number of devices:  1
Devices:
   ID        SIZE  PATH
    1   952.00MiB  /dev/vg_var/lv_var

[root@otuslinux boot]# mkdir /mnt/temp_var && mount /dev/vg_var/lv_var /mnt/temp_var

[root@otuslinux boot]# cp -aR /var/* /mnt/temp_var/ # rsync -avHPSAX /var/ /mnt/temp_var/

**На всякий случай сохраняем содержимое старого var (или же можно его просто удалить):**

[root@otuslinux boot]# mkdir /tmp/oldvar && mv /var/* /tmp/oldvar

**Ну и монтируем новýй var в каталог /var:**

[root@otuslinux boot]# umount /mnt/temp_v
umount: /mnt/temp_v: mountpoint not found

[root@otuslinux boot]# umount /mnt/temp_var/

[root@otuslinux boot]# mount /dev/vg_var/lv_var /var

**Правим fstab длā автоматического монтированиā /var:**

[root@otuslinux boot]# echo "`blkid | grep var: | awk '{print $2}'` /var btrfs defaults 0 0" >> /etc/fstab

**После чего можно успешно перезагружатþсā в новýй (уменþшеннýй root) и удалāтþ
временнуĀ Volume Group:**

Last login: Fri Aug 11 04:11:43 2023 from 10.0.2.2
[vagrant@otuslinux ~]$ sudo su
[root@otuslinux vagrant]# df -h

Filesystem                       Size  Used Avail Use% Mounted on
/dev/mapper/VolGroup00-LogVol00   18G   17G  1.2G  94% /
devtmpfs                         488M     0  488M   0% /dev
tmpfs                            496M     0  496M   0% /dev/shm
tmpfs                            496M  6.7M  490M   2% /run
tmpfs                            496M     0  496M   0% /sys/fs/cgroup
/dev/sda2                       1014M   61M  954M   6% /boot
/dev/mapper/vg_var-lv_var        952M  254M  607M  30% /var
[root@otuslinux vagrant]# lvremove /dev/vg_root/lv_root
Do you really want to remove active logical volume vg_root/lv_root? [y/n]: y
  Logical volume "lv_root" successfully removed

[root@otuslinux vagrant]# vgremove /dev/vg_root
  Volume group "vg_root" successfully removed

[root@otuslinux vagrant]# pvremove /dev/sdb
  Labels on physical volume "/dev/sdb" successfully wiped.

#Выделить том под /home

**Вýделāем том под /home по тому же принципу что делали длā /var:**

[root@otuslinux vagrant]# lvcreate -n LogVol_Home -L 5G /dev/VolGroup00
  Logical volume "LogVol_Home" created.
[root@otuslinux vagrant]# mkfs.xfs /dev/VolGroup00/LogVol_Home
meta-data=/dev/VolGroup00/LogVol_Home isize=512    agcount=4, agsize=327680 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=0, sparse=0
data     =                       bsize=4096   blocks=1310720, imaxpct=25
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

**Правим fstab длā автоматического монтированиā /home**

[root@otuslinux vagrant]# echo "`blkid | grep Home | awk '{print $2}'` /home xfs defaults 0 0" >> /etc/fstab

**Сгенерируем файлý в /home/:**

[root@otuslinux vagrant]# touch /home/file{1..20}

**Снāтþ снапшот:**

[root@otuslinux vagrant]# lvcreate -L 1G -s -n home_snap /dev/VolGroup00/LogVol_Home
  Logical volume "home_snap" created.

**Удалитþ частþ файлов:**

rm -f /home/file{11..20}

**Процесс восстановлениā со снапшота:**

[root@otuslinux vagrant]# umount /home

[root@otuslinux vagrant]# lvconvert --merge /dev/VolGroup00/home_snap
  Merging of volume VolGroup00/home_snap started.
  VolGroup00/LogVol_Home: Merged: 100.00%

[root@otuslinux vagrant]# mount /home

[root@otuslinux vagrant]# ls /home
file1  file10  file11  file12  file13  file14  file15  file16  file17  file18  file19  file2  file20  file3  file4  file5  file6  file7  file8  file9  vagrant
