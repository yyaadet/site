#include "hf.h"



RB_GENERATE(KeyMap, Key, tlink, key_comp);

RB_GENERATE(NameMap, Name, tl, name_cmp);

Key * key_new(int id)
{
	Key *k = (Key *) cache_pool_alloc(POOL_KEY);
	if (!k) 
		return NULL;
	k->id = id;
	return k;
}

Key * key_new1(int id, void *arg)
{
    Key *k = key_new(id);

    if (!k)
        return NULL;
    k->arg = arg;

    return k;
}

void key_free(Key *k)
{
	if (!k)
		return;
	cache_pool_free(POOL_KEY, k);
}


KeyList *key_list_new(KEYCMP cmp)
{
	KeyList *kl = NULL;


	if (!(kl = xmalloc(sizeof(KeyList))))
		return NULL;

	TAILQ_INIT(&kl->keys);
	kl->cmp = cmp;
	kl->num = 0;

	return kl;
}

void key_list_init(KeyList *kl, KEYCMP cmp)
{
	if (!kl)
		return;
	
	TAILQ_INIT(&kl->keys);
	kl->cmp = cmp;
	kl->num = 0;
}


void key_list_free(KeyList *kl)
{
	if(!kl)
		return ;

	Key *k, *t;

	TAILQ_FOREACH_SAFE(k, &kl->keys, link, t) {
		TAILQ_REMOVE(&kl->keys, k, link);
		key_free(k);
	}

	free(kl);
}

bool key_list_add(KeyList *kl, Key *k)
{
	if (!(kl && k))
		return false;
	
	Key *t = NULL;

	if (kl->cmp == NULL) {
		TAILQ_INSERT_TAIL(&kl->keys, k, link);
		kl->num++;
		return true;
	}

	if (TAILQ_EMPTY(&kl->keys)) {
		TAILQ_INSERT_TAIL(&kl->keys, k, link);
		kl->num++;
		return true;
	}

	TAILQ_FOREACH(t, &kl->keys, link) {
		if (kl->cmp(t, k) <= 0) {
			TAILQ_INSERT_BEFORE(t, k, link);
			return true;
		}
	}

	TAILQ_INSERT_TAIL(&kl->keys, k, link);
	kl->num++;

	return true;
}

bool key_list_del(KeyList *kl, Key *k)
{
	if (!(kl && k))
		return false;

	TAILQ_REMOVE(&kl->keys, k, link);
	kl->num--;
	return true;
}

Key * key_list_get(KeyList *kl, int id) 
{
	if (!kl)
		return NULL;

	Key *t = NULL;
	
	TAILQ_FOREACH(t, &kl->keys, link) {
		if (t->id == id)
			return t;
	}

	return NULL;
}

int key_comp(Key *k1, Key *k2)
{
	return (k1->id - k2->id);
}


Name *name_new(const char *c)
{
	if (!c)
		return NULL;

	Name *n = (Name *) cache_pool_alloc(POOL_NAME);

	if (!n)
		return NULL;
	dstring_set(&n->c, c);
	return n;
}

void name_free(Name *n)
{
	if (!n)
		return;
	cache_pool_free(POOL_NAME, n);
}

int name_cmp(Name *n1, Name *n2)
{
	return (strcmp(n1->c.buf, n2->c.buf));
}

TwoArg *two_arg_new(void *arg1, void *arg2)
{
	TwoArg *t = (TwoArg *) cache_pool_alloc(POOL_TWO_ARG);
	if (!t) 
		return NULL;
	t->m_arg1 = arg1;
	t->m_arg2 = arg2;
	return t;
}

void two_arg_free(TwoArg *targ)
{
	if (!targ)
		return;
	cache_pool_free(POOL_TWO_ARG, targ);
}

Pos *pos_new(unsigned short x, unsigned short y)
{
	Pos *p = (Pos *) cache_pool_alloc(POOL_POS);
	if (!p) 
		return NULL;
	p->x = x;
	p->y = y;
	return p;
}
void pos_free(Pos *p)
{
	if (!p)
		return;
	cache_pool_free(POOL_POS, p);
}


TimePos *time_pos_new(Pos *from, Pos *to, double sec)
{
	unsigned short x, y ;
	TimePos *tp = (TimePos *) cache_pool_alloc(POOL_TIME_POS);
	if (!tp) 
		return NULL;
	x = y = 0;
	if (from) {
		x = from->x;
		y = from->y;
	}
	tp->from = pos_new(x, y);
	x = y = 0;
	if (to) {
		x = to->x;
		y = to->y;
	}
	tp->to = pos_new(x, y);
	tp->sec = sec;
	TAILQ_ENTRY_INIT(&tp->link);
	return tp;
}

