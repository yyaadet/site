
WORK_DIR=/usr/local/hfd
CONFIG=/usr/local/etc/hfd.ini

install:
	if [ ! -e $(CONFIG) ] ;then \
		$(INSTALL) -v hfd.ini /usr/local/etc; \
	fi 
	/bin/chmod +x *.sh
	$(mkinstalldirs) $(WORK_DIR)
	$(INSTALL) hfd.sh  /usr/local/etc/rc.d
	$(INSTALL_DATA) ai.lua  $(WORK_DIR)
	$(INSTALL_DATA) map.bmp $(WORK_DIR)
	$(INSTALL) stage_map.bmp ${WORK_DIR}
