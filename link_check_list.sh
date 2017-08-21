#!/bin/sh
##
##
## クロール対象のURLを送信するシェル
##
##
##

# クロールをするファルダ確認
if [ -e /root/crawler ];then
 echo '/root/crawler にURLリスト結果を出力します'
else
 mkdir /root/crawler
 chmod -R 755 /root/crawler
 echo '/root/crawler にフォルダを作成しました'
 echo '/root/crawler にURLリスト結果を出力します'
fi

# クロール用のディレクトリに移動
cd /root/crawler

# どのサーバか分かるように
host=`hostname`

# クロールするリスト
list='/root/crawler/link_check_list.txt'

echo 'ドメインを抽出します'

# ドメインを抽出する
ls --ignore=*.svn /home > $list

echo 'ドメインを抽出しました'

# 権限つける
chmod -R 755 /root/crawler

# URLを作成、とりあえず全部wwwをつける
sed -i "s/^/http\:\/\/www\./g" $list
sed -i "s/$/\//g" $list

# 1番下にホストネームを挿入
echo $host >> $list


# 対象URLファイルを186サーバに送信

case $host in
 '****' ) rsync -az --delete /root/crawler/ root@*******::home/****** ;;
 '****' ) rsync -az --delete /root/crawler/ root@*******::home/****** ;;
 '****' ) rsync -az --delete /root/crawler/ root@*******::home/****** ;;
esac

echo 'URLのリストをサーバに送信しました。'


