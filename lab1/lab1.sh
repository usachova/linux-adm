#!/bin/sh

rm -rf ~/test
rm -r ~/list*
rm -r ~/hlink
rm -r

# 1. создать каталог test в домашнем каталоге пользователя
mkdir ~/test

# 2. создать в нем файл list, содержащий список всех файлов и поддиректориев каталога /etc
cd ~/test
cnt_dirs=0
cnt_hfiles=0
for f in /etc/*
do
  if [[ -d "$f" ]] 
  then
    echo "dir: $f" >> list
    let cnt_dirs=cnt_dirs+1
   else
    echo "file: $f" >> list
  fi
done;
for f in /etc/.*
do
  if [[ "$f" != "/etc/." && "$f" != "/etc/.." ]] 
  then
    if [[ -d "$f" && "$f" != "/etc/." && "$f" != "/etc/.." ]] 
    then
      echo "dir: $f" >> list
    else
      echo "file: $f" >> list
      let cnt_hfiles=cnt_hfiles+1
    fi
  fi
done;

# 3. вывести в конец этого файла два числа
echo "cnt dirs: $cnt_dirs" >> list
echo "cnt hfiles: $cnt_hfiles" >> list

# 4. создать в каталоге test каталог links
mkdir ~/test/links

# 5. создать в каталоге links жесткую ссылку на файл list с именем list_hlink
ln ~/test/list ~/test/links/list_hlink

# 6. создать в каталоге links символическую ссылку на файл list с именем list_slink
ln -s ~/test/list ~/test/links/list_slink

# 7. вывести на экран количество..
cnt_hlink=$(ls -l ~/test/links/list_hlink | cut -d " " -f2)
cnt_list=$(ls -l ~/test/list | cut -d " " -f2)
cnt_slink=$(ls -l ~/test/links/list_slink | cut -d " " -f2)
echo $cnt_hlink $cnt_list $cnt_slink

# 8. дописать в конец файла list_hlink число строк в файле list
wc -l ~/test/list | cut -d " " -f1 >> ~/test/links/list_hlink

# 9. сравнить содержимое файлов list_hlink и list_slink
if diff -q ~/test/links/list_hlink ~/test/links/list_slink 
then
	echo "YES"
fi

# 10. Переименовать файл list в list1
mv ~/test/list ~/test/list1

# 11. сравнить содержимое файлов list_hlink и list_slink
if diff -q ~/test/links/list_hlink ~/test/links/list_slink 
then
	echo "YES"
fi

# 12. cоздать в домашнем каталоге пользователя жесткую ссылку на каталог links
# ln ~/test/links ~/hlink
ln -s ~/test/links ~/hlink

# 13. cоздать в домашнем каталоге файл list_conf, содержащий список файлов с расширением .conf, из каталога /etc и всех его подкаталогов
find /etc/ -type f -name "*.conf" > ~/list_conf

# 14. создать в домашнем каталоге файл list_d, содержащий список всех подкаталогов каталога /etc, расширение которых .d
find /etc/ -type d -name "*.conf" > ~/list_d

# 15. создать файл list_conf_d, включив в него последовательно содержимое list_conf и list_d
cat ~/list_conf ~/list_d > ~/list_conf_d

# 16. создать в каталоге test скрытый каталог sub
mkdir ~/test/.sub

# 17. скопировать в него файл list_conf_d
cp ~/list_conf_d ~/test/.sub

# 18. еще раз скопировать туда же этот же файл в режиме автоматического создания резервной копии замещаемых файлов
cp -b ~/list_conf_d ~/test/.sub

# 19. вывести на экран полный список файлов (включая все подкаталоги и их содержимое) каталога test
find ~/test

# 20. создать в домашнем каталоге файл man.txt, содержащий документацию на команду man
man man > ~/man.txt
