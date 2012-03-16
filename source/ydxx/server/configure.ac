#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ(2.62)
AC_INIT(hfd, 2.0, yyaadet2002@gmail.com)
AC_CONFIG_SRCDIR([src/master.h])
AC_CONFIG_HEADER([src/config.h])
AM_INIT_AUTOMAKE

# Checks for programs.
AC_PROG_CXX
AC_PROG_CC

AC_ARG_WITH(gametime, 
			[AS_HELP_STRING(--with-gametime, Game Time. Default is 20 seconds)], 
			[AC_DEFINE_UNQUOTED(GAME_HOUR_PER_SEC, $with_gametime, "")],
			[AC_DEFINE_UNQUOTED(GAME_HOUR_PER_SEC, 20, "")])

AC_ARG_WITH(allowexit, 
			[AS_HELP_STRING(--with-allowexit, Allow exit game. Default is no.)], 
			[AC_DEFINE_UNQUOTED(ALLOW_EXIT_GAME, $with_allowexit, "")],
			[AC_DEFINE_UNQUOTED(ALLOW_EXIT_GAME, 0, "")])

AC_ARG_WITH(stringfactor, 
			[AS_HELP_STRING(--with-stringfacotr, Dstring increasement factor. Default is 1.25.)], 
			[AC_DEFINE_UNQUOTED(DSTRING_INCR_FACTOR, $with_stringfactor, "")],
			[AC_DEFINE_UNQUOTED(DSTRING_INCR_FACTOR, 1.25, "")])

AC_DEFINE_UNQUOTED(HFD_CONFIGURE_OPTIONS, "$ac_configure_args", [configure command line used to configure Sgd])

# Checks for libraries.
AC_CHECK_LIB([event], [event_init])

# Checks for header files.
AC_HEADER_STDC
AC_HEADER_SYS_WAIT
AC_CHECK_HEADERS([arpa/inet.h \
				  fcntl.h \
				  netinet/in.h \
				  stdlib.h \
				  string.h \
				  sys/socket.h \
				  sys/time.h \
				  syslog.h \
				  unistd.h \
				  assert.h \
				  signal.h \
				  time.h \
				  sys/resource.h \
				  execinfo.h])

# Checks for typedefs, structures, and compiler characteristics.
AC_HEADER_STDBOOL
AC_C_CONST
AC_TYPE_PID_T
AC_TYPE_SIZE_T
AC_HEADER_TIME
AC_STRUCT_TM


# Checks for library functions.
AC_FUNC_ERROR_AT_LINE
AC_FUNC_FORK
AC_TYPE_SIGNAL
AC_FUNC_STAT
AC_FUNC_STRFTIME
AC_FUNC_VPRINTF
AC_FUNC_WAIT3
AC_CHECK_FUNCS([memmove mkdir socket strcasecmp strchr strdup strndup strerror strrchr strstr strtol errno exit])


AC_OUTPUT([Makefile src/Makefile scripts/Makefile])
