#include "hf.h"


static void usage();
static void options_parse(int argc, const char **argv);
static void master_signal_init(sig_t func);
static void master_signal_handle(int sig);
static void uninit_app();
static void backup(Conf *conf);
static void restore(Conf *conf, const char *dir);
static void del_shm(Conf *conf);


static int opt_no_daemon = 0;
static int opt_kill = 0;
static int opt_version = 0;
static int opt_backup = 0;
static int opt_restore = 0;
static char *opt_restore_dir = NULL;
static char *opt_config = NULL;
static int opt_del_shm = 0;
static char *g_pid_file = NULL;

/* global var */
int g_opt_up_shm = 0;
int g_child_pid = 0;


int main(int argc, const char **argv)
{
	int pid = 0;
	Conf *c = NULL;


	setlocale(LC_ALL, LOCALE);

	options_parse(argc, argv);
	if (opt_version) {
		fprintf(stderr, "%s\nconfigure:\n%s\n", PACKAGE_STRING, HFD_CONFIGURE_OPTIONS);
		return 1;
	}
	if (!opt_config) {
		usage();
		return 1;
	}

	/* 
	 * parse config file
	 */
	if (!(c = conf_new(opt_config))) {
		fprintf(stderr, "config file '%s' parse error.\n", opt_config);
		return 1;
	}

	/* 
	 * build pid file
	 */
	g_pid_file = (char *)build_file_path(c->core.work_dir, PACKAGE_NAME".pid");
	if (g_pid_file == NULL) {
		fprintf(stderr, "Failed to build pid file %s\n", g_pid_file);
		return 0;
	}
	g_pid_file = strdup(g_pid_file);

	/*
	 * old process is runing ?
	 */
	pid = read_pid(g_pid_file);

	if(opt_kill) {
		if(pid > 0 && kill(pid, SIGTERM) == -1) {
			fprintf(stderr, "PID %d not exist: %s\n", pid, error_string());
			remove_file(g_pid_file);
			return 0;
		}
		return 0;
	} 

	if(opt_backup) {
		backup(c);
		return 0;
	}

	if (opt_restore) {
		restore(c, opt_restore_dir);
		return 0;
	}

	if (opt_del_shm) {
		if (pid > 0)
			kill(pid, SIGTERM);
		del_shm(c);
		return 0;
	}

	if(pid > 0) {
		fprintf(stderr, "%s(%d) is runing.\n", PACKAGE_NAME, pid);
		return 1;
	}

	/*
	 * goto daemon 
	 */
	if (opt_no_daemon == 0) {
		create_daemon(PACKAGE_NAME, c->core.work_dir);
	}

	master_signal_init(master_signal_handle);

	write_pid(g_pid_file, getpid());

	if (opt_no_daemon) {
		worker_loop(c);
		/* not reached */
		return 0;
	}

	/* 
	 * worker  mode
	 */
	g_child_pid = spawn(worker_loop, c);

	/* 
	 * monitor child
	 */
	child_monitor(PACKAGE_NAME, c);

	uninit_app();

	return 0;
}

static void uninit_app()
{
	fprintf(stderr, "%s: exit and kill child %d\n", __func__, g_child_pid);

	kill(g_child_pid, SIGTERM);

	remove_file(g_pid_file);

	exit(0);
}


static void master_signal_handle(int sig)
{
	if (SIGINT == sig) {
		uninit_app();
		return;
	}
	else if (SIGTERM == sig) {
		uninit_app();
		return;
	}
}

static void usage()
{
	printf ("Usage: %s [options] config\n" 
		"Options: \n"
		"     -n             No daemon mode.\n"
		"     -h             Print help information\n"
		"     -k             Kill process\n"
		"     -b             Backup all data.\n"
		"     -r dirname     Restore data from dirname.\n"
		"     -d             Delete share mem.\n"
		"     -v             Print version.\n"
		"     -u             Update sdb data struct\n",
	   	PACKAGE_NAME);
	exit(0);
}


static void options_parse(int argc, const char **argv)
{
	int i = 0;

	if (argc == 1)
		usage();

	for (i = 1;  i < argc; i++) {
		if (!strcasecmp(argv[i], "-n")) {
			opt_no_daemon = 1;
		} 
		else if (!strcasecmp(argv[i], "-h")) {
			usage();
			return;
		} 
		else if(!strcasecmp(argv[i], "-k")) {
			opt_kill = 1;
		} 
		else if (!strcasecmp(argv[i], "-v")) {
			opt_version = 1;
		}
		else if (!strcasecmp(argv[i], "-b")) {
			opt_backup = 1;
		} 
		else if (!strcasecmp(argv[i], "-r")) {
			opt_restore = 1;
			i++;
			opt_restore_dir = strdup_safe(argv[i]);
		}
		else if (!strcasecmp(argv[i], "-d")) {
			opt_del_shm = 1;
		}	
		else if (!strcasecmp(argv[i], "-u")) {
			g_opt_up_shm = 1;
		}
		else if (i == argc - 1) {
			opt_config = strdup_safe(argv[i]);
		}	
		else {
			fprintf(stderr, "%s: unknown options '%s'", __func__, argv[i]);
			break;
		}
	}
}