void time_pos_free(TimePos *tp)
{
	if (!tp)
		return;
	pos_free(tp->from);
	tp->from = NULL;
	pos_free(tp->to);
	tp->to = NULL;
	cache_pool_free(POOL_TIME_POS, tp);
}


Entry *entry_new(const char *name, const char *value)
{
	Entry * entry = (Entry *) xmalloc(sizeof(Entry));

	if (!entry) 
		return NULL;

	dstring_clear(&entry->name);
	dstring_clear(&entry->value);
	if (name)
		dstring_set(&entry->name, name);
	if (value)
		dstring_set(&entry->value, value);
	
	return entry;
}

void entry_free(Entry *entry)
{
	safe_free(entry);
}


void do_signal(int sig, sig_t func, int flags)
{
#if HAVE_SIGACTION
	struct sigaction sa; 
	sa.sa_handler = func;
	sa.sa_flags = flags;
	sigemptyset(&sa.sa_mask);
	if (sigaction(sig, &sa, NULL) < 0) 
		g_cycle->m_logger->warning("sigaction: sig=%d func=%p: %s\n", sig, func, strerror(errno));
#else
	signal(sig, func);
#endif
}

const char *signal_string(int sig) 
{
	switch (sig) {
		case SIGTERM:
			return "SIGTERM";
		case SIGINT:
			return "SIGINT";
		case SIGPIPE:
			return "SIGPIPE";
		case SIGCHLD:
			return "SIGCHLD";
		case SIGILL:
			return "SIGILL";
		case SIGABRT:
			return "SIGABRT";
		case SIGFPE:
			return "SIGFPE";
		case SIGSEGV:
			return "SIGSEGV";
		case SIGUSR1:
			return "SIGUSR1";
		case SIGUSR2:
			return "SIGUSR2";
		default:
			return "SIGNONE";
	}
	return "SIGNONE";
}

#ifndef HAVE_STRNDUP
char *strndup(const char *src, int len)
{
	char *ret = NULL;

	ret = (char *) xmalloc(len + 1);
	memcpy(ret, src, len);
	ret[len] = '\0';

	return ret;
}
#endif


char *strdup_safe(const char *src)
{
	int len = 0;
	char *dst = NULL;

	if (!src)
		return NULL;
	len = strlen(src);
	dst = (char *)xmalloc(len + 1);
	if (!dst) {
		return NULL;
	}
	memcpy(dst, src, len);
	dst[len] = '\0';
	return dst;
}

int strlen_safe(const char *src)
{
	if (!src) return 0;
	return strlen(src);
}


const dstring * read_line(const char *src, int len)
{
	int line_len = 0;
	char *t = NULL;
	static dstring dst = DSTRING_INITIAL;

	if (! src)
		return NULL;
	dstring_clear (&dst);
	if ((t = strchr(src, '\n')) == NULL) {
		return NULL;
	}
	line_len = t - src + 1;
	dstring_append(&dst, src, line_len);
	return (&dst);
}

int remove_blank(char *src, int len)
{
	int end = 0;
	int begin = 0;
	
	if (!src)
		return 0;
	end = len;
	while(*(src + end - 1) == ' ' || *(src + end - 1) == '\r' 
		|| *(src + end - 1) == '\n') 
		end -= 1;
	while(*(src + begin) == ' ' || *(src + begin) == '\r' 
		|| *(src + begin) == '\n')
		begin += 1;
	memmove((char *)src, src + begin, end - begin);
	src[end - begin ] = '\0';
	return (end - begin);
}

char *strip(const char *src, const char *chs)
{
	size_t start_index = 0;
	size_t end_index = 0;
	char *new_src = NULL;

	if (src == NULL || strlen(src) == 0)
		return NULL;
	while(strchr(chs, src[start_index])) start_index++;

	end_index = strlen(src);
	while(strchr(chs, src[end_index - 1])) end_index--;

	if (end_index > start_index) {
		new_src = (char *) xmalloc(end_index - start_index + 1);
		if (!new_src) {
			return NULL;
		}
		memcpy(new_src, src + start_index, end_index - start_index);
		new_src[end_index - start_index] = '\0';
	} 
	//DEBUG(LOG_PREFIX_FORMAT"strip '%s' to '%s'\n", LOG_PREFIX, src, new_src);
	return new_src;
}



