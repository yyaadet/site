sbin_PROGRAMS=hfd

INCLUDES=-I/usr/include -I/usr/local/include

hfd_SOURCES=\
				  luaapi.c \
				  master.c \
				  worker.c \
				  ini.c \
				  http.c \
				  tools.c \
				  ev.c \
				  logging.c \
				  cycle.c \
				  conf.c \
				  conn.c \
				  game.c \
				  request.c \
				  webapi.c \
				  city.c \
				  general.c \
				  army.c \
				  gametime.c \
				  diplomacy.c \
				  sphere.c \
				  treasure.c \
				  ai.c \
				  mail.c \
				  flexsecure.c \
				  user.c \
				  cmd.c \
				  map.c \
				  bitmap.c \
				  sdb.c \
				  sdb1.c \
				  xalloc.c \
				  dstring.c \
				  pool.c \
				  reason.c \
				  shm.c \
				  flow.c \
				  talk.c \
				  wubao.c \
				  up.c \
				  trade.c \
				  task.c \
				  box.c \
				  sdb2.c \
				  mem.c \
				  cron.c \
				  room.c

hfd_LDFLAGS=-L/usr/local/lib -L/usr/lib

hfd_LDADD=-lm -llua -levent

DEFS+=-Wall -g -O2

