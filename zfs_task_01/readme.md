# Определить алгоритм с наилучшим сжатием

Создаем вм-ку используя Vagrantfile из манула к ДЗ (+ я добавил еще 2 диска), заходим на нее по ssh и выводим список блочных устройств:
```
[vagrant@zfs ~]$ lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda      8:0    0   40G  0 disk 
`-sda1   8:1    0   40G  0 part /
sdb      8:16   0  512M  0 disk 
sdc      8:32   0  512M  0 disk 
sdd      8:48   0  512M  0 disk 
sde      8:64   0  512M  0 disk 
sdf      8:80   0  512M  0 disk 
sdg      8:96   0  512M  0 disk 
sdh      8:112  0  512M  0 disk 
sdi      8:128  0  512M  0 disk 
sdj      8:144  0  512M  0 disk 
sdk      8:160  0  512M  0 disk 
```


Создаем 5 пулов типа raid 0 (ради разнообразия), затем включаем для каждого разный тип компрессии. Для проверки эффективности компрессии скачиваем файл по ссылке из инструкции, после чего смотрим где компрессия была эффективней.
Упаковал это все для удобства в скриптик
```
#!/bin/bash

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

 zfs list
 zfs get all | grep compressratio | grep -v ref

```

Выполняем :
```
[vagrant@zfs ~]$ sudo -i
[root@zfs ~]# cd /vagrant/
[root@zfs vagrant]# chmod +x create_zpool.sh 
[root@zfs vagrant]# ./create_zpool.sh
```
Вывод:
```
--2023-10-09 13:06:47--  https://gutenberg.org/cache/epub/2600/pg2600.converter.log
Resolving gutenberg.org (gutenberg.org)... 152.19.134.47, 2610:28:3090:3000:0:bad:cafe:47
Connecting to gutenberg.org (gutenberg.org)|152.19.134.47|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 40979797 (39M) [text/plain]
Saving to: '/otus1/pg2600.converter.log'

100%[===================================================================================================================================>] 40,979,797  4.70MB/s   in 10s    

2023-10-09 13:06:58 (3.89 MB/s) - '/otus1/pg2600.converter.log' saved [40979797/40979797]

--2023-10-09 13:06:58--  https://gutenberg.org/cache/epub/2600/pg2600.converter.log
Resolving gutenberg.org (gutenberg.org)... 152.19.134.47, 2610:28:3090:3000:0:bad:cafe:47
Connecting to gutenberg.org (gutenberg.org)|152.19.134.47|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 40979797 (39M) [text/plain]
Saving to: '/otus2/pg2600.converter.log'

100%[===================================================================================================================================>] 40,979,797  5.24MB/s   in 9.2s   

2023-10-09 13:07:09 (4.26 MB/s) - '/otus2/pg2600.converter.log' saved [40979797/40979797]

--2023-10-09 13:07:09--  https://gutenberg.org/cache/epub/2600/pg2600.converter.log
Resolving gutenberg.org (gutenberg.org)... 152.19.134.47, 2610:28:3090:3000:0:bad:cafe:47
Connecting to gutenberg.org (gutenberg.org)|152.19.134.47|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 40979797 (39M) [text/plain]
Saving to: '/otus3/pg2600.converter.log'

100%[===================================================================================================================================>] 40,979,797  4.51MB/s   in 10s    

2023-10-09 13:07:20 (3.86 MB/s) - '/otus3/pg2600.converter.log' saved [40979797/40979797]

--2023-10-09 13:07:20--  https://gutenberg.org/cache/epub/2600/pg2600.converter.log
Resolving gutenberg.org (gutenberg.org)... 152.19.134.47, 2610:28:3090:3000:0:bad:cafe:47
Connecting to gutenberg.org (gutenberg.org)|152.19.134.47|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 40979797 (39M) [text/plain]
Saving to: '/otus4/pg2600.converter.log'

100%[===================================================================================================================================>] 40,979,797  6.12MB/s   in 8.4s   

2023-10-09 13:07:29 (4.63 MB/s) - '/otus4/pg2600.converter.log' saved [40979797/40979797]

