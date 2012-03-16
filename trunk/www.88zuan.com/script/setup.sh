#!/bin/sh

CUR_DIR=`pwd`
PYTHON=/usr/local/bin/python
SOURCE=${CUR_DIR}/sources
INSTALL=/usr/bin/install
EASY_INSTALL=/usr/local/bin/easy_install
game=
proc=
port=

setup_web()
{
	echo "setup web ... "

	websh=/usr/local/etc/rc.d/web$game.sh
	webini=/usr/local/etc/web$game.ini

	$websh stop 

	rm -rf /usr/local/lib/python2.5/site-packages/zuan_new*

	setup_web_config $webini

	$EASY_INSTALL -q -O2 *.egg
	
	setup_web_sh $websh

	$websh start
}


setup_web_config()
{
	webini=$1
	tmp=tmp.ini

	rm -rf $tmp

	echo -n "Please input process num: "
	read proc
	if test -z $proc ; then
		proc=6
	fi
	
	echo -n "Please input listen port: "
	read port
	if test -z $port ; then
		port=8010
	fi

	echo -n "Please input db: "
	read db

	echo "
[DEFAULT]
debug = true
email_to = 
smtp_server = localhost
error_email_from = 164504252@qq.com

[server:main]
use = egg:Paste#http
host = 0.0.0.0
port = %(http_port)s
use_threadpool = True
threadpool_workers = 32

[app:main]
use = egg:zuan_new
full_stack = true
static_files = true

cache_dir = %(here)s/web$game
beaker.session.key = $game
beaker.session.secret = 5glIl9UyeVVOuigdeElI2FXpV
app_instance_uuid = {d038490c-c22e-4057-8bc5-07f6070c83ec}
sqlalchemy.url = $db
sqlalchemy.pool_recycle=3600
set debug = true
">> $tmp
	
	vim $tmp
	
	if [ ! -e $webini ]; then
		mv $tmp $webini
	fi
}

setup_web_sh()
{
	websh=$1
	tmp=tmp.sh
	
	rm -rf $tmp
	mkdir /usr/local/var/web$game

	echo "
#!/bin/sh

. /etc/rc.subr

name=\"web$game\" 
MAX_PROC=$proc ">$tmp

	echo '
rcvar=`set_rcvar`' >> $tmp

	echo "
load_rc_config \$name

command=/usr/local/bin/paster
CONFIG=/usr/local/etc/web$game.ini
PID_DIR=/usr/local/var/web$game/
LOG_DIR=/usr/local/var/web$game/
PORT=$port

start_cmd=\"web_start\"
stop_cmd=\"web_stop\"
status_cmd=\"web_status\"">> $tmp

	echo '

web_start()
{
	i=0
    while [ $i -lt $MAX_PROC ]; do
	  http_port=`expr ${PORT} + $i`
	  pidfile=${PID_DIR}${http_port}.pid
	  logfile=${LOG_DIR}${http_port}.log
	  $command serve --daemon --log-file=$logfile --pid-file=${pidfile} ${CONFIG} http_port=${http_port}
	  i=`expr $i + 1`
	done
}

web_stop()
{
	i=0
    while [ $i -lt $MAX_PROC ]; do
	  http_port=`expr ${PORT} + $i`
	  pidfile=${PID_DIR}${http_port}.pid
	  $command serve --stop-daemon --pid-file=$pidfile
	  i=`expr $i + 1`
	done
}

web_status()
{
	i=0
    while [ $i -lt $MAX_PROC ]; do
	  http_port=`expr ${PORT} + $i`
	  pidfile=${PID_DIR}${http_port}.pid
	  $command serve --status --pid-file=$pidfile $CONFIG
	  i=`expr $i + 1`
	done
}

run_rc_command "$1"'>>$tmp
	
	chmod +x $tmp

	vim $tmp

	if [ ! -e $websh ]; then
		mv $tmp $websh
	fi
}

setup_cron()
{
    cd ${CUR_DIR}
    chmod +x update_play.sh
	cp update_play.sh /usr/local/etc/
}


main()
{
	echo "====================================================="
	echo "=      You must create db manually.                 ="
	echo "====================================================="
	
	chdir $SOURCE

	echo -n "input name: "
	read game

	if test -z $game ; then
		game=zuan_new
	fi
		
	echo "game name: \"$game\""


	echo -n "setup web ? (0 or 1): "
	read is_setup
	if test -z $is_setup ; then
		is_setup=0
	fi
	if test $is_setup -eq 1; then
		setup_web
	fi
	
	echo -n "setup crontab ? (0 or 1): "
	read is_setup
	if test -z $is_setup ; then
		is_setup=0
	fi
	if test $is_setup -eq 1; then
		setup_cron
	fi


	echo "====================================================="
	echo "=                      Fin                          ="
	echo "====================================================="
}

main
