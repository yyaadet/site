#!/bin/sh

. /etc/rc.subr

name="hfd"
rcvar=`set_rcvar`
command="/usr/local/sbin/hfd"
command_args="/usr/local/etc/hfd.ini"

extra_commands="rmshm upshm backup"
prestart_cmd="prestart"
start_cmd="start"
stop_cmd="stop"
status_cmd="status"
restart_cmd="restart"
rmshm_cmd="rmshm"
upshm_cmd="upshm"
backup_cmd="backup"
SHMMAX=419430400
SHMALL=102400



start()
{
	shmmax=`sysctl -n kern.ipc.shmmax`
	shmall=`sysctl -n kern.ipc.shmall`
	if [ $shmmax -lt $SHMMAX ]; then
		sysctl kern.ipc.shmmax=$SHMMAX
	fi
	if [ $shmall -lt $SHMALL ]; then
		sysctl kern.ipc.shmall=$SHMALL
	fi
	echo "Start ${name}"
	${command} ${command_args}
}

stop()
{
	${command} -k ${command_args}
	echo "Stop $name"
	i=1
	while [ `pgrep $name | wc -l` -gt 0 ]; do
		echo -n "."
		i=`expr $i + 1`
		sleep 1
	done
	echo ".($i)"
}

status()
{
	echo "`pgrep $name`"
}


restart() 
{
	stop
	start
}

backup()
{
	${command} -b ${command_args}
}

rmshm() 
{
	${command} -d ${command_args}
}

upshm()
{
	stop
	backup
	${command} -u ${command_args}
}

load_rc_config $name
run_rc_command "$1"
