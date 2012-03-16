#!/bin/sh

#backup mongodb
workdir=/data/backup
dump=/usr/local/bin/mongodump
port=20000


$dump --port $port -o $workdir -d flash_game
$dump --port $port -o $workdir -d flash_game_post
$dump --port $port -o $workdir -d flash_game_log_2011
$dump --port $port -o $workdir -d flash_game_log_2012  
$dump --port $port -o $workdir -d flash_game_topic  

#backup mysql
mysql_host=222.35.143.109
mysql_user=dev
mysql_pass=dev123

/usr/local/bin/mysqldump --host=$mysql_host --user=$mysql_user --password=$mysql_pass zuan>$workdir/master.sql
