#!/bin/sh

# オリジナルのログローテートみたいなやつです
# 溜まったログを管理するシェル
# ログは30日間残しておく
# 圧縮したログファイルは [logのパス]/backup/ に保存される

# 本日の日付を取得
date=`date '+%Y%m%d'`


##############  ファイル定義   ################

# ログファイル一覧
log='[logのパス]/'

# バックアップディレクトリ
dir="${log}backup/"

###############################################


# ディレクトリがなければ、作成して権限設定をする
if [ ! -d "$dir" ]; then
   mkdir $dir
   chmod -R 777 $dir
   chown -R apache:apache $dir
fi

# ログファイルを圧縮する
find "$log" -name "*.log" -exec zip -j {}_${date}.zip {} \;

# 圧縮したログをbackupディレクトリに移動させる
find "$log" -name "*.zip" -type f | xargs -i mv {} "$dir"

# 31日前のログを削除
find "$dir" -mtime +31 -type f -exec rm -f {} \;

# ログファイルの初期化
find "$log" -name "*.log" -type f -exec cp /dev/null {} \;

