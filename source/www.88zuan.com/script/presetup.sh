#!/bin/sh

CUR_DIR=`pwd`
PYTHON=/usr/local/bin/python
SOURCE=${CUR_DIR}/sources
INSTALL=/usr/bin/install


get_web()
{
	chdir ../../app
	/bin/rm -rf dist build
	$PYTHON setup.py -q bdist_egg
	$INSTALL -c  dist/*.egg $SOURCE
	chdir $SOURCE
}

main()
{
	rm -rf $SOURCE
	install -d $SOURCE

	chdir $SOURCE

	echo "1: get web"
	get_web

	files=`ls -l $SOURCE`

	echo ""
	echo "Get files: "
	echo "$files"

	echo "====================================================="
	echo "=                      Fin                          ="
	echo "====================================================="
}

main
