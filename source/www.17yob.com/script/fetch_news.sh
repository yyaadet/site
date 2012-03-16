#!/bin/bash

#crontab
#1       */1       *     *       *       /root/sites/digg/script/saferun.sh /tmp/fetch_news.pid /root/sites/digg/script/fetch_news.sh

. utils.sh

debug "start"

conf=/root/sites/17yob.ini

/usr/local/python2.5/bin/paster --plugin=feed run $conf -c "from feed.lib.rss import *; fetch_news()"

debug "done"
