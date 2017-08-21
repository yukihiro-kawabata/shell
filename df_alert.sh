#!/bin/sh

#
#
# サーバの容量監視
#
#

host=`hostname`

# 数字の宣言
char=`expr "$1" : '\([0-9][0-9]*\)'`

# 引数なし、引数が数字で無いなら85%
limit=$1
if [ "${limit}" = "" -o "$char" != "${limit}" ];then
    limit=85
fi

while :
do
    # 容量の確認
    DVAL=`/bin/df / | /usr/bin/tail -1 | /bin/sed 's/^.* \([0-9]*\)%.*$/\1/'`
    if [ $DVAL -gt $limit ]; then
      echo  "$host の容量が一定数を超えました。現在のディスク使用量: $DVAL %" | mail -s "$host の容量が一定数を超えました。" info@example.com
      sleep 30m
    else
      sleep 10s
    fi
done