bool dir_exist(const char *path)
{
	struct stat st;

	if(!path)
		return false;
	if (stat(path, &st)== -1) {
		ERROR(LOG_FMT"path %s: %s\n", LOG_PRE, path, error_string());
		return false;
	}
	if (S_ISDIR(st.st_mode))
		return true;
	return false;
}

bool path_exist(const char *path)
{
	struct stat st;

	if(!path)
		return false;
	if (stat(path, &st)== -1) {
		ERROR(LOG_FMT"stat %s failed: %s\n", LOG_PRE, path, error_string());
		return false;
	}
	return false;
}

bool create_path(const char *path) 
{
	int fd = -1;

	if (!path)
		return false;
	if (path_exist(path))
		return false;
	if (-1 == (fd = open(path, O_RDWR | O_CREAT))) 
		return false;
	close(fd);
	return true;
}

bool create_dirs(const char *path)
{
	char *token ;
	char buf[MAX_BUFFER];
	char t[MAX_BUFFER];

	buf[0] = '/';
	buf[1] = 0;
	if(!path)
		return false;
	snprintf(t, MAX_BUFFER - 1, "%s", path);
	for(token = strtok((char *)t, "/"); token; token = strtok(NULL, "/")) {
		strcat(buf, token);
		strcat(buf, "/");
		if (dir_exist(buf) == false) {
			if ( -1 == mkdir(buf, 0774)) {
				WARN(LOG_FMT"create %s failed: %s\n", LOG_PRE, path, error_string());
				return false;
			}
		}
	}
	return true;
}



const char *format_time(time_t t, const char *fmt)
{
	static char tmp [128]; 
	struct tm *tm = NULL; 

	if (!fmt)
		return NULL;
	tm = localtime(&t); 
	strftime(tmp, 127, fmt, tm); 
	return tmp;
}

const char *format_time_r(time_t t, const char *fmt, char *ret, int len)
{
	if(!ret)
		return NULL;

	struct tm *tm = NULL; 

	if (!fmt)
		return NULL;
	tm = localtime(&t); 
	strftime(ret, len - 1, fmt, tm); 
	return ret;
}

const char *readable_time(int t)
{
	static char buf[MAX_BUFFER];
	int day = 0;
	int hour = 0;
	int minu = 0;
	int sec = 0;

	if (t < 0) 
		return NULL;

	day = t / (24 * 60 * 60);
	hour = (t - day * 24 * 60 * 60) / (60 * 60);
	minu = (t - day * 24 * 60 * 60 - hour * 60 * 60) / 60;
	sec = t - day * 24 * 60 * 60 - hour * 60 * 60 - minu * 60;

	snprintf(buf, MAX_BUFFER - 1, "%dd %dh %dm %d", day, hour, minu, sec);

	return buf;
}

unsigned int read_pid(const char *path)
{
	FILE *f = NULL;
	unsigned int res = 0;
	char buf[128];

	if(!path)
		return 0;
	if((f = fopen(path, "r")) == NULL) {
		return 0;
	}
	if (NULL == fgets(buf, 128, f)) {
		fclose(f);
		return 0;
	}
	res = atoi(buf);
	fclose(f);
	return res;
}

bool write_pid(const char *path, unsigned int p)
{
	FILE *f = NULL;

	if(!path)
		return false;
	if((f = fopen(path, "w")) == NULL) {
		return false;
	}
	fprintf(f, "%u", p);
	fclose(f);
	return true;
}

bool remove_file(const char *path)
{
	if(unlink(path) == -1) {
		return false;
	}
	return true;
}

void child_monitor(const char *app_name, void *arg)
{
	int failed = 0;
	int child_pid = 0;
	int status;
	time_t start, stop;
	int sleep_interval = 2;

	for(; ;) {
		openlog(app_name, LOG_PID | LOG_NDELAY | LOG_CONS, LOG_LOCAL4);

		start = time(NULL);

		child_pid = waitpid(-1, &status, 0);

		stop = time(NULL);

		syslog(LOG_NOTICE, "worker exited, uptime %s.\n", readable_time(stop - start));

		if (WIFEXITED(status)) {
			syslog(LOG_NOTICE, "exited with status %d\n", WEXITSTATUS(status));
		} 
		else if (WIFSIGNALED(status)) {
			syslog(LOG_NOTICE, "exited with signal %d\n", WTERMSIG(status));
		} 
		else {
			syslog(LOG_NOTICE, "exit normally");
		}

		if(stop - start < 5) 
			failed++;
		else 
			failed = 0;

		if(failed > 3) {
			syslog(LOG_NOTICE, "failed to restart, failed count %d\n", failed);
			break;
		}

		/* 
		 * normally exit 
		 */

		if (WIFEXITED(status)) {
			if (WEXITSTATUS(status) == 0) {
				return;
			}
		}

		syslog(LOG_NOTICE, "wait %ds, then restart again ...\n", sleep_interval);

		sleep(sleep_interval);

		g_child_pid = spawn(worker_loop, arg);
	}
}

