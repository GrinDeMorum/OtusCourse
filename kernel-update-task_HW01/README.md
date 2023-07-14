1) Обновить ядро ОС из репозитория ELRepo

#Создаем vagrant файл по образцу из инструкции, но меняем некоторые параметры под себя
nano Vagrantgile

MACHINES = {
  # Указываем имя ВМ "kernel update"
  :"kernel-update" => {
              #Указываем актуальный vagrant box для ванильной centos8
              :box_name => "generic/centos8",
              #Добавим немного больше мощностей ибо можем
              :cpus => 4, 
              :memory => 2048,
            }
}

Vagrant.configure("2") do |config|
  MACHINES.each do |boxname, boxconfig|
    config.vm.synced_folder ".", "/vagrant", disabled: true
    config.vm.define boxname do |box|
      box.vm.box = boxconfig[:box_name]
      box.vm.box_version = boxconfig[:box_version]
      box.vm.host_name = boxname.to_s
      box.vm.provider "virtualbox" do |v|
        v.memory = boxconfig[:memory]
        v.cpus = boxconfig[:cpus]
      end
    end
  end
end


#Запускаем VM
vagrant up

Bringing machine 'kernel-update' up with 'virtualbox' provider...
==> kernel-update: Importing base box 'generic/centos8'...
==> kernel-update: Matching MAC address for NAT networking...
==> kernel-update: Checking if box 'generic/centos8' version '4.2.16' is up to date...
==> kernel-update: Setting the name of the VM: kernel-update-task_data_kernel-update_1689316882727_89059
==> kernel-update: Clearing any previously set network interfaces...
==> kernel-update: Preparing network interfaces based on configuration...
    kernel-update: Adapter 1: nat
==> kernel-update: Forwarding ports...
    kernel-update: 22 (guest) => 2222 (host) (adapter 1)
==> kernel-update: Running 'pre-boot' VM customizations...
==> kernel-update: Booting VM...
==> kernel-update: Waiting for machine to boot. This may take a few minutes...
    kernel-update: SSH address: 127.0.0.1:2222
    kernel-update: SSH username: vagrant
    kernel-update: SSH auth method: private key
    kernel-update:
    kernel-update: Vagrant insecure key detected. Vagrant will automatically replace
    kernel-update: this with a newly generated keypair for better security.
    kernel-update:
    kernel-update: Inserting generated public key within guest...
    kernel-update: Removing insecure key from the guest if it's present...
    kernel-update: Key inserted! Disconnecting and reconnecting using new SSH key...
==> kernel-update: Machine booted and ready!
==> kernel-update: Checking for guest additions in VM...
    kernel-update: The guest additions on this VM do not match the installed version of
    kernel-update: VirtualBox! In most cases this is fine, but in rare cases it can
    kernel-update: prevent things such as shared folders from working properly. If you see
    kernel-update: shared folder errors, please make sure the guest additions within the
    kernel-update: virtual machine match the version of VirtualBox you have installed on
    kernel-update: your host and reload your VM.
    kernel-update:
    kernel-update: Guest Additions Version: 6.1.30
    kernel-update: VirtualBox Version: 7.0
==> kernel-update: Setting hostname...

#Подключаемся к свежесозданной VM и проверяем версию ядра
Vagrant SSH

[vagrant@kernel-update ~]$ uname -r
4.18.0-348.7.1.el8_5.x86_64

#Добавляем новый репозиторий и устанавливаем новое ядро

[vagrant@kernel-update ~]$ sudo yum install -y https://www.elrepo.org/elrepo-release-8.el8.elrepo.noarch.rpm
CentOS Linux 8 - AppStream                                                                                                                                                       3.0 MB/s | 8.4 MB     00:02
CentOS Linux 8 - BaseOS                                                                                                                                                          2.2 MB/s | 4.6 MB     00:02
CentOS Linux 8 - Extras                                                                                                                                                          7.4 kB/s |  10 kB     00:01
Extra Packages for Enterprise Linux 8 - x86_64                                                                                                                                   2.5 MB/s |  16 MB     00:06
elrepo-release-8.el8.elrepo.noarch.rpm                                                                                                                                           7.9 kB/s |  13 kB     00:01
Dependencies resolved.
=================================================================================================================================================================================================================
 Package                                             Architecture                                Version                                                 Repository                                         Size
