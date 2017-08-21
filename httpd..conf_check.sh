#!/bin/sh


if [ "$1" = "" ]
then
    echo "第一引数がありません。稼働確認するサーバのIPアドレスが必要です"
    exit
fi

echo "片方のサーバ稼働確認中"


# 稼働確認するサーバのIPアドレス
ipAddress=$1
move=$(sshpass -p passpass ssh root@$ipAddress "ps -ef | grep httpd | grep -v grep | wc -l")
# 稼働確認
if test $move -eq "0"
then
    echo "片方のサーバが稼働していません。"
    echo "処理を中止します"
    exit
fi

echo "片方のサーバは稼働しています"

# httpd.confを書き換える必要があるか確認
diff -a /root/httpd.conf /etc/httpd/conf/httpd.conf

if test $? -eq "0"
then
    echo "httpd.conf の差異がありません"
    exit
else
    echo "上記は httpd.conf に追記された内容です"
fi


# バックアップ取得
sudo cp -p /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.`date '+%Y%m%d'`

cd /etc/httpd/conf

# バックアップが無ければ、処理中止
if [ ! -e httpd.conf.`date '+%Y%m%d'` ]; then
    echo "バックアップがありません。"
    exit
fi

echo "バックアップを取得しました"

# バックアップ確認を出力
ls -l /etc/httpd/conf

cd /root

# 最新のhttpd.confに書き換える  一時的にエイリアスを無効にする
\cp -f /root/httpd.conf /etc/httpd/conf/httpd.conf

# 再起動
ulimit -n 5000
service httpd restart

# host名を取得
host=`hostname`

status=$(ps -ef | grep httpd | grep -v grep | wc -l)

if test $status -eq "0"
then
    echo "httpd が停止しています"

    # httpd.confを元に戻す
    \cp -f /etc/httpd/conf/httpd.conf.`date '+%Y%m%d'` /etc/httpd/conf/httpd.conf
    echo "httpd.conf を元に戻しました"

    # 再起動
    ulimit -n 5000
    service httpd restart

    # 稼働確認
    check=$(ps -ef | grep httpd | grep -v grep | wc -l)
    if test $check -eq "0"
    then
        # 通知する
        mail -s "サーバ設定に失敗しました $host のhttpdが停止しています" info@example.com

        echo "httpd は停止しています"
    else
        # 通知する
        mail -s "サーバ設定に失敗しました $host のhttpdが稼働しています" info@example.com

        echo "httpd は正常稼働しています"
    fi

else
    mail -s "$host のサーバ設定が正常に完了しました。" info@example.com

    echo "httpd は正常稼働しています"
fi


echo "完了しました"



