#!/bin/sh

#
# Fatalエラーが出ていないかチェックするシェル
#

host=`hostname`

# エラーの一時保存先
errorFile='/tmp/allError.log' # 最新エラーログ
errorDiffFile='/tmp/allErrorDiff.log' # 前回エラーログ

# ファイルが存在しなければ作成する
if [ ! -e $errorFile ]; then
 touch $errorFile
fi
if [ ! -e $errorDiffFile ]; then
 touch $errorDiffFile
fi

chmod -R 755 $errorFile
chmod -R 755 $errorDiffFile

# ファイルの初期化
: > $errorFile
: > $errorDiffFile

while true
do
#echo "$i回目の Fatal チェックです"
#result=$(find /var/log/httpd/ -type f -print | xargs grep -E 'Fatal')

 find /var/log/httpd/ -type f -print | xargs grep -E 'Fatal' > $errorFile

 # 前回エラーとの差異を取得
 error=$(diff -a "$errorFile" "$errorDiffFile")

 if [ ! "$error" = "" ]; then
  cat "${error}" | mail -s  "$host の Fatal エラー" info@example.com
  # エラーファイルを最新にする
  \cp -f $errorFile $errorDiffFile
 fi

 sleep 60s
done

