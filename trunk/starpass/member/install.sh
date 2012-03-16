#!/bin/sh

INSTALL=/usr/bin/install
EASY_INSTALL=/usr/local/bin/easy_install
PYTHON=/usr/local/bin/python

$INSTALL script/member.sh /usr/local/etc/rc.d/
/usr/local/etc/rc.d/member.sh stop && /bin/rm -vrf /usr/local/lib/python2.5/site-packages/member*
if [ ! -p /usr/local/etc/member.ini ]; then
	$INSTALL script/member.ini /usr/local/etc
fi
/bin/rm -rf dist
$PYTHON setup.py bdist_egg
$EASY_INSTALL dist/*.egg
chdir /
/usr/local/etc/rc.d/member.sh start

