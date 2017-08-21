#!/bin/sh

<<EOF
### スレーブDBサーバの /root/ に設置する
vi /root/checkSlave.sh
chmod 755 /root/checkSlave.sh

### 127.0.0.1 hostname を追記
yum install -y sendmail
cp /etc/hosts{,.`date +%Y%m%d`}
echo 127.0.0.1 `hostname` >> /etc/hosts
cat /etc/hosts
service sendmail restart

### crontab のパスは /usr/bin:/bin なのでシンボリックリンク
SENDMAIL=`which sendmail`
ln -s ${SENDMAIL} /usr/bin/sendmail

### crontab で5分毎に実行し、レプリケーションの設定が Yes 以外の場合にメールする
yum install -y crontabs
crontab -e
*/5 * * * * /root/checkSlave.sh

EOF

cd /root

### get status
LOG=checkSlave.log
echo 'SHOW SLAVE STATUS\G' | mysql -u estsrch --password=FGtcDH6LJQFAhxS2 > ${LOG}

Slave_IO_Running=`cat ${LOG} | grep Slave_IO_Running: | awk '{print $2}'`
Slave_SQL_Running=`cat ${LOG} | grep Slave_SQL_Running: | awk '{print $2}'`

SENDFLG=true
if [ ${Slave_IO_Running} = "Yes" ]; then
    if [ ${Slave_SQL_Running} = "Yes" ]; then
        SENDFLG=false
        echo Slave DB Replication is Running.
    fi
fi

### sendmail
if ${SENDFLG}; then
    echo Slave DB Replication is Stopped!!
    host=`hostname`
    mail -s "$host Slave DB Replication is Stopped!!" info@example.com
fi

