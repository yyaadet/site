#!/bin/sh

#/root/sites/digg/script/saferun.sh /tmp/update_rank.pid /root/sites/digg/script/update_rank.sh

conf=/root/sites/51zhi.ini

/usr/local/python2.5/bin/paster --plugin=digg run $conf -c "from digg.model.all_table import *; update_rank()"