=================================================================================================================================================================================================================
Installing:
 elrepo-release                                      noarch                                      8.3-1.el8.elrepo                                        @commandline                                       13 k

Transaction Summary
=================================================================================================================================================================================================================
Install  1 Package

Total size: 13 k
Installed size: 5.0 k
Downloading Packages:
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                                                                                                                         1/1
  Installing       : elrepo-release-8.3-1.el8.elrepo.noarch                                                                                                                                                  1/1
  Verifying        : elrepo-release-8.3-1.el8.elrepo.noarch                                                                                                                                                  1/1

Installed:
  elrepo-release-8.3-1.el8.elrepo.noarch

Complete!
[vagrant@kernel-update ~]$ sudo yum --enablerepo elrepo-kernel install kernel-ml -y
ELRepo.org Community Enterprise Linux Repository - el8                                                                                                                            80 kB/s | 238 kB     00:02
ELRepo.org Community Enterprise Linux Kernel Repository - el8                                                                                                                    792 kB/s | 2.7 MB     00:03
Dependencies resolved.
=================================================================================================================================================================================================================
 Package                                               Architecture                               Version                                                Repository                                         Size
=================================================================================================================================================================================================================
Installing:
 kernel-ml                                             x86_64                                     6.4.3-1.el8.elrepo                                     elrepo-kernel                                     112 k
Installing dependencies:
 kernel-ml-core                                        x86_64                                     6.4.3-1.el8.elrepo                                     elrepo-kernel                                      38 M
 kernel-ml-modules                                     x86_64                                     6.4.3-1.el8.elrepo                                     elrepo-kernel                                      34 M

Transaction Summary
=================================================================================================================================================================================================================
Install  3 Packages

Total download size: 71 M
Installed size: 112 M
Downloading Packages:
(1/3): kernel-ml-6.4.3-1.el8.elrepo.x86_64.rpm                                                                                                                                   108 kB/s | 112 kB     00:01
(2/3): kernel-ml-modules-6.4.3-1.el8.elrepo.x86_64.rpm                                                                                                                           4.3 MB/s |  34 MB     00:07
(3/3): kernel-ml-core-6.4.3-1.el8.elrepo.x86_64.rpm                                                                                                                              1.7 MB/s |  38 MB     00:21
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                                                                                            3.2 MB/s |  71 MB     00:22
ELRepo.org Community Enterprise Linux Kernel Repository - el8                                                                                                                    1.6 MB/s | 1.7 kB     00:00
Importing GPG key 0xBAADAE52:
 Userid     : "elrepo.org (RPM Signing Key for elrepo.org) <secure@elrepo.org>"
 Fingerprint: 96C0 104F 6315 4731 1E0B B1AE 309B C305 BAAD AE52
 From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-elrepo.org
Key imported successfully
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                                                                                                                         1/1
  Installing       : kernel-ml-core-6.4.3-1.el8.elrepo.x86_64                                                                                                                                                1/3
  Running scriptlet: kernel-ml-core-6.4.3-1.el8.elrepo.x86_64                                                                                                                                                1/3
  Installing       : kernel-ml-modules-6.4.3-1.el8.elrepo.x86_64                                                                                                                                             2/3
  Running scriptlet: kernel-ml-modules-6.4.3-1.el8.elrepo.x86_64                                                                                                                                             2/3
  Installing       : kernel-ml-6.4.3-1.el8.elrepo.x86_64                                                                                                                                                     3/3
  Running scriptlet: kernel-ml-core-6.4.3-1.el8.elrepo.x86_64                                                                                                                                                3/3
  Running scriptlet: kernel-ml-6.4.3-1.el8.elrepo.x86_64                                                                                                                                                     3/3
  Verifying        : kernel-ml-6.4.3-1.el8.elrepo.x86_64                                                                                                                                                     1/3
  Verifying        : kernel-ml-core-6.4.3-1.el8.elrepo.x86_64                                                                                                                                                2/3
  Verifying        : kernel-ml-modules-6.4.3-1.el8.elrepo.x86_64                                                                                                                                             3/3

