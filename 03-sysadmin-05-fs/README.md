# Домашнее задание к занятию "3.5. Файловые системы"

1. Узнайте о [sparse](https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D0%B7%D1%80%D0%B5%D0%B6%D1%91%D0%BD%D0%BD%D1%8B%D0%B9_%D1%84%D0%B0%D0%B9%D0%BB) (разряженных) файлах.

---

Ответ:

*Технология поддерживается некоторыми torrent клиентами, используется для VDI.*

---

2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?

---

Ответ:

*Из лекции мы узнали, что hardlink это ссылка на тот же самый файл и имеет тот же inode. Значит права будут одни и теже.* 

*Проверяем:*

```
vagrant@vagrant:~$ touch test.txt
vagrant@vagrant:~$ ln test.txt test-link
vagrant@vagrant:~$ ll
<skip>
-rw-rw-r-- 2 vagrant vagrant    0 Nov 23 12:43 test-link
-rw-rw-r-- 2 vagrant vagrant    0 Nov 23 12:43 test.txt
<skip>
vagrant@vagrant:~$ chmod 644 test-link
vagrant@vagrant:~$ ll
<skip>
-rw-r--r-- 2 vagrant vagrant    0 Nov 23 12:43 test-link
-rw-r--r-- 2 vagrant vagrant    0 Nov 23 12:43 test.txt
<skip>
```


---

3. Сделайте `vagrant destroy` на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:

    ```bash
    Vagrant.configure("2") do |config|
      config.vm.box = "bento/ubuntu-20.04"
      config.vm.provider :virtualbox do |vb|
        lvm_experiments_disk0_path = "/tmp/lvm_experiments_disk0.vmdk"
        lvm_experiments_disk1_path = "/tmp/lvm_experiments_disk1.vmdk"
        vb.customize ['createmedium', '--filename', lvm_experiments_disk0_path, '--size', 2560]
        vb.customize ['createmedium', '--filename', lvm_experiments_disk1_path, '--size', 2560]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk0_path]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk1_path]
      end
    end
    ```

    Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.

---

Ответ:

*Выполнено.*

```
vagrant@vagrant:~$ lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                    8:0    0   64G  0 disk 
├─sda1                 8:1    0  512M  0 part /boot/efi
├─sda2                 8:2    0    1K  0 part 
└─sda5                 8:5    0 63.5G  0 part 
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm  /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm  [SWAP]
sdb                    8:16   0  2.5G  0 disk 
sdc                    8:32   0  2.5G  0 disk 
```

---

4. Используя `fdisk`, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.

---

Ответ:

*Выполнено.*

```
vagrant@vagrant:~$ sudo fdisk -l /dev/sdb
Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK   
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x4e53663d

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdb1          2048 4196351 4194304    2G 83 Linux
/dev/sdb2       4196352 5242879 1046528  511M 83 Linux
```

---

5. Используя `sfdisk`, перенесите данную таблицу разделов на второй диск.

---

Ответ:

*Выполнено.*

```
vagrant@vagrant:~$ sudo sfdisk -d /dev/sdb | sudo sfdisk /dev/sdc
Checking that no-one is using this disk right now ... OK

Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK   
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Created a new DOS disklabel with disk identifier 0x4e53663d.
/dev/sdc1: Created a new partition 1 of type 'Linux' and of size 2 GiB.
/dev/sdc2: Created a new partition 2 of type 'Linux' and of size 511 MiB.
/dev/sdc3: Done.

New situation:
Disklabel type: dos
Disk identifier: 0x4e53663d

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdc1          2048 4196351 4194304    2G 83 Linux
/dev/sdc2       4196352 5242879 1046528  511M 83 Linux

The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
vagrant@vagrant:~$ 
```

---

6. Соберите `mdadm` RAID1 на паре разделов 2 Гб.

---

Ответ:

*Выполнено.*

```
vagrant@vagrant:~$ sudo mdadm -C -v /dev/md1 -l 1 -n 2 /dev/sd{b,c}1
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
mdadm: size set to 2094080K
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md1 started.
```

---

7. Соберите `mdadm` RAID0 на второй паре маленьких разделов.

---

Ответ:

*Выполнено.*

```
vagrant@vagrant:~$ sudo mdadm -C -v /dev/md0 -l 0 -n 2 /dev/sd{b,c}2
mdadm: chunk size defaults to 512K
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
```

*Текущее состояние блочных устройств.*

