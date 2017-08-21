#!/bin/sh

chmod -R 755 /proc/loadavg

host=`hostname`

#デフォルト値20
limit=${1:-20.0}

while [ "1" -eq "1" ]
do
# 現在のロードアベレージを取得
loadavg=`cat /proc/loadavg | cut -d ' ' -f 1`

# 判定
result=`echo "$limit < $loadavg" | bc`
if [ $result -eq 1 ]; then
    mail -s "$host のロードアベレージが $loadavg を超えました" info@example.com
    sleep 1800
else
    sleep 10
fi
done

