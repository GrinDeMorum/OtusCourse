#!/bin/bash

#install zfs repo
          yum install -y http://download.zfsonlinux.org/epel/zfs-release.el7_8.noarch.rpm
          #import gpg key 
          rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-zfsonlinux
          #install DKMS style packages for correct work ZFS
          yum install -y epel-release kernel-devel zfs
          #change ZFS repo
          yum-config-manager --disable zfs
          yum-config-manager --enable zfs-kmod
          yum install -y zfs
          #Add kernel module zfs
          modprobe zfs
          #install wget
          yum install -y wget

#configure zfs pools, downloading files to pools
       zpool create otus1 /dev/sdb /dev/sdc
       zpool create otus2 /dev/sdd /dev/sde
       zpool create otus3 /dev/sdf /dev/sdg
       zpool create otus4 /dev/sdh /dev/sdi
       zpool create otus5 /dev/sdj /dev/sdk

       zfs set compression=lzjb otus1
       zfs set compression=lz4 otus2
       zfs set compression=gzip-9 otus3
       zfs set compression=zle otus4
       zfs set compression=gzip-6 otus5

       for i in {1..5};
              do wget -P /otus$i https://gutenberg.org/cache/epub/2600/pg2600.converter.log;
       done
       
#import new pool
wget -O archive.tar.gz --no-check-certificate 'https://drive.google.com/u/0/uc?id=1KRBNW33QWqbvbVHa3hLJivOAt60yukkg&export=download'
--2023-10-09 13:13:47--  https://drive.google.com/u/0/uc?id=1KRBNW33QWqbvbVHa3hLJivOAt60yukkg&export=download

tar -xzvf archive.tar.gz

zpool import -d zpoolexport/ otus

#import snpashot
wget -O otus_task2.file --no-check-certificate "https://drive.google.com/u/0/uc?id=1gH8gCL9y7Nd5Ti3IRmplZPF1XjzxeRAG&export=download"

zfs receive otus/test@today < otus_task2.file