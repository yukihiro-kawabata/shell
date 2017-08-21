#!/bin/sh

user=$1
password=$2

echo $user
echo $password

#ユーザ追加
sudo useradd $user
sudo echo $password | passwd $user --stdin

echo 'ユーザ名：'$user　'パスワード：'$password　'完了しました'

exit
