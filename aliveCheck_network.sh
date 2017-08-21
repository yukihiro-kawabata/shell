#!/bin/sh

#
# ネットにつながっているか監視するシェル
#
# 第一引数　確認したいホスト default : localhost
#

host=`hostname`

# 第一引数
ipAddress=$1

# 指定がなければ、localhost
if [ "$ipAddress" = ""  ];then
  ipAddress="localhost"
fi

# 接続の履歴を残すファイルを指定する
touch /root/network.log
logFile='/root/network.log'
chmod -R 755 $logFile

# 最初は生きている前提
status=true

# 連続接続エラーカウンター
errorCnt=0

# とりあえず空にする
: > /root/network.log

while true
do

# ----------------------- ネットつながらない場合

  # ping に失敗していて、復旧が確認できたらスラック通知
  if [ "$status" == 'false' ];then

    # 生存確認
    /bin/ping "$ipAddress" -c 1 > /dev/null
    if [ "$?" == 0 ];then

      # 時間を取得
      time=`date +%Y/%m/%d[%H:%M:%S]`
      echo "$time  $ipAddress の接続に成功しました。" >> $logFile

      # ステータスを生存にする
      status=true

      # 5回以上連続で失敗してたら通知
      if [ "$errorCnt" -gt 5 ];then

        # 接続履歴があれば処理する
        if [ -s "$logFile" ]; then

          # 接続履歴を読み込む
          report=$(cat "$logFile")

          # 障害レポートを提出
          cat "$report" | mail -s "$host の接続履歴を送付します" info@example.com
          # 障害レポートを提出したら、ファイルを空にする
          : > $logFile
        fi

      else

        # 5回以上連続で失敗してなかったら、白紙に戻す
        : > $logFile

      fi
      # エラーカウント初期化
      errorCnt=0
    else

      # 接続できなかった数をカウントする
      errorCnt=`expr $errorCnt + 1`

      # 5回以上連続で失敗したら、接続エラーとみなす
      if [ "$errorCnt" -gt 5 -a "$errorCnt" -le 10 ];then

        # 時間を取得
        time=`date +%Y/%m/%d[%H:%M:%S]`
        echo "$time  $ipAddress の接続に失敗しました。" >> $logFile

        # ステータスを死亡にする
        status=false

      fi
    fi

  else

# ------------------------- ネットにつながっている場合

    # 生存確認
    /bin/ping "$ipAddress" -c 1 > /dev/null

    # ping に失敗していたら、ステータスを死亡にする
    if [ "$?" == 0 ];then
      status=true
      errorCnt=0
    else
      # 接続できなかった数をカウントする
      errorCnt=`expr $errorCnt + 1`

      # ステータスを死亡にする
      status=false
    fi

  fi

  sleep 1s
done

