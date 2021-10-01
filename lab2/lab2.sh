#!/bin/sh

# 1. Создайте новый раздел, начинающийся с первого свободного сектора и имеющий размер 300 МБайт.
fdisk /dev/sda
# n p 3 [def] +300M w

# 2. Создайте файл в домашнем каталоге пользователя root и сохраните в него UUID созданного раздела.
blkid /dev/sda3 | cut -d "\"" -f2 > ~/UUID

# 3. Создайте на созданном разделе файловую систему ext4 с размером блока 4096 байт.
mkfs.ext4 -b 4096 /dev/sda3

# 4. Выведите на экран текущее состояние параметров, записанных в суперблоке созданной файловой системы.
dumpe2fs -h /dev/sda3

# 5. Настройте эту файловую систему таким образом, чтобы ее автоматическая проверка запускалась через 2 месяца или каждое второе монтирование файловой системы.
tune2fs -i 2m -C 2 /dev/sda3

# 6. Создайте в каталоге /mnt подкаталог newdisk и подмонтируйте в него созданную файловую систему.
mkdir /mnt/newdisk
mount -t ext4 /dev/sda3 /mnt/newdisk

# 7. Создайте в домашнем каталоге пользователя root ссылку на смонтированную файловую систему
ln -s /mnt/newdisk ~/sl_newdisk

# 8. Создайте каталог с любым именем в смонтированной файловой системе.
mkdir /mnt/newdisk/papka

# 9. Включите автомонтирование при запуске операционной системы созданной файловой системы в /mnt/newdisk таким образом..
echo "/dev/sda3 /mnt/newdisk ext4 noexec,noatime 0 0" >> /etc/fstab
reboot

# 10. Увеличьте размер раздела и файловой системы до 350 МБайт. Проверьте, что размер изменился.
umount /dev/sda3
fdisk /dev/sda
# d 3 n p 3 [def] +350M w
reboot
resize2fs /dev/sda3
df -h

# 11. Проверьте на наличие ошибок созданную файловую системы "в безопасном режиме", то есть в режиме запрета внесения каких-либо изменений 
#     в файловую систему, даже если обнаружены ошибки.
fsck -n /dev/sda3

# 12. Создайте новый раздел, размером в 12 Мбайт. Настройте файловую систему, созданную в пункте 3 таким образом, 
#     чтобы ее журнал был расположен на разделе, созданном в этом пункте.
fdisk /dev/sda
# n p 3 [def] +12M w
mkfs.ext4 /dev/sda4
mount /dev/sda3 /mnt/journal
tune2fs -J location=/mnt/journal /dev/sda3

# 13. Создайте два новых раздела, размером в 100 МБайт каждый.
fdisk /dev/sda
# d 3 d 4 n p +100M n p +100M w

# 14. Создайте группу разделов LVM и логический том LVM над созданными в предыдущем пункте разделами.
#     Создайте файловую систему ext4 для созданного логического тома LVM и смонтируйте её в предварительно созданный каталог supernewdisk в каталоге mnt.
pvcreate /dev/sda3 /dev/sda4
vgcreate gr /dev/sda3 /dev/sda4
lvcreate -L 50M -n vl gr
mkfs.ext4 /dev/gr/vl
mkdir /mnt/supernewdisk
mount /dev/gr/vl /mnt/supernewdisk

# 15. Создайте папку (каталог) в хостовой операционной системе и предоставьте к ней сетевой доступ, создав сетевой ресурс на хостовой операционной системе. 
#     Создайте в директории /mnt поддиректорию share и подмонтируйте в нее созданный сетевой ресурс.
mkdir /mnt/share
mount.cifs //192.168.1.96/shared /mnt/share

# 16. Сделайте так, чтобы сетевой ресурс автоматически монтировалcя для чтения при загрузке операционной системы.
#     Перезагрузите операционную систему и проверьте, что автоматическое монтирование ресурса выполнилось.
echo "//192.168.1.96/shared /mnt/share cifs ro 0 0" >> /etc/fstab
