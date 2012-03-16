#ifndef _DEFINES_H
#define  _DEFINES_H

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

/* config */
#define CONF_CORE_SECTION "core"
#define CONF_HTTP_SECTION "http"
#define CONF_FLEX_SECTION "flex"
#define CONF_GAME_SECTION "game"

#define DEFAULT_CORE_WORK_DIR "/usr/local/hfd"
#define DEFAULT_CORE_LOG_LEVEL 2
#define DEFAULT_CORE_ADDR "0.0.0.0"
#define DEFAULT_CORE_PORT 4000
#define DEFAULT_CORE_MAX_CONNECTIONS 3000
#define DEFAULT_CORE_CHECK_GAME_TIME 5
#define DEFAULT_CORE_IP "0.0.0.0"

#define DEFAULT_HTTP_CONNECT_TIMEOUT 5
#define DEFAULT_HTTP_READ_TIMEOUT 5
#define DEFUALT_HTTP_MAX_CONCURRENT 10

#define DEFAULT_FLEX_ADDR "0.0.0.0"
#define DEFAULT_FLEX_PORT 4001

/* func */
#define safe_close(x) if(x>-1){close(x);x=-1;}
#define safe_ptr(x) (x==NULL?0:(*x))
#define safe_free(x) if(x){xfree(x);x = NULL;}
#define safe_sub(x, y) {x-=y;if(x<0)x=0;}
#define safe_add(x, y) {x+=y;if(x<0)x=0;}
#define safe_str(x) (x?x:"")
#define CHANGE_SPIRIT(n, v) { n += v; if (n > MAX_SOL_SPIRIT) n=MAX_SOL_SPIRIT;}
#define CHANGE_TRAIN(n, v) { n += v; if (n > MAX_SOL_TRAIN) n=MAX_SOL_TRAIN;}

#define ARRAY_LEN(a, t) (sizeof(a)/sizeof(t))
#define MAX(x, y) ((x) > (y) ? (x) : (y))
#define MIN(x, y) ((x) < (y) ? (x) : (y))
#define DEBUG logging_debug
#define WARN  logging_warning
#define ERROR logging_error
#define LOG_FMT "%s::%d %s: "
#define LOG_PRE __FILE__, __LINE__, __func__

/* constant */
#define true 1
#define false 0

#define GAME_END_YEAR 400
#define GAME_START_YEAR 193
#define DAY_PER_HOUR 12
#define MONTH_PER_DAY 30
#define YEAR_PER_MONTH 12

#define MAX_BUFFER 4096
#define SOCK_MAX_BUFFER 8192
#define LOG_TIME_FMT "%Y-%m-%d %H:%M:%S"
#define HTTP_READ_TIMEOUT 120
#define HTTP_CONNECT_TIMEOUT 60
#define MAX_FREE_HTTP_CONNECTION 512
#define DEFAULT_LOG_LEVEL LOGGING_WARNING
#define GAME_CONN_TIMEOUT 30
#define MAX_MSG_LEN (65535)

#define DEFAULT_SPEED 25

#define GAME_ID g_cycle->game->m_copy->m_id
#define GAME_NOW g_cycle->game->time
#define GAME g_cycle->game

#define WEBAPI_GET_ALL -1
#define GRID_PER_LI 0.25
#define GET_STEP_COUNT 128

#define MAX_SOL_TRAIN 100
#define MAX_SOL_SPIRIT 100
#define DEF_SOL_SPIRIT 50
#define CITY_SOL 16548
#define CITY_DEFENSE 100
#define HURT_RECOVER 40
#define SPIRIT_RECOVER 0.1
#define TRAIN_RECOVER 0.2

#define DEFAULT_SPHERE_FRIENDSHIP 50
#define HTTP_MAX_RETRY 3
#define SHM_FULL_PERM (SHM_W | SHM_R | IPC_CREAT)
#define SHM_RD_PERM (SHM_R)
#define ALLOC_RANDOM 0
#define MAX_X 2000
#define MAX_Y 1240
#define ZHOU_NUM 16
#define REGION_NUM 16
#define MAP_SHM_SIZE (MAX_X * MAX_Y * 4)

#define ACTION_ADD_NAME "add"
#define ACTION_DEL_NAME "del"
#define ACTION_UPDATE_NAME "edit"
#define USER_LAST_ALLOC_CITY_ID "last_alloc_city_id"
#define CMD_START_TIMESTAMP "start_timestamp"
#define CMD_END_TIMESTAMP "end_timestamp"

#define HTTP_ERR 500
#define HTTP_OK 200
#define MAX_STOP_TIME 300
#define BLANK " \r\n\t"
#define LOCALE "zh_CN.UTF-8"
#define SLEEP_AFTER_FORK 0
#define SYS_SEND_ID (-1)
#define MAX_MOVE_GENE 2
#define DEF_CITY_DEAD_SOL 5000
#define MAX_TALK_MSG_LEN 100
#define PATH_UNLIMITED -1
#define MAX_FAITH 100
#ifndef NULL
#define NULL 0
#endif

#define MAX_FD 10240
#define STDIN_FD 0
#define STDOUT_FD 1
#define STDERR_FD 2

#define WUBAO_PRES_OF_KILL 10
#define SPH_PRES_OF_KILL 200

#define PERSON_MAX_ORDER 5

#define MAX_DIPL_ENEMY_LIFE 2

#define CITY_GRID 3
#define ARMY_GRID 5

#define MAX_PRAC_NUM 100
#define EXC_PRAC_GOLD 100
#define MAX_USE_GX_TREA_NUM 1000
#define PRAC_DOUBLE_GOLD 50
#define PRAC_DOUBLE_RATE 1.5
#define MIN_SELL_GOLD 30
#define BOX_SPEED_GOLD 10

#define MAX_RANK 100
#define PK_PRE 5
#define PK_SLEEP 20
#define PK_SPEED_GOLD 20


#define REQ_CLIENT_VER 191

#define MAX_JL 40

#define DEF_TIME_FMT "%Y-%m-%d %H:%M:%S"

#define DECLARE_WAR_NUM 1
#define DEFENSE_WAR_NUM 2

//some typedefs
typedef void(*EVCB)(int, short, void *);
/* void func(const char *src, int len, void *arg, int code) */
typedef void(*HTTPCB)(const char *, int , void *, int);
typedef void(*ARGCB)(void *);
typedef void(*sig_t) (int);

typedef unsigned char byte;
typedef unsigned char bool;
typedef unsigned int uint;
typedef unsigned short ushort;
typedef unsigned long long uint64;
typedef char tinyint;
typedef unsigned char utinyint;
typedef short smallint;
typedef unsigned short usmallint;
typedef long long bigint;
typedef unsigned long long ubigint;

#endif