Installed:
  kernel-ml-6.4.3-1.el8.elrepo.x86_64                              kernel-ml-core-6.4.3-1.el8.elrepo.x86_64                              kernel-ml-modules-6.4.3-1.el8.elrepo.x86_64

Complete!
[vagrant@kernel-update ~]$ sudo grub2-mkconfig -o /boot/grub2/grub.cfg
Generating grub configuration file ...
done
[vagrant@kernel-update ~]$ sudo grub2-set-default 0
[vagrant@kernel-update ~]$ sudo reboot
Connection to 127.0.0.1 closed by remote host.

#Проверяем версию ядра
vagrant ssh
Last login: Fri Jul 14 06:42:31 2023 from 10.0.2.2
[vagrant@kernel-update ~]$ uname -r
6.4.3-1.el8.elrepo.x86_64
[vagrant@kernel-update ~]$ exit
logout

2) Создать Vagrant box c помощью Packer


#Создаем директорию для packer, создаем json файл по шаблону и исправляем в нем ошибки

mkdir packer
cd packer
nano centos.json

{"builders": [
    {
      "boot_command": [
        "<tab> inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<enter><wait>"
      ],
      "boot_wait": "10s",
      "disk_size": "10240",
      "export_opts": [
        "--manifest",
        "--vsys",
        "0",
        "--description",
        "{{user `artifact_description`}}",
        "--version",
        "{{user `artifact_version`}}"
      ],
      "guest_os_type": "RedHat_64",
      "http_directory": "http",
	#Меняем на актуальные контрольную сумму и ссылку на ISO образ ванильной системы 
      "iso_checksum": "029ead89f720becd5ee2a8cf9935aad12fda7494d61674710174b4674b357530",
      "iso_url": "http://mirror.yandex.ru/centos/8-stream/isos/x86_64/CentOS-Stream-8-20230710.0-x86_64-boot.iso",
      "name": "{{user `image_name`}}",
      "output_directory": "builds",
	#Задаем в разделе variables переменную password и указываем ее через echo как пароль Sudo, иначе будем ловить ошибку во время выполнения скриптов
      "shutdown_command": "echo '{{user `password`}}' | sudo -S /sbin/halt -h -p",
      "shutdown_timeout": "5m",
      "ssh_password": "vagrant",
      "ssh_port": 22,
      "ssh_pty": true,
      "ssh_timeout": "20m",
      "ssh_username": "vagrant",
      "type": "virtualbox-iso",
      "vboxmanage": [
        [
          "modifyvm",
          "{{.Name}}",
          "--memory",
          "2048"
        ],
        [
          "modifyvm",
          "{{.Name}}",
          "--cpus",
          "4"
        ],
	#Задаем NAT для сетевого адаптера иначе машина не увидит файлы скриптов
        [
          "modifyvm",
          "{{.Name}}",
          "--nat-localhostreachable1",
          "on"
        ]
      ],
      "vm_name": "packer-centos-vm"
    }
  ],
  "post-processors": [
    {
      "compression_level": "7",
      "output": "centos-user-kernel-5-x86_64-Minimal.box",
      "type": "vagrant"
    }
  ],
  "provisioners": [
    {
      "execute_command": "echo '{{user `password`}}' | sudo -S -E bash '{{.Path}}'",
      "expect_disconnect": true,
      "override": {
        "{{user `image_name`}}": {
          "scripts": [
            "scripts/stage-1-kernel-update.sh",
            "scripts/stage-2-clean.sh"
          ]
        }
      },
      "pause_before": "20s",
      "start_retry_timeout": "1m",
      "type": "shell"
    }
  ],
  "variables": {
    "artifact_description": "CentOS Stream 8 with kernel 5.x",
    "artifact_version": "8",
    "image_name": "centos-8",
    "password": "vagrant"
  }
}

#Создаем директорию для файла автоматической конфигурации ОС и сам файл по шаблону
mkdir http
cd http
nano ks.cfg


