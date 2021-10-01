#!/bin/sh

rm -rf ~/test

# 1. создать каталог test в домашнем каталоге пользователя
mkdir ~/test

# 2. создать в нем файл list, содержащий список всех файлов и поддиректориев каталога /etc
cd ~/test

for f in /etc/*
do
  if [[ -d "$f" ]] 
  then
    echo "/$f" >> list
   else
    echo "$f" >> list
  fi
done;