```
vagrant@vagrant:~$ lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                    8:0    0   64G  0 disk  
├─sda1                 8:1    0  512M  0 part  /boot/efi
├─sda2                 8:2    0    1K  0 part  
└─sda5                 8:5    0 63.5G  0 part  
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm   /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]
sdb                    8:16   0  2.5G  0 disk  
├─sdb1                 8:17   0    2G  0 part  
│ └─md1                9:1    0    2G  0 raid1 
└─sdb2                 8:18   0  511M  0 part  
  └─md0                9:0    0 1018M  0 raid0 
sdc                    8:32   0  2.5G  0 disk  
├─sdc1                 8:33   0    2G  0 part  
│ └─md1                9:1    0    2G  0 raid1 
└─sdc2                 8:34   0  511M  0 part  
  └─md0                9:0    0 1018M  0 raid0 
vagrant@vagrant:~$ 
```

---

8. Создайте 2 независимых PV на получившихся md-устройствах.

---

Ответ:

*Выполнено.*

```
vagrant@vagrant:~$ sudo pvcreate /dev/md1 /dev/md0
  Physical volume "/dev/md1" successfully created.
  Physical volume "/dev/md0" successfully created.
vagrant@vagrant:~$
```

---

9. Создайте общую volume-group на этих двух PV.

---

Ответ:

*Выполнено.*

```
vagrant@vagrant:~$ sudo vgcreate vg01 /dev/md1 /dev/md0
  Volume group "vg01" successfully created
vagrant@vagrant:~$ 
```
*Текущее состояние.*

```
vagrant@vagrant:~$ sudo vgdisplay vg01
  --- Volume group ---
  VG Name               vg01
  System ID             
  Format                lvm2
  Metadata Areas        2
  Metadata Sequence No  1
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                0
  Open LV               0
  Max PV                0
  Cur PV                2
  Act PV                2
  VG Size               <2.99 GiB
  PE Size               4.00 MiB
  Total PE              765
  Alloc PE / Size       0 / 0   
  Free  PE / Size       765 / <2.99 GiB
  VG UUID               uecII6-rp6B-68Qy-68Rr-H11A-w7RM-AybkXO
   
vagrant@vagrant:~$ 

```

---

10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.

---

Ответ:

*Выполнено.*

```
vagrant@vagrant:~$ sudo lvcreate -L 100M -n lv01 vg01 /dev/md0
  Logical volume "lv01" created.
vagrant@vagrant:~$ 
```

```
vagrant@vagrant:~$ sudo lvs /dev/vg01/lv01
  LV   VG   Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  lv01 vg01 -wi-a----- 100.00m                                                    
vagrant@vagrant:~$ 
```

---

11. Создайте `mkfs.ext4` ФС на получившемся LV.

---

Ответ:

*Выполнено.*

```
vagrant@vagrant:~$ sudo mkfs.ext4 /dev/vg01/lv01
mke2fs 1.45.5 (07-Jan-2020)
Creating filesystem with 25600 4k blocks and 25600 inodes

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (1024 blocks): done
Writing superblocks and filesystem accounting information: done

vagrant@vagrant:~$ 
```

---

12. Смонтируйте этот раздел в любую директорию, например, `/tmp/new`.

---

Ответ:

*Выполнено.*

```
vagrant@vagrant:~$ mkdir /tmp/new
vagrant@vagrant:~$ sudo mount /dev/vg01/lv01 /tmp/new
```

---

13. Поместите туда тестовый файл, например `wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz`.

---

Ответ:

*Выполнено.*

```
vagrant@vagrant:~$ sudo wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
--2021-11-23 22:03:40--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183
Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 22574691 (22M) [application/octet-stream]
Saving to: ‘/tmp/new/test.gz’

/tmp/new/test.gz                  100%[============================================================>]  21.53M  5.31MB/s    in 3.9s    

2021-11-23 22:03:45 (5.47 MB/s) - ‘/tmp/new/test.gz’ saved [22574691/22574691]

vagrant@vagrant:~$ 
```
```
vagrant@vagrant:~$ ll /tmp/new
total 22072
drwxr-xr-x  3 root root     4096 Nov 23 22:03 ./
drwxrwxrwt 10 root root     4096 Nov 23 22:00 ../
drwx------  2 root root    16384 Nov 23 21:52 lost+found/
-rw-r--r--  1 root root 22574691 Nov 23 17:39 test.gz
vagrant@vagrant:~$
```

---

14. Прикрепите вывод `lsblk`.

---

Ответ:

```
vagrant@vagrant:~$ lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                    8:0    0   64G  0 disk  
├─sda1                 8:1    0  512M  0 part  /boot/efi
├─sda2                 8:2    0    1K  0 part  
└─sda5                 8:5    0 63.5G  0 part  
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm   /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]
sdb                    8:16   0  2.5G  0 disk  
├─sdb1                 8:17   0    2G  0 part  
│ └─md1                9:1    0    2G  0 raid1 
└─sdb2                 8:18   0  511M  0 part  
  └─md0                9:0    0 1018M  0 raid0 
    └─vg01-lv01      253:2    0  100M  0 lvm   /tmp/new
sdc                    8:32   0  2.5G  0 disk  
├─sdc1                 8:33   0    2G  0 part  
│ └─md1                9:1    0    2G  0 raid1 
└─sdc2                 8:34   0  511M  0 part  
  └─md0                9:0    0 1018M  0 raid0 
    └─vg01-lv01      253:2    0  100M  0 lvm   /tmp/new
vagrant@vagrant:~$
```

