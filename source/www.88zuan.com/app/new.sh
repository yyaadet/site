
#!/bin/sh

. /etc/rc.subr

name="webzuan_new" 
MAX_PROC=1 

rcvar=`set_rcvar`

load_rc_config $name

HOME=/root/sites/zuan_new/app
command=/usr/local/bin/paster
CONFIG=$HOME/new.ini
PID_DIR=/usr/local/var/webzuan/
LOG_DIR=/usr/local/var/webzuan/
PORT=8009

start_cmd="web_start"
stop_cmd="web_stop"
status_cmd="web_status"


web_start()
{
	/usr/bin/cd $HOME
	i=0
    while [ $i -lt $MAX_PROC ]; do
	  http_port=`expr ${PORT} + $i`
	  pidfile=${PID_DIR}${http_port}.pid
	  logfile=${LOG_DIR}${http_port}.log
	  $command serve --daemon --log-file=$logfile --pid-file=${pidfile} ${CONFIG}
	  i=`expr $i + 1`
	done
}

web_stop()
{
	/usr/bin/cd $HOME
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

run_rc_command "$1"
