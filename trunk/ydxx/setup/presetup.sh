#!/bin/sh

CUR_DIR=`pwd`
PYTHON=/usr/local/python25/bin/python
SOURCE=${CUR_DIR}/sources
INSTALL=/usr/bin/install


get_web()
{
        cp -rf ../../web/* $SOURCE
	cd ../../web/webhanfeng
	/bin/rm -rf dist build
	$INSTALL -c  script/hanfeng.sql $CUR_DIR
	$INSTALL -c  script/wubao.sql $CUR_DIR
	cd $SOURCE
}

get_server()
{
	cd ../../server
	./configure -q CFLAGS=-DNDEBUG
	make 
	cd  $SOURCE
	$INSTALL -c ../../server/scripts/ai.lua  .
	$INSTALL -c ../../server/scripts/map.bmp .
	$INSTALL -c ../../server/scripts/stage_map.bmp .
	$INSTALL -c ../../server/src/hfd .

}

main()
{
	rm -rf $SOURCE
	install -d $SOURCE

	cd $SOURCE

	echo "1: get web"
	get_web
	echo "2: get server"
	get_server

	files=`ls -l $SOURCE`

	echo ""
	echo "Get files: "
	echo "$files"

	echo "====================================================="
	echo "=                      Fin                          ="
	echo "====================================================="
}

main