eula --agreed
lang en_US.UTF-8
keyboard us
timezone UTC+3

network --bootproto=dhcp --device=link --activate
network --hostname=otus-c8

rootpw vagrant
authconfig --enableshadow --passalgo=sha512
user --groups=wheel --name=vagrant --password=vagrant --gecos="vagrant"

selinux --enforcing
	#Исправляем неправильное тире перед disabled
firewall --disabled

firstboot --disable

text
url --url="http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/"

bootloader --location=mbr --append="ipv6.disable=1 crashkernel=auto"

skipx
logging --level=info
zerombr
clearpart --all --initlabel
autopart --type=lvm
reboot


#Создаем директорию для скриптов и сами скрипты stage 1 и stage 2 по шаблону. Первый отвечает за обновление ядра, второй за отчистку системы перед упаковкой
cd ..
mkdir scripts
cd scripts 
nano stage-1-kernel-update.sh


sudo yum install -y https://www.elrepo.org/elrepo-release-8.el8.elrepo.noarch.rpm
yum --enablerepo elrepo-kernel install kernel-ml -y
grub2-mkconfig -o /boot/grub2/grub.cfg
grub2-set-default 0
echo "Grub update done."
shutdown -r now 


nano stage-2-clean.sh


yum update -y
yum clean all

mkdir -pm 700 /home/vagrant/.ssh
curl -sL https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub -o /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh

rm -rf /tmp/*
rm  -f /var/log/wtmp /var/log/btmp
rm -rf /var/cache/* /usr/share/doc/*
rm -rf /var/cache/yum
rm -rf /vagrant/home/*.iso
rm  -f ~/.bash_history
history -c

rm -rf /run/log/journal/*
sync
grub2-set-default 0
echo "###   Hi from second stage" >> /boot/grub2/grub.cfg


#Приступаем к сборке образа, в процессе нужно в GUI создаваемой машины подтвердить начало установки, а в конце выход из нее. Как это автоматизировать я не понял
packer build centos.json
centos-8: output will be in this color.

==> centos-8: Retrieving Guest additions
==> centos-8: Trying /usr/share/virtualbox/VBoxGuestAdditions.iso
==> centos-8: Trying /usr/share/virtualbox/VBoxGuestAdditions.iso
==> centos-8: /usr/share/virtualbox/VBoxGuestAdditions.iso => /usr/share/virtualbox/VBoxGuestAdditions.iso
==> centos-8: Retrieving ISO
==> centos-8: Trying http://mirror.yandex.ru/centos/8-stream/isos/x86_64/CentOS-Stream-8-20230710.0-x86_64-boot.iso
==> centos-8: Trying http://mirror.yandex.ru/centos/8-stream/isos/x86_64/CentOS-Stream-8-20230710.0-x86_64-boot.iso?checksum=sha256%3A029ead89f720becd5ee2a8cf9935aad12fda7494d61674710174b4674b357530
==> centos-8: http://mirror.yandex.ru/centos/8-stream/isos/x86_64/CentOS-Stream-8-20230710.0-x86_64-boot.iso?checksum=sha256%3A029ead89f720becd5ee2a8cf9935aad12fda7494d61674710174b4674b357530 => /home/user/Desktop/Otus_Course/kernel-update-task_data/packer/packer_cache/8698dda002e49bebda5cd955d41fed3b02426c55.iso
==> centos-8: Starting HTTP server on port 8156
==> centos-8: Creating virtual machine...
==> centos-8: Creating hard drive...
==> centos-8: Mounting ISOs...
    centos-8: Mounting boot ISO...
==> centos-8: Creating forwarded port mapping for communicator (SSH, WinRM, etc) (host port 3008)
==> centos-8: Executing custom VBoxManage commands...
    centos-8: Executing: modifyvm packer-centos-vm --memory 2048
    centos-8: Executing: modifyvm packer-centos-vm --cpus 4
    centos-8: Executing: modifyvm packer-centos-vm --nat-localhostreachable1 on
==> centos-8: Starting the virtual machine...
==> centos-8: Waiting 10s for boot...
==> centos-8: Typing the boot command...
==> centos-8: Using ssh communicator to connect: 127.0.0.1
==> centos-8: Waiting for SSH to become available...
==> centos-8: Connected to SSH!
==> centos-8: Uploading VirtualBox version info (7.0.8)
==> centos-8: Uploading VirtualBox guest additions ISO...
==> centos-8: Pausing 20s before the next provisioner...
==> centos-8: Provisioning with shell script: scripts/stage-1-kernel-update.sh
    centos-8:
    centos-8: We trust you have received the usual lecture from the local System
    centos-8: Administrator. It usually boils down to these three things:
    centos-8:
    centos-8:     #1) Respect the privacy of others.
    centos-8:     #2) Think before you type.
    centos-8:     #3) With great power comes great responsibility.
    centos-8:
    centos-8: CentOS Stream 8 - AppStream                     600 kB/s |  31 MB     00:52
    centos-8: CentOS Stream 8 - BaseOS                        3.2 MB/s |  41 MB     00:12
    centos-8: CentOS Stream 8 - Extras                         12 kB/s |  18 kB     00:01
    centos-8: CentOS Stream 8 - Extras common packages        761  B/s | 6.6 kB     00:08
    centos-8: elrepo-release-8.el8.elrepo.noarch.rpm          9.7 kB/s |  13 kB     00:01
    centos-8: Dependencies resolved.
    centos-8: ================================================================================
    centos-8:  Package             Arch        Version                Repository         Size
    centos-8: ================================================================================
    centos-8: Installing:
    centos-8:  elrepo-release      noarch      8.3-1.el8.elrepo       @commandline       13 k
    centos-8:
    centos-8: Transaction Summary
    centos-8: ================================================================================
    centos-8: Install  1 Package
    centos-8:
    centos-8: Total size: 13 k
    centos-8: Installed size: 5.0 k
    centos-8: Downloading Packages:
    centos-8: Running transaction check
    centos-8: Transaction check succeeded.
    centos-8: Running transaction test
    centos-8: Transaction test succeeded.
    centos-8: Running transaction
    centos-8:   Preparing        :                                                        1/1
    centos-8:   Installing       : elrepo-release-8.3-1.el8.elrepo.noarch                 1/1
    centos-8:   Verifying        : elrepo-release-8.3-1.el8.elrepo.noarch                 1/1
    centos-8:
    centos-8: Installed:
    centos-8:   elrepo-release-8.3-1.el8.elrepo.noarch
    centos-8:
    centos-8: Complete!
    centos-8: ELRepo.org Community Enterprise Linux Repositor 100 kB/s | 238 kB     00:02
    centos-8: ELRepo.org Community Enterprise Linux Kernel Re 874 kB/s | 2.7 MB     00:03
    centos-8: Dependencies resolved.
    centos-8: ================================================================================
    centos-8:  Package              Arch      Version                  Repository        Size
    centos-8: ================================================================================
    centos-8: Installing:
    centos-8:  kernel-ml            x86_64    6.4.3-1.el8.elrepo       elrepo-kernel    112 k
    centos-8: Installing dependencies:
    centos-8:  kernel-ml-core       x86_64    6.4.3-1.el8.elrepo       elrepo-kernel     38 M
    centos-8:  kernel-ml-modules    x86_64    6.4.3-1.el8.elrepo       elrepo-kernel     34 M
    centos-8:
    centos-8: Transaction Summary
    centos-8: ================================================================================
    centos-8: Install  3 Packages
    centos-8:
    centos-8: Total download size: 71 M
    centos-8: Installed size: 112 M
    centos-8: Downloading Packages:
    centos-8: (1/3): kernel-ml-6.4.3-1.el8.elrepo.x86_64.rpm  121 kB/s | 112 kB     00:00
    centos-8: (2/3): kernel-ml-modules-6.4.3-1.el8.elrepo.x86 2.0 MB/s |  34 MB     00:16
    centos-8: (3/3): kernel-ml-core-6.4.3-1.el8.elrepo.x86_64 1.8 MB/s |  38 MB     00:20
    centos-8: --------------------------------------------------------------------------------
    centos-8: Total                                           3.4 MB/s |  71 MB     00:21
    centos-8: ELRepo.org Community Enterprise Linux Kernel Re 1.6 MB/s | 1.7 kB     00:00
    centos-8: Importing GPG key 0xBAADAE52:
    centos-8:  Userid     : "elrepo.org (RPM Signing Key for elrepo.org) <secure@elrepo.org>"
    centos-8:  Fingerprint: 96C0 104F 6315 4731 1E0B B1AE 309B C305 BAAD AE52
    centos-8:  From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-elrepo.org
    centos-8: Key imported successfully
    centos-8: Running transaction check
    centos-8: Transaction check succeeded.
    centos-8: Running transaction test
    centos-8: Transaction test succeeded.
    centos-8: Running transaction
    centos-8:   Preparing        :                                                        1/1
    centos-8:   Installing       : kernel-ml-core-6.4.3-1.el8.elrepo.x86_64               1/3
    centos-8:   Running scriptlet: kernel-ml-core-6.4.3-1.el8.elrepo.x86_64               1/3
    centos-8: /usr/sbin/ldconfig: /usr/lib64/llvm15/lib/libclang.so.15 is not a symbolic link
    centos-8:
    centos-8:
    centos-8:   Installing       : kernel-ml-modules-6.4.3-1.el8.elrepo.x86_64            2/3
    centos-8:   Running scriptlet: kernel-ml-modules-6.4.3-1.el8.elrepo.x86_64            2/3
    centos-8:   Installing       : kernel-ml-6.4.3-1.el8.elrepo.x86_64                    3/3
    centos-8:   Running scriptlet: kernel-ml-core-6.4.3-1.el8.elrepo.x86_64               3/3
    centos-8:   Running scriptlet: kernel-ml-6.4.3-1.el8.elrepo.x86_64                    3/3
    centos-8: /sbin/ldconfig: /usr/lib64/llvm15/lib/libclang.so.15 is not a symbolic link
    centos-8:
    centos-8:
    centos-8:   Verifying        : kernel-ml-6.4.3-1.el8.elrepo.x86_64                    1/3
    centos-8:   Verifying        : kernel-ml-core-6.4.3-1.el8.elrepo.x86_64               2/3
    centos-8:   Verifying        : kernel-ml-modules-6.4.3-1.el8.elrepo.x86_64            3/3
    centos-8:
    centos-8: Installed:
    centos-8:   kernel-ml-6.4.3-1.el8.elrepo.x86_64
    centos-8:   kernel-ml-core-6.4.3-1.el8.elrepo.x86_64
    centos-8:   kernel-ml-modules-6.4.3-1.el8.elrepo.x86_64
    centos-8:
    centos-8: Complete!
    centos-8: Generating grub configuration file ...
    centos-8: done
    centos-8: Grub update done.
==> centos-8: Provisioning with shell script: scripts/stage-2-clean.sh
    centos-8: [sudo] password for vagrant: Last metadata expiration check: 0:01:26 ago on Fri 14 Jul 2023 03:51:21 AM EDT.
    centos-8: Dependencies resolved.
    centos-8: Nothing to do.
    centos-8: Complete!
    centos-8: 39 files removed
==> centos-8: Gracefully halting virtual machine...
    centos-8: [sudo] password for vagrant:
==> centos-8: Preparing to export machine...
    centos-8: Deleting forwarded port mapping for the communicator (SSH, WinRM, etc) (host port 3008)
==> centos-8: Exporting virtual machine...
    centos-8: Executing: export packer-centos-vm --output builds/packer-centos-vm.ovf --manifest --vsys 0 --description CentOS Stream 8 with kernel 5.x --version 8
==> centos-8: Cleaning up floppy disk...
==> centos-8: Deregistering and deleting VM...
==> centos-8: Running post-processor: vagrant
==> centos-8 (vagrant): Creating a dummy Vagrant box to ensure the host system can create one correctly
==> centos-8 (vagrant): Creating Vagrant box for 'virtualbox' provider
    centos-8 (vagrant): Copying from artifact: builds/packer-centos-vm-disk001.vmdk
    centos-8 (vagrant): Copying from artifact: builds/packer-centos-vm.mf
    centos-8 (vagrant): Copying from artifact: builds/packer-centos-vm.ovf
    centos-8 (vagrant): Renaming the OVF to box.ovf...
    centos-8 (vagrant): Compressing: Vagrantfile
    centos-8 (vagrant): Compressing: box.ovf
    centos-8 (vagrant): Compressing: metadata.json
    centos-8 (vagrant): Compressing: packer-centos-vm-disk001.vmdk
    centos-8 (vagrant): Compressing: packer-centos-vm.mf
Build 'centos-8' finished after 22 minutes 42 seconds.

==> Wait completed after 22 minutes 42 seconds

==> Builds finished. The artifacts of successful builds are:
--> centos-8: 'virtualbox' provider box: centos-user-kernel-5-x86_64-Minimal.box

#После создания образа, его рекомендуется проверить. Для проверки  импортируем полученный vagrant box в Vagrant: 
vagrant box add centos-user-kernel-5-x86_64-Minimal.box --name centos_elrepo_kernel

==> box: Box file was not detected as metadata. Adding it directly...
==> box: Adding box 'centos_elrepo_kernel' (v0) for provider:
    box: Unpacking necessary files from: file:///home/user/Desktop/Otus_Course/kernel-update-task_data/packer/centos-user-kernel-5-x86_64-Minimal.box
==> box: Successfully added box 'centos_elrepo_kernel' (v0) for 'virtualbox'!

#Создадим Vagrantfile на основе нашего образа: 
vagrant init centos_elrepo_kernel
A `Vagrantfile` has been placed in this directory. You are now
ready to `vagrant up` your first virtual environment! Please read
the comments in the Vagrantfile as well as documentation on
`vagrantup.com` for more information on using Vagrant.

#Развернем машину из нашего образа и проверем что версия ядра новая
vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Importing base box 'centos_elrepo_kernel'...
==> default: Matching MAC address for NAT networking...
==> default: Setting the name of the VM: packer_default_1689322614888_6224
==> default: Clearing any previously set network interfaces...
==> default: Preparing network interfaces based on configuration...
    default: Adapter 1: nat
==> default: Forwarding ports...
    default: 22 (guest) => 2222 (host) (adapter 1)
==> default: Booting VM...
==> default: Waiting for machine to boot. This may take a few minutes...
    default: SSH address: 127.0.0.1:2222
    default: SSH username: vagrant
    default: SSH auth method: private key
    default:
    default: Vagrant insecure key detected. Vagrant will automatically replace
    default: this with a newly generated keypair for better security.
    default:
    default: Inserting generated public key within guest...
    default: Removing insecure key from the guest if it's present...
    default: Key inserted! Disconnecting and reconnecting using new SSH key...
==> default: Machine booted and ready!
==> default: Checking for guest additions in VM...
    default: No guest additions were detected on the base box for this VM! Guest
    default: additions are required for forwarded ports, shared folders, host only
    default: networking, and more. If SSH fails on this machine, please install
    default: the guest additions and repackage the box to continue.
    default:
    default: This is not an error message; everything may continue to work properly,
    default: in which case you may ignore this message.
==> default: Mounting shared folders...
    default: /vagrant => /home/user/Desktop/Otus_Course/kernel-update-task_data/packer
#vagrant сообщает нам что деплой прошел с ошибками, однако по факту все работает корректно
The following SSH command responded with a non-zero exit status.
Vagrant assumes that this means the command failed!
mkdir -p /vagrant
Stdout from the command:
Stderr from the command:

vagrant ssh
Activate the web console with: systemctl enable --now cockpit.socket

Last login: Fri Jul 14 03:52:49 2023 from 10.0.2.2
[vagrant@otus-c8 ~]$ uname -r
6.4.3-1.el8.elrepo.x86_64

3) Загрузить Vagrant box в Vagrant Cloud

Все дальнейшие действия полностью соответствуют мануалу, не вижу смысла их расписывать.
Мой vagrant box доступен в vagrant cloud под названием  grindevald9992/centos8-kernel6.4.3-1.el8.elrepo