--2023-10-09 13:07:29--  https://gutenberg.org/cache/epub/2600/pg2600.converter.log
Resolving gutenberg.org (gutenberg.org)... 152.19.134.47, 2610:28:3090:3000:0:bad:cafe:47
Connecting to gutenberg.org (gutenberg.org)|152.19.134.47|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 40979797 (39M) [text/plain]
Saving to: '/otus5/pg2600.converter.log'

100%[===================================================================================================================================>] 40,979,797  6.66MB/s   in 7.7s   

2023-10-09 13:07:38 (5.10 MB/s) - '/otus5/pg2600.converter.log' saved [40979797/40979797]

NAME    USED  AVAIL     REFER  MOUNTPOINT
otus1  21.6M   810M     21.6M  /otus1
otus2  17.7M   814M     17.6M  /otus2
otus3  10.8M   821M     10.7M  /otus3
otus4  39.2M   793M     39.1M  /otus4
otus5  10.2M   822M     10.1M  /otus5
otus1  compressratio         1.81x                  -
otus2  compressratio         2.22x                  -
otus3  compressratio         3.65x                  -
otus4  compressratio         1.00x                  -
otus5  compressratio         3.59x                  -
```
Итог: алгоритм gzip-9 самый эффективный

# Определить настройки пула

Скачиваем архив:

```
[root@zfs vagrant]#  wget -O archive.tar.gz --no-check-certificate 'https://drive.google.com/u/0/uc?id=1KRBNW33QWqbvbVHa3hLJivOAt60yukkg&export=download'
--2023-10-09 13:13:47--  https://drive.google.com/u/0/uc?id=1KRBNW33QWqbvbVHa3hLJivOAt60yukkg&export=download

Resolving drive.google.com (drive.google.com)... 173.194.221.194, 2a00:1450:4010:c0a::c2
Connecting to drive.google.com (drive.google.com)|173.194.221.194|:443... connected.
HTTP request sent, awaiting response... 302 Found
Location: https://drive.google.com/uc?id=1KRBNW33QWqbvbVHa3hLJivOAt60yukkg&export=download [following]
--2023-10-09 13:13:48--  https://drive.google.com/uc?id=1KRBNW33QWqbvbVHa3hLJivOAt60yukkg&export=download
Reusing existing connection to drive.google.com:443.
HTTP request sent, awaiting response... ^C
[root@zfs vagrant]# cd --
[root@zfs ~]#  wget -O archive.tar.gz --no-check-certificate 'https://drive.google.com/u/0/uc?id=1KRBNW33QWqbvbVHa3hLJivOAt60yukkg&export=download'
--2023-10-09 13:14:08--  https://drive.google.com/u/0/uc?id=1KRBNW33QWqbvbVHa3hLJivOAt60yukkg&export=download
Resolving drive.google.com (drive.google.com)... 173.194.221.194, 2a00:1450:4010:c0a::c2
Connecting to drive.google.com (drive.google.com)|173.194.221.194|:443... connected.
HTTP request sent, awaiting response... 302 Found
Location: https://drive.google.com/uc?id=1KRBNW33QWqbvbVHa3hLJivOAt60yukkg&export=download [following]
--2023-10-09 13:14:09--  https://drive.google.com/uc?id=1KRBNW33QWqbvbVHa3hLJivOAt60yukkg&export=download
Reusing existing connection to drive.google.com:443.
HTTP request sent, awaiting response... 303 See Other
Location: https://doc-0c-bo-docs.googleusercontent.com/docs/securesc/ha0ro937gcuc7l7deffksulhg5h7mbp1/sl02d07gflvgd7bhkj0a0jpvil9q58v0/1696857225000/16189157874053420687/*/1KRBNW33QWqbvbVHa3hLJivOAt60yukkg?e=download&uuid=4c15f9c6-3b3c-489e-abbe-619764a07b2a [following]
Warning: wildcards not supported in HTTP.
--2023-10-09 13:14:17--  https://doc-0c-bo-docs.googleusercontent.com/docs/securesc/ha0ro937gcuc7l7deffksulhg5h7mbp1/sl02d07gflvgd7bhkj0a0jpvil9q58v0/1696857225000/16189157874053420687/*/1KRBNW33QWqbvbVHa3hLJivOAt60yukkg?e=download&uuid=4c15f9c6-3b3c-489e-abbe-619764a07b2a
Resolving doc-0c-bo-docs.googleusercontent.com (doc-0c-bo-docs.googleusercontent.com)... 142.250.74.65, 2a00:1450:400f:802::2001
Connecting to doc-0c-bo-docs.googleusercontent.com (doc-0c-bo-docs.googleusercontent.com)|142.250.74.65|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 7275140 (6.9M) [application/x-gzip]
Saving to: 'archive.tar.gz'

