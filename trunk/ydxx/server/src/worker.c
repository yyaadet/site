#include "hf.h"

static void worker_signal_init(sig_t func);
static void worker_signal_handle(int sig);



int g_exit_code = 0;


void worker_loop(void *arg)
{
	Conf *c = (Conf *) arg;
	const char *t = NULL;
	int log_fd = -1;


	if (!c) 
		return ;
	
	if (!cache_pool_init()) {
		return ;
	}
	
	t = build_file_path(c->core.work_dir, PACKAGE_NAME".log");
	if (!logging_init(t, c->core.log_level)) {
		goto error;
	}

	if ((log_fd = logging_fd()) > -1) {
		dup2(log_fd, STDOUT_FD);
		dup2(log_fd, STDERR_FD);
	}
	
	if (!(g_cycle = cycle_new())) {
		goto error;
	}
	g_cycle->conf = c;

	worker_signal_init(worker_signal_handle);

	if (!cycle_load_shm(g_cycle)){
		ERROR(LOG_FMT"failed to load shm.\n", LOG_PRE); 
		goto error;
	}

	if (!map_init()) {
		goto error;
	}

	if (!up_init()) {
		goto error;
	}
	
	if (!lua_script_load(g_cycle->lua, c->core.lua)) {
		ERROR(LOG_FMT"failed to load lua script '%s'.\n", LOG_PRE, c->core.lua); 
		goto error;
	}

	game_init(g_cycle->game);

	DEBUG(LOG_FMT"%s is runing\n", LOG_PRE, PACKAGE_STRING);

	ev_base_loop(g_cycle->evbase, 0);

	return;

error:
	worker_exit();
}

static void worker_signal_init(sig_t func)
{
	do_signal(SIGINT, func,  SA_NODEFER | SA_RESETHAND | SA_RESTART);
	do_signal(SIGTERM, func, SA_NODEFER | SA_RESETHAND | SA_RESTART);
	do_signal(SIGUSR1, func, SA_NODEFER | SA_RESETHAND | SA_RESTART);
	do_signal(SIGUSR2, func, SA_NODEFER | SA_RESETHAND | SA_RESTART);
	do_signal(SIGPIPE, SIG_IGN, SA_RESTART);
}

static void worker_signal_handle(int sig)
{
	if (g_cycle->state == CYCLE_STOPING) 
		return;
	ERROR(LOG_FMT"receive signal \"%s\"\n",  LOG_PRE, signal_string(sig));
	if (sig == SIGTERM || sig == SIGINT) {
		worker_exit();
	} 
	else if (sig == SIGUSR1) {
	}  
}


void worker_exit()
{
	if (!g_cycle) {
		DEBUG(LOG_FMT"worker ready to exit.\n", LOG_PRE);	
		exit(0);
		return;
	}

	up_uninit();

	cycle_stop(g_cycle, 0);
}

