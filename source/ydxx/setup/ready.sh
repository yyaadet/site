#!/bin/sh

dir=`pwd`
PYTHON=/usr/local/python25/bin/python

install_libevent()
{
	echo -n "Install libevent (0:no, 1:yes) ? :"
	read is_setup
	if test ! $is_setup; then
		is_setup=0
	fi
	if test $is_setup -eq 1 ; then
		tar -zxf libevent-1.4.14b-stable.tar.gz && cd libevent-1.4.14b-stable
                ./configure && make
		make install clean
		cd $dir
	fi
}

install_nginx()
{
	echo -n "Install nginx (0:no, 1:yes) ? :"
	read is_setup
	if test ! $is_setup; then
		is_setup=0
	fi
	if test $is_setup -eq 1 ; then
                cp nginx.repo /etc/yum.repos.d
                yum install nginx
		cd $dir
	fi
}

install_python()
{
	echo -n "Install python (0:no, 1:yes) ? :"
	read is_setup
	if test ! $is_setup; then
		is_setup=0
	fi
	if test $is_setup -eq 1 ; then
		tar jxf Python-2.5.tar.bz2 && cd Python-2.5
		./configure --prefix=/usr/local/python25/ && make && make install clean
		cd $dir
	fi
}


install_setuptool()
{
	echo -n "Install setuptool (0:no, 1:yes) ? :"
	read is_setup
	if test ! $is_setup; then
		is_setup=0
	fi
	if test $is_setup -eq 1 ; then
                yum install zlib-devel
                tar zxf  setuptools-0.6c11.tar.gz
                cd setuptools-0.6c11
                /usr/local/python25/bin/python setup.py install
                cd $dir
	fi
}

install_uwsgi()
{
	echo -n "Install uwsgi (0:no, 1:yes) ? : "
	read is_setup
	if test ! $is_setup; then
		is_setup=0
	fi
	if test $is_setup -eq 1 ; then
                yum install libxml2-devel
                tar zxf uwsgi-1.0.4.tar.gz
                cd uwsgi-1.0.4
                cp ../Makefile .
                make 
                cp uwsgi /usr/bin/
                cd $dir
	fi
}

install_mysql()
{
	echo -n "Install mysql (0:no, 1:yes) ? :"
	read is_setup
	if test ! $is_setup; then
		is_setup=0
	fi
	if test $is_setup -eq 1 ; then
                yum install mysql-devel

		echo "mysql_dbdir=/usr/var/db/mysql" >> /etc/rc.conf
		echo "mysql_enable=YES" >> /etc/rc.conf
		mkdir -p /usr/var/db/mysql

		echo "mysqladmin -u root password 'newpasswd'"
		echo "GRANT ALL PRIVILEGES ON *.* TO 'myuser'@'%' IDENTIFIED BY 'mypasswd' WITH GRANT OPTION; FLUSH PRIVILEGES;"

                /usr/local/python25/bin/easy_install mysql-python==1.2.3
		
		if ! test -f /etc/my.cnf ; then
			cp -rf /usr/local/share/mysql/my-medium.cnf /etc/my.cnf
		fi
	fi
}

install_lua()
{
	echo -n "Install lua (0:no, 1:yes) ? :"
	read is_setup
	if test ! $is_setup; then
		is_setup=0
	fi
	if test $is_setup -eq 1 ; then
                yum install lua-devel
	fi
}

install_db()
{
	echo -n "Install db (0:no, 1:yes) ? :"
	read is_setup
	if test ! $is_setup; then
		is_setup=0
	fi
	if test $is_setup -eq 1 ; then
		cd $dir
		echo -n "input mysql host: "
		read host

		echo -n "input username: "
		read username
		
		echo -n "input password: "
		read password 
	
		echo -n "input db name: "
		read dbname

		sql="CREATE DATABASE $dbname DEFAULT CHARACTER SET utf8;"
		echo $sql  | mysql -h $host --default-character-set=utf8 -f --user=$username --password=$password
                mysql -h $host --default-character-set=utf8 -f --user=$username --password=$password $dbname < hanfeng.sql
		mysql -h $host --default-character-set=utf8 -f --user=$username --password=$password $dbname < wubao.sql
	fi
}

main()
{
	install_libevent
	install_nginx
	install_python
	install_setuptool
	install_pil
        install_uwsgi
	install_mysql
        install_lua
	install_db
}

main