100%[===================================================================================================================================>] 7,275,140   6.37MB/s   in 1.1s   

2023-10-09 13:14:19 (6.37 MB/s) - 'archive.tar.gz' saved [7275140/7275140]
```

Разархивируем:
```
[root@zfs ~]# tar -xzvf archive.tar.gz
zpoolexport/
zpoolexport/filea
zpoolexport/fileb
```
Импортируем пул в систему:

```
[root@zfs ~]# zpool import -d zpoolexport/
   pool: otus
     id: 6554193320433390805
  state: ONLINE
 action: The pool can be imported using its name or numeric identifier.
 config:

	otus                         ONLINE
	  mirror-0                   ONLINE
	    /root/zpoolexport/filea  ONLINE
	    /root/zpoolexport/fileb  ONLINE
[root@zfs ~]# zpool import -d zpoolexport/ otus
[root@zfs ~]# zpool status otus
  pool: otus
 state: ONLINE
  scan: none requested
config:

	NAME                         STATE     READ WRITE CKSUM
	otus                         ONLINE       0     0     0
	  mirror-0                   ONLINE       0     0     0
	    /root/zpoolexport/filea  ONLINE       0     0     0
	    /root/zpoolexport/fileb  ONLINE       0     0     0

errors: No known data errors
```

Определяем информацию о пуле:

```
[root@zfs ~]# zfs get all otus
NAME  PROPERTY              VALUE                  SOURCE
otus  type                  filesystem             -
otus  creation              Fri May 15  4:00 2020  -
otus  used                  2.04M                  -
otus  available             350M                   -
otus  referenced            24K                    -
otus  compressratio         1.00x                  -
otus  mounted               yes                    -
otus  quota                 none                   default
otus  reservation           none                   default
otus  recordsize            128K                   local
otus  mountpoint            /otus                  default
otus  sharenfs              off                    default
otus  checksum              sha256                 local
otus  compression           zle                    local
otus  atime                 on                     default
otus  devices               on                     default
otus  exec                  on                     default
otus  setuid                on                     default
otus  readonly              off                    default
otus  zoned                 off                    default
otus  snapdir               hidden                 default
otus  aclinherit            restricted             default
otus  createtxg             1                      -
otus  canmount              on                     default
otus  xattr                 on                     default
otus  copies                1                      default
otus  version               5                      -
otus  utf8only              off                    -
otus  normalization         none                   -
otus  casesensitivity       sensitive              -
otus  vscan                 off                    default
otus  nbmand                off                    default
otus  sharesmb              off                    default
otus  refquota              none                   default
otus  refreservation        none                   default
otus  guid                  14592242904030363272   -
otus  primarycache          all                    default
otus  secondarycache        all                    default
otus  usedbysnapshots       0B                     -
otus  usedbydataset         24K                    -
otus  usedbychildren        2.01M                  -
otus  usedbyrefreservation  0B                     -
otus  logbias               latency                default
otus  objsetid              54                     -
otus  dedup                 off                    default
otus  mlslabel              none                   default
otus  sync                  standard               default
otus  dnodesize             legacy                 default
otus  refcompressratio      1.00x                  -
otus  written               24K                    -
otus  logicalused           1020K                  -
otus  logicalreferenced     12K                    -
otus  volmode               default                default
otus  filesystem_limit      none                   default
otus  snapshot_limit        none                   default
otus  filesystem_count      none                   default
otus  snapshot_count        none                   default
otus  snapdev               hidden                 default
otus  acltype               off                    default
otus  context               none                   default
otus  fscontext             none                   default
otus  defcontext            none                   default
otus  rootcontext           none                   default
otus  relatime              off                    default
otus  redundant_metadata    all                    default
otus  overlay               off                    default
otus  encryption            off                    default
otus  keylocation           none                   default
otus  keyformat             none                   default
otus  pbkdf2iters           0                      default
otus  special_small_blocks  0                      default
[root@zfs ~]# zfs get available otus
NAME  PROPERTY   VALUE  SOURCE
otus  available  350M   -
[root@zfs ~]# zfs get readonly otus1
NAME   PROPERTY  VALUE   SOURCE
otus1  readonly  off     default
[root@zfs ~]# zfs get recordsize otus3
NAME   PROPERTY    VALUE    SOURCE
otus3  recordsize  128K     default
[root@zfs ~]# zfs get compression otus5
NAME   PROPERTY     VALUE     SOURCE
otus5  compression  gzip      local
[root@zfs ~]# zfs get checksum otus
NAME  PROPERTY  VALUE      SOURCE
otus  checksum  sha256     local
```
# Работа со снапшотом, поиск сообщения от преподавателя
Скачаем файл, указанный в задании:
```
[root@zfs ~]# wget -O otus_task2.file --no-check-certificate "https://drive.google.com/u/0/uc?id=1gH8gCL9y7Nd5Ti3IRmplZPF1XjzxeRAG&export=download"
```
Вывод:
```
Resolving drive.google.com (drive.google.com)... 173.194.221.194, 2a00:1450:4010:c0a::c2
Connecting to drive.google.com (drive.google.com)|173.194.221.194|:443... connected.
HTTP request sent, awaiting response... 302 Found
Location: https://drive.google.com/uc?id=1gH8gCL9y7Nd5Ti3IRmplZPF1XjzxeRAG&export=download [following]
--2023-10-09 13:24:29--  https://drive.google.com/uc?id=1gH8gCL9y7Nd5Ti3IRmplZPF1XjzxeRAG&export=download
Reusing existing connection to drive.google.com:443.
HTTP request sent, awaiting response... 303 See Other
Location: https://doc-00-bo-docs.googleusercontent.com/docs/securesc/ha0ro937gcuc7l7deffksulhg5h7mbp1/9296e8284nmhn6vtee92gai59osca4h3/1696857825000/16189157874053420687/*/1gH8gCL9y7Nd5Ti3IRmplZPF1XjzxeRAG?e=download&uuid=80e68152-a1ad-4864-a700-3bdd26724f5e [following]
Warning: wildcards not supported in HTTP.
--2023-10-09 13:24:33--  https://doc-00-bo-docs.googleusercontent.com/docs/securesc/ha0ro937gcuc7l7deffksulhg5h7mbp1/9296e8284nmhn6vtee92gai59osca4h3/1696857825000/16189157874053420687/*/1gH8gCL9y7Nd5Ti3IRmplZPF1XjzxeRAG?e=download&uuid=80e68152-a1ad-4864-a700-3bdd26724f5e
Resolving doc-00-bo-docs.googleusercontent.com (doc-00-bo-docs.googleusercontent.com)... 142.250.74.65, 2a00:1450:400f:802::2001
Connecting to doc-00-bo-docs.googleusercontent.com (doc-00-bo-docs.googleusercontent.com)|142.250.74.65|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 5432736 (5.2M) [application/octet-stream]
Saving to: 'otus_task2.file'

100%[===================================================================================================================================>] 5,432,736   5.13MB/s   in 1.0s   

2023-10-09 13:24:36 (5.13 MB/s) - 'otus_task2.file' saved [5432736/5432736]
```

Восстановим файловую систему из снапшота: ```zfs receive otus/test@today < otus_task2.file```
Далее, ищем и смотрим в каталоге /otus/test файл с именем “secret_message”:
```
[root@zfs ~]# find /otus/test -name "secret_message"
/otus/test/task1/file_mess/secret_message
[root@zfs ~]# cat /otus/test/task1/file_mess/secret_message
https://github.com/sindresorhus/awesome
```