int spawn(void (*cb)(void *), void *arg)
{
	int pid = 0;

	if (-1 == (pid = fork())) {
		return -1;
	}

	/* 
	 * child 
	 */
	if (pid == 0) {
		if (cb) {
			cb(arg);
		}
		/* not reached */
		return 0;
	}

	return pid;
}

const char * error_string(void)
{
	return strerror(errno);
}

bool is_ignore_errno(int err)
{
    switch (err) {
		case EINPROGRESS:
		case EAGAIN:
		case EINTR:
#ifdef ERESTART
		case ERESTART:
#endif
			return true;
		default:
			return false;
	}
}

bool set_nonblocking(int fd)
{
	int  flags;

	/* Set a socket as nonblocking */
	if  ( (flags = fcntl (fd, F_GETFL, 0)) < 0) {
		return false;
	}
	flags |= O_NONBLOCK;
	if (fcntl(fd, F_SETFL, flags) < 0) {
		return false;
	}
	return true;
}


bool set_nodelay(int fd)
{
#if TCP_NODELAY
	int sock_opt = 1;

	if (setsockopt(fd, IPPROTO_TCP, TCP_NODELAY, (void *)&sock_opt, sizeof(sock_opt)) == -1 ) {
		return false;
	}
#else 
	int sock_opt = 0;
	
	if (setsockopt(fd, SOL_SOCKET, SO_SNDLOWAT, (void *)&sock_opt, sizeof(sock_opt)) == -1 ) {
		return false;
	}
	if (setsockopt(fd, SOL_SOCKET, SO_RCVLOWAT, (void *)&sock_opt, sizeof(sock_opt)) == -1 ) {
		return false;
	}


#endif
	return true;
}


bool set_linger_close(int fd)
{
	int z; /* Status code */
	struct linger so_linger;
	
	so_linger.l_onoff = 1;
	so_linger.l_linger = 0;
	z = setsockopt(fd, SOL_SOCKET, SO_LINGER, &so_linger, sizeof(so_linger));
	if (z == -1) {
		return false;
	}
	return true;

}

bool set_sock_buf(int fd, int len)
{
	
	if ( -1 == setsockopt(fd,SOL_SOCKET,SO_RCVBUF,(const char*)&len,sizeof(int)))
		return false;
	if ( -1 == setsockopt(fd,SOL_SOCKET,SO_SNDBUF,(const char*)&len,sizeof(int)))
		return false;
	return true;
}

bool set_reuse(int fd)
{
	int sock_opt = 1;  
	
	if (setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, (void*)&sock_opt, sizeof(sock_opt) ) == -1){   
		return false;  
	}
	return true;
}

const char *get_host_ip(const char *host)
{
	 struct hostent *hptr;
	 char **pptr;
	 static char ip[16];

	if(!host)
		return NULL;
	if (NULL == (hptr = gethostbyname(host))) {
		return NULL;
	}
	switch(hptr->h_addrtype) {
		case AF_INET:
		case AF_INET6:
			pptr = hptr->h_addr_list;
			if (*pptr) {
				if ( NULL == inet_ntop(AF_INET, *pptr, ip, 16)) 
					return NULL;
				return ip;
			}
			return NULL;
		default:
			return NULL;
	}
	return NULL;
}



bool is_ipv4(const char *ip)  
{  
	int part[4];
	int num = 0;
	int i = 0;
	bool ret = true;

	if (!ip) {
		ret = false;
		goto finish;
	}
	memset(part, 0, sizeof(part));
	num = sscanf(ip, "%d.%d.%d.%d", &part[0], &part[1], &part[2], &part[3]);
	if (num != 4) {
		ret = false;
		goto finish;
	}
	for (i = 0; i < 4; i++) {
		if (part[i] <0 || part[i] > 255) {
			ret = false;
			goto finish;
		}
	}
finish:
	DEBUG(LOG_FMT"%s %s ip\n", LOG_PRE, ip, ret?"is":"isn't");
	return ret;
}