static void master_signal_init(sig_t func)
{
	do_signal(SIGINT, func,  SA_NODEFER | SA_RESETHAND | SA_RESTART);
	do_signal(SIGTERM, func, SA_NODEFER | SA_RESETHAND | SA_RESTART);
	do_signal(SIGCHLD, func, SA_NODEFER | SA_RESETHAND | SA_RESTART);
	do_signal(SIGUSR1, func, SA_NODEFER | SA_RESETHAND | SA_RESTART);
	do_signal(SIGUSR2, func, SA_NODEFER | SA_RESETHAND | SA_RESTART);
	do_signal(SIGPIPE, SIG_IGN, SA_RESTART);
}

static void backup(Conf * conf)
{
	if (!conf)
		return;

	Cycle *c = NULL;
	int i = 0;
	int offset = 0;
	int fd = -1;
	char dir[MAX_BUFFER];
	char path[MAX_BUFFER];
	char path1[MAX_BUFFER];
	time_t now = time(NULL);
    SdbInfo *info = NULL;


	if (!(c = cycle_new()))
		return;
	c->conf = conf;
	if (!cycle_load_shm(c))
		return;

	for(i = 0; i < SDB_ALL - 1; i++) {
		snprintf(dir, MAX_BUFFER - 1, "%s/sdb/%s", conf->core.work_dir, format_time(now, "%Y"));
		create_dirs(dir);

        info = &g_sdb_info[i + 1];

		snprintf(path, MAX_BUFFER - 1, "%s/%s.sdb.bak", dir, info->name);

		snprintf(path1, MAX_BUFFER - 1, "%s/%s.sdb", dir, info->name);

		if(-1 == (fd = open(path, O_WRONLY | O_CREAT))) {
			perror("failed to open path");
			break;
		}
		for(offset = 0; offset < c->sdb_shm[i].size; ) {
			int sz = c->sdb_shm[i].size - offset > MAX_BUFFER * 2 ? MAX_BUFFER * 2 : c->sdb_shm[i].size - offset;
			int n = -1;

			if ((n = write(fd, c->sdb_shm[i].ptr + offset, sz)) <= 0) {
				break;
			}
			offset += n;
		}
		close(fd);

        rename(path, path1);

		fprintf(stderr, "backup shm %d to %s, size %d\n", i, path, offset);
	}
}


static void restore(Conf *conf, const char *dir) 
{
	if (!(dir && conf))
		return;

	Cycle *c = NULL;
	int i = 0;
	int offset = 0;
	int fd = -1;
	char path[MAX_BUFFER];
	static dstring dst = DSTRING_INITIAL;
	char buf[MAX_BUFFER];
    SdbInfo *info = NULL;


	if (!(c = cycle_new()))
		return;
	c->conf = conf;

	if (!cycle_load_shm(c))
		return;

	for(i = 0; i < SDB_ALL - 1; i++) {

		dstring_clear(&dst);
		
        info = &g_sdb_info[i + 1];
		
        snprintf(path, MAX_BUFFER - 1, "%s/%s.sdb", dir, info->name);

		if(-1 == (fd = open(path, O_RDONLY))) {
			perror("failed to open path");
			break;
		}


		for(offset = 0; offset < c->sdb_shm[i].size; ) {
			int n = -1;

			if ((n = read(fd, buf, MAX_BUFFER)) <= 0) {
				break;
			}
			offset += n;
			
			dstring_append(&dst, buf, n);
		}

		if(shmem_set(&c->sdb_shm[i], dst.buf, dst.offset)) 
			fprintf(stderr, "restore shm %d from %s, size %d\n", i, path, dst.offset);
		else 
			fprintf(stderr, "failed to restore shm %d from %s, size %d\n", i, path, dst.offset);

		close(fd);

	}
}

static void del_shm(Conf *conf) 
{
	if (!conf)
		return;

	Cycle *c = NULL;
	int i = 0;

	if (!(c = cycle_new()))
		return;

	c->conf = conf;
	if (!cycle_load_shm(c))
		return;

	for(i = 0; i < SDB_ALL - 1; i++) {

		shmem_remove(&c->sdb_shm[i]);

		fprintf(stderr, "del shm %d\n", c->sdb_shm[i].sid);
	}
}

