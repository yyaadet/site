#!/bin/sh

. /etc/rc.subr

name="webhanfeng"
rcvar=`set_rcvar`
load_rc_config $name

: ${webhanfeng_proc="6"}

command=/usr/local/bin/paster
CONFIG=/usr/local/etc/webhanfeng.ini
PID_DIR=/usr/local/var/
LOG_DIR=/usr/local/var/
MAX_PROC=1


start_cmd="web_start"
stop_cmd="web_stop"
status_cmd="web_status"

web_start()
{
	$command setup-app $CONFIG
	i=0
    while [ $i -lt $MAX_PROC ]; do
	  if [ $i -eq 0 ]; then
	     appname=main$tail
	     apppid=${PID_DIR}${name}.pid
	     applog=${LOG_DIR}${name}.log
      else
	     appname=main$i
	     apppid=${PID_DIR}${name}$i.pid
	     applog=${LOG_DIR}${name}$i.log
      fi
	    
	  if [ $i -eq 0 ]; then
	     $command serve --daemon --log-file=$applog --pid-file=$apppid ${CONFIG} 
      else
	     $command serve --daemon --server-name=$appname --log-file=$applog --pid-file=$apppid ${CONFIG}
	  fi
	  i=`expr $i + 1`
	done
}

web_stop()
{
	i=0
    while [ $i -lt $MAX_PROC ]; do
	  if [ $i -eq 0 ]; then
		apppid=${PID_DIR}${name}.pid
	  else
		apppid=${PID_DIR}${name}$i.pid
      fi
	  $command serve --stop-daemon --pid-file=$apppid
	  i=`expr $i + 1`
	done
}

web_status()
{
	i=0
    while [ $i -lt $MAX_PROC ]; do
	  if [ $i -eq 0 ]; then
		apppid=${PID_DIR}${name}.pid
	  else
		apppid=${PID_DIR}${name}$i.pid
      fi
	  $command serve --status --pid-file=$apppid $CONFIG
	  i=`expr $i + 1`
	done
}

run_rc_command "$1"
