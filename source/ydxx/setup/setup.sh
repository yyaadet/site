#!/bin/sh

CUR_DIR=`pwd`
PYTHON=/usr/local/python25/bin/python
SOURCE=${CUR_DIR}/sources
INSTALL=/usr/bin/install
EASY_INSTALL=/usr/local/python25/bin/easy_install
game=
proc=

mkdir -p /home/sites
mkdir -p /home/web_cache
mkdir -p /home/server
mkdir -p /home/web_log

setup_web()
{
	echo "setup web ... "

        cd $CUR_DIR

	webini=/home/sites/web$game.ini
	websh=/etc/init.d/web$game.sh

        cp -rf $SOURCE/webhanfeng /home/sites/
        cd /home/sites/webhanfeng
        $PYTHON setup.py develop

	if [ ! -e $webini ]; then
		setup_web_config $webini
	fi

	if [ ! -e $websh ]; then
		setup_web_sh $websh
	fi
}


setup_web_config()
{
	cp web.ini $1
}

setup_web_sh()
{
	cp uwsgi-web $1
}

setup_server()
{
	echo "setup server ... "
        
        cd $CUR_DIR

	srvini=/home/server/$game.ini
	srvsh=/etc/init.d/$game
	workdir=/home/server/$game

	if [ ! -e $srvini ] ;then  
		setup_server_config  $workdir $srvini
	fi

	$INSTALL -c $SOURCE/hfd /usr/local/sbin/$game

	$INSTALL -d $workdir
	
	if [ ! -e $srvsh ] ;then  
		setup_server_sh $srvsh $srvini $workdir/hfd.pid
	fi

	$INSTALL -c $SOURCE/ai.lua $workdir/ai.lua
	$INSTALL -c $SOURCE/map.bmp $workdir/map.bmp
	$INSTALL -c $SOURCE/stage_map.bmp $workdir/stage_map.bmp

	echo -n "input share mem size (M): "
	read shmsize
	if test -z $shmsize ; then
		shmsize=`expr 500 '*' 1024 '*' 1024`
	else
		shmsize=`expr $shmsize '*' 1024 '*' 1024`
	fi
	
	shmmax=`sysctl -n kernel.shmmax`
	
	shmall=`sysctl -n kernel.shmall`

	if [ $shmmax -lt $shmsize ]; then
		sysctl kernel.shmmax=$shmsize
	fi

	if [ $shmall -lt $shmsize ]; then
		sysctl kernel.shmall=$shmsize
	fi
}

setup_server_config()
{
	workdir=$1
	srvini=$2
	cp server.ini $srvini
}

setup_server_sh()
{
	srvsh=$1
	srvini=$2
	pidfile=$3

	cp server $srvsh
}


main()
{
	echo "====================================================="
	echo "=      You must create db manually.                 ="
	echo "====================================================="
	
	cd $SOURCE
	chmod +x hfd

	echo -n "input game name: "
	read game

	if test -z $game ; then
		game=ydxx
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

	echo -n "Setup server? (0 or 1): "
	read is_setup
	if test -z $is_setup ; then
		is_setup=0
	fi
	if test $is_setup -eq 1; then
		setup_server
	fi

	echo "====================================================="
	echo "=                      Fin                          ="
	echo "====================================================="
}

main
