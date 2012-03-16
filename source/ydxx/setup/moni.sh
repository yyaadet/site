#!/bin/sh

WEBHF_SCRIPT=/usr/local/etc/rc.d/webhf.sh
HFD_SCRIPT=/usr/local/etc/rc.d/hfd.sh
URL="http://hf.51zhi.com/home/money?uid=1"
FETCH=/usr/bin/fetch
TIMEOUT=30
LOG=/usr/local/hfd/moni.log


webhf()
{
	${FETCH} -T ${TIMEOUT} -o /dev/null $URL
	if ! test $? -eq 0; then
		echo -n `date "+%Y-%m-%d %H:%M:%S"` >> $LOG
		echo "webhf failed" >> $LOG
		$WEB_SCRIPT restart
	fi
}

hfd()
{
	pgrep hfd
	if ! test $? -eq 0; then
		echo -n `date "+%Y-%m-%d %H:%M:%S"` >> $LOG
		echo "hfd failed" >> $LOG
		$HFD_SCRIPT restart
	fi
}

databackup()
{
	yest=`date "+%Y-%m-"`
	day=`date "+%d"`
	day=`expr $day - 1`
	if test $day -lt 10; then
		day="0$day"
	fi
	yest="/usr/local/hfd/sdb/$yest$day*"
	echo $yest
	rm -rf "$yest"
	/usr/local/etc/rc.d/hfd.sh backup
}

main()
{
	databackup
	webhf
	hfd
}

main 
