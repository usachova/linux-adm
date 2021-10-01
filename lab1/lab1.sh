#!/bin/sh

rm -rf ~/test
rm -r ~/list

# 1. создать каталог test в домашнем каталоге пользователя
mkdir ~/test

# 2. создать в нем файл list, содержащий список всех файлов и поддиректориев каталога /etc
cd ~/test
let cnt_dirs=0
let cnt_hfiles=0
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
  if [[ -d "$f" && ("$f" != "/etc/." && "$f" != "/etc/..") ]] 
  then
    echo "dir: $f" >> list
   else
    echo "file: $f" >> list
    let cnt_hfiles=cnt_hfiles+1
  fi
done;

# 3. вывести в конец этого файла два числа
echo "cnt dirs: $cnt_dirs" >> list
echo "cnt hfiles: $cnt_hfiles" >> list
