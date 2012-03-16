#!/bin/sh

CUR_DIR=`pwd`
PYTHON=/usr/local/python25/bin/python
SOURCE=${CUR_DIR}/sources
INSTALL=/usr/bin/install
EASY_INSTALL=/usr/local/python25/bin/easy_install
game=member

setup_web()
{
	echo "setup web ... "
	webini=/home/sites/uwsgi-member.ini
	websh=/etc/init.d/uwsgi-member

        cp -rf member /home/sites
        cd /home/sites/member
        $PYTHON setup.py develop

        cd $CUR_DIR

	if [ ! -e $webini ]; then
		setup_web_config $webini
	fi
	
	if [ ! -e $websh ]; then
		setup_web_sh $websh
	fi
}


setup_web_config()
{
	webini=$1
        cp uwsgi-member.ini $webini
}

setup_web_sh()
{
	websh=$1
        cp uwsgi-member $websh
}


setup_db()
{
	echo "setup db ... "
        
        mysql -uroot -p < member/sql/member.sql
}

main()
{
	echo "====================================================="
	echo "=      You must create db manually.                 ="
	echo "====================================================="
	
		
	echo "name: \"$game\""


	echo -n "setup web ? (0 or 1): "
	read is_setup
	if test -z $is_setup ; then
		is_setup=0
	fi
	if test $is_setup -eq 1; then
		setup_web
	fi
	
	echo -n "setup db ? (0 or 1): "
	read is_setup
	if test -z $is_setup ; then
		is_setup=0
	fi
	if test $is_setup -eq 1; then
		setup_db
	fi
	echo "====================================================="
	echo "=                      Fin                          ="
	echo "====================================================="
}

main
