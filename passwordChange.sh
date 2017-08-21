#!/bin/sh

#
# パスワードを変更するシェル
#
# 第一引数　ユーザ名 default userName
# 第二引数　パスワードの文字数 default 16文字
#

# 第一引数
user=$1

# 第二引数
length=$2

# メール送信先を選定
array=("mailAddress" "mailAddress" "mailAddress")

# 本日の日付を取得
#today="`date '+%m'`月`date '+%d'`日"
today=`date +%Y/%m/%d.%H:%M:%S`

# ホスト名を取得
host=`hostname`

# ------------------------------------------


# ユーザ名 デフォルト userName
if [ "${user}" = "" ];then
  user='userName'
fi

# パスワードの長さ デフォルト16文字
if [ "${length}" = "" ];then
  length=16
fi

# パスワードを生成
passwd=$(openssl rand -base64 12 | fold -w "${length}" | head -1)

#ユーザ追加
echo $passwd | passwd $user --stdin



# ------------------ メール設定

title="$host のFTPパスワード変更をお知らせします"

from="mailAddress"

mailBody="--------------------\nパスワードは約5分後に通知されます\n--------------------\n\n$host のユーザー「$user」のFTPパスワード変更をしました。"
mailBody2="FTPパスワード変更をお知らせします\n\n[Subject]\nRe:$host のFTPパスワード変更をお知らせします\n\n[Date]\n${today}\n\n[Password]\n${passwd}"

# メール送信
for i in "${array[@]}"
do
  echo -e "$mailBody" | mail -s "$title" -r "$from" "${i}"
done

# 5分待機
sleep 5m

# メール送信
for i in "${array[@]}"
do
  echo -e "$mailBody2" | mail -s "Re:$title" -r "$from" "${i}"
done