int network_listen(const char *addr, short port)
{
	int fd = -1;
	struct sockaddr_in srv;

	if(addr == NULL) {
		WARN(LOG_FMT"address is null\n", LOG_PRE);
		return fd;
	}
	if ( (fd = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, error_string());
		return fd;
	}
	srv.sin_port = htons(port);
	srv.sin_family = AF_INET;
	inet_pton(AF_INET, addr, &srv.sin_addr);
	if ( -1 == bind(fd, (struct sockaddr *) &srv, sizeof(srv))) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, error_string());
		return -1;
	}
	if (-1 == listen(fd, 128)) {
		ERROR(LOG_FMT"%s\n", LOG_PRE, error_string());
		return -1;
	}
	/* set socket option */
	set_nonblocking(fd);
	set_reuse(fd);
	set_nodelay(fd);
	set_linger_close(fd);

	DEBUG(LOG_FMT"Listen at %s:%d, socket %d\n", LOG_PRE, addr, port, fd);
	return fd;	
}



const char *build_file_path(const char *prefix, const char *name)
{
	static char ret[MAX_BUFFER];

	if (!(prefix && name))
		return NULL;
	ret[0] = '\0';
	strcpy(ret, prefix);
	if (ret[strlen(ret) - 1] != '/') 
		strcat(ret, "/");
	strcat(ret, name);
	
	return ret;
}

#ifndef WIN32
void create_daemon(const char *cmd, const char *dir)
{
	int                 i;
	int fd0, fd1, fd2;
	pid_t               pid;
	struct rlimit       rl;
	struct sigaction    sa;
	/*
	* Get maximum number of file descriptors.
	*/
	if (getrlimit(RLIMIT_NOFILE, &rl) < 0) {
		printf("%s: can't get file limit", strerror(errno));
		exit(1);
	}

	/*
	* Become a session leader to lose controlling TTY.
	*/
	if ((pid = fork()) < 0) {
		printf("%s: can't fork", strerror(errno));
		exit(0);
	} else if (pid != 0) /* parent */
		exit(0);
	setsid();

	/*
	* Ensure future opens won't allocate controlling TTYs.
	*/
	sa.sa_handler = SIG_IGN;
	sigemptyset(&sa.sa_mask);
	sa.sa_flags = 0;
	if (sigaction(SIGHUP, &sa, NULL) < 0) {
		printf("%s: can't ignore SIGHUP", strerror(errno));
		exit(0);
	}
	if ((pid = fork()) < 0) {
		printf("%s: can't fork", strerror(errno));
	}
	else if (pid != 0) /* parent */
		exit(0);

	/*
	* Change the current working directory to the root so
	* we won't prevent file systems from being unmounted.
	*/
	if (chdir(dir) < 0) {
		printf("%s: can't change directory to %s", strerror(errno), dir);
		exit(0);
	}

	/*
	* Close all open file descriptors.
	*/
	if (rl.rlim_max == RLIM_INFINITY)
		rl.rlim_max = MAX_FD;
	for (i = 0; i < rl.rlim_max; i++)
		close(i);

	fd0 = open("/dev/null", O_RDWR);
	fd1 = dup(0);
	fd2 = dup(0);
}
#endif

/* Obtain a backtrace and print it to stdout. */
void print_trace (void)
{
#if HAVE_EXECINFO_H
	void *array[10];
	size_t size;
	char **strings;
	size_t i;

	size = backtrace (array, 10);
	strings = backtrace_symbols (array, size);

	printf ("Obtained %zd stack frames.\n", size);

	for (i = 0; i < size; i++)
		DEBUG(LOG_FMT"%s\n", LOG_PRE, strings[i]);

	free (strings);
#endif
}



static const char uri_chars[256] = {
		0, 0, 0, 0, 0, 0, 0, 0,   0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0,   0, 0, 0, 0, 0, 0, 0, 0,
		0, 1, 0, 0, 1, 0, 0, 1,   1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1,   1, 1, 1, 0, 0, 1, 0, 0,
		/* 64 */
		1, 1, 1, 1, 1, 1, 1, 1,   1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1,   1, 1, 1, 0, 0, 0, 0, 1,
		0, 1, 1, 1, 1, 1, 1, 1,   1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1,   1, 1, 1, 0, 0, 0, 1, 0,
		/* 128 */
		0, 0, 0, 0, 0, 0, 0, 0,   0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0,   0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0,   0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0,   0, 0, 0, 0, 0, 0, 0, 0,
		/* 192 */
		0, 0, 0, 0, 0, 0, 0, 0,   0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0,   0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0,   0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0,   0, 0, 0, 0, 0, 0, 0, 0,
};