---

15. Протестируйте целостность файла:

    ```bash
    root@vagrant:~# gzip -t /tmp/new/test.gz
    root@vagrant:~# echo $?
    0
    ```
---

Ответ:

*Выполнено.*

```
vagrant@vagrant:~$ sudo -i
root@vagrant:~# gzip -t /tmp/new/test.gz && echo $?
0
root@vagrant:~# exit
logout
vagrant@vagrant:~$
```

---

16. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.

---

Ответ:

*Выполнено.*

```
vagrant@vagrant:~$ sudo pvmove /dev/md0 /dev/md1
  /dev/md0: Moved: 20.00%
  /dev/md0: Moved: 100.00%
vagrant@vagrant:~$ lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                    8:0    0   64G  0 disk  
├─sda1                 8:1    0  512M  0 part  /boot/efi
├─sda2                 8:2    0    1K  0 part  
└─sda5                 8:5    0 63.5G  0 part  
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm   /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]
sdb                    8:16   0  2.5G  0 disk  
├─sdb1                 8:17   0    2G  0 part  
│ └─md1                9:1    0    2G  0 raid1 
│   └─vg01-lv01      253:2    0  100M  0 lvm   /tmp/new
└─sdb2                 8:18   0  511M  0 part  
  └─md0                9:0    0 1018M  0 raid0 
sdc                    8:32   0  2.5G  0 disk  
├─sdc1                 8:33   0    2G  0 part  
│ └─md1                9:1    0    2G  0 raid1 
│   └─vg01-lv01      253:2    0  100M  0 lvm   /tmp/new
└─sdc2                 8:34   0  511M  0 part  
  └─md0                9:0    0 1018M  0 raid0 
vagrant@vagrant:~$ 
```

---

17. Сделайте `--fail` на устройство в вашем RAID1 md.

---

Ответ:

*Выполнено.*

```
vagrant@vagrant:~$ sudo mdadm /dev/md1 --fail /dev/sdc1
mdadm: set /dev/sdc1 faulty in /dev/md1
vagrant@vagrant:~$ sudo mdadm --detail /dev/md1
/dev/md1:
           Version : 1.2
     Creation Time : Tue Nov 23 18:46:47 2021
        Raid Level : raid1
        Array Size : 2094080 (2045.00 MiB 2144.34 MB)
     Used Dev Size : 2094080 (2045.00 MiB 2144.34 MB)
      Raid Devices : 2
     Total Devices : 2
       Persistence : Superblock is persistent

       Update Time : Tue Nov 23 22:32:02 2021
             State : clean, degraded 
    Active Devices : 1
   Working Devices : 1
    Failed Devices : 1
     Spare Devices : 0

Consistency Policy : resync

              Name : vagrant:1  (local to host vagrant)
              UUID : 70c9d088:ea200577:5aa5765d:011fbc78
            Events : 22

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       -       0        0        1      removed

       1       8       33        -      faulty   /dev/sdc1
vagrant@vagrant:~$ 
```



---

18. Подтвердите выводом `dmesg`, что RAID1 работает в деградированном состоянии.

---

Ответ:

```
vagrant@vagrant:~$ dmesg |grep md1
<skip>
[41609.810711] md/raid1:md1: Disk failure on sdc1, disabling device.
               md/raid1:md1: Operation continuing on 1 devices.
vagrant@vagrant:~$ 
```

---

19. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:

    ```bash
    root@vagrant:~# gzip -t /tmp/new/test.gz
    root@vagrant:~# echo $?
    0
    ```

---

Ответ:

*Выполнено.*

```
vagrant@vagrant:~$ sudo -i
root@vagrant:~# gzip -t /tmp/new/test.gz
root@vagrant:~# echo $?
0
root@vagrant:~# exit
logout
vagrant@vagrant:~$ 
```

---

20. Погасите тестовый хост, `vagrant destroy`.

---

Ответ:

```
virt@virt13:~/SOFT/vagrant/vagrant-fs$ vagrant destroy
    default: Are you sure you want to destroy the 'default' VM? [y/N] y
==> default: Forcing shutdown of VM...
==> default: Destroying VM and associated drives...
virt@virt13:~/SOFT/vagrant/vagrant-fs$ 
```

---
