#!/bin/sh

/usr/local/bin/paster --plugin=zuan run /usr/local/etc/webzuan.ini -c "from zuan.model.flash_game import *; update_rank()"