/*
 * Helper functions to encode/decode a URI.
 * The returned string must be freed by the caller.
 */
const char *encode_uri(const char *uri)
{
	static dstring buf = DSTRING_INITIAL;
	char *p;
	char t[16];
	int t_len = 0;

	if (!uri)
		return NULL;

	dstring_clear(&buf);

	for (p = (char *)uri; *p != '\0'; p++) {
		if (uri_chars[(u_char)(*p)]) {
			dstring_append(&buf, p, 1);
		} else {
			t_len = snprintf(t, 15, "%%%02X", (u_char)(*p));
			dstring_append(&buf, t, t_len);
		}
	}

	return buf.buf;
}

const char *decode_uri(const char *uri)
{
	char c;
	int i, in_query = 0;
	static dstring dst = DSTRING_INITIAL;

	if (!uri)
		return NULL;
	dstring_clear(&dst);
	for (i = 0; uri[i] != '\0'; i++) {
		c = uri[i];
		if (c == '?') {
			in_query = 1;
		} 
		else if (c == '+' && in_query) {
			c = ' ';
		} 
		else if (c == '%' && isxdigit(uri[i+1]) && isxdigit(uri[i+2])) {
			char tmp[] = { uri[i+1], uri[i+2], '\0' };
			c = (char)strtol(tmp, NULL, 16);
			i += 2;
		}
		dstring_append(&dst, &c, 1);
	}
	return dst.buf;
}

bool write_file(const char *path, const char *buf, int len)
{
	int fd = -1;
	int num = 0;

	if (!(path && buf))
		return false;
	if (-1 == (fd = open(path, O_WRONLY | O_CREAT))) {
		ERROR(LOG_FMT"failed to open %s: %s\n", LOG_PRE, path, error_string());
		return false;
	}
	if ( -1 == (num = write(fd, buf, len))) {
		ERROR(LOG_FMT"failed to write %s: %s\n", LOG_PRE, path, error_string());
		remove_file(path);
		close(fd);
		return false;
	}
	if (num != len) {
		ERROR(LOG_FMT"failed to write %s: incorrect bytes\n", LOG_PRE, path);
		remove_file(path);
		close(fd);
		return false;
	}

	return true;
}



/* from 0 ~ 31 */
int set_bit(int *i, int pos, int onoff)
{
	if (!(i && pos>= 0 && pos <= 31))
		return 0;

	int j = (*i);
	int t = 0;
	
	if (onoff == 0) {
		t = 0x1 << pos;
		t = ~t;
		j = j & t;
	}
	else if(onoff == 1) {
		t = 0x1 << pos;
		j = j | t;
	}

	DEBUG(LOG_FMT"old %s\n", LOG_PRE, int_to_char((*i)));
	DEBUG(LOG_FMT"new %s\n", LOG_PRE, int_to_char((j)));

	(*i) = j;

	return j;
}

const char * int_to_char(int t)
{
	int n = 0;
	int i = 0;
	int sz = sizeof(int);
	static char buf[33];

	for(i = 0 ; i < sz * 8; i ++) {
		n = (t >> (sz*8 - i - 1)) & 0x1;
		snprintf(buf + i, 32 - i, "%d", n);
	}
	return buf;
}

int get_next_timestamp(int hour, int minu) 
{
    int now = 0;
    struct tm now_tm;
    int tmp = 0;


    now = time(NULL);
    if (!localtime_r(&now, &now_tm)) {
        return 0;
    }

    if (now_tm.tm_hour >= hour) {
        tmp = 23 - now_tm.tm_hour + hour;
    }
    else {
        if (now_tm.tm_min >= minu)
            tmp = hour - now_tm.tm_hour - 1;
        else 
            tmp = hour - now_tm.tm_hour;
    }
    tmp *= 3600;

    if (now_tm.tm_min >= minu) {
        tmp += 60 * (59 - now_tm.tm_min + minu);
    }
    else {
        tmp += 60 * (minu - now_tm.tm_min - 1);
    }

    tmp += 60 - now_tm.tm_sec;

    return tmp + now;
}



