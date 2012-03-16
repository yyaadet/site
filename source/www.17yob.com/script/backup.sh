#!/bin/sh

#backup mongodb
workdir=/data/backup/digg
dump=/usr/local/bin/mongodump
port=20000
  
$dump --port $port -o $workdir
