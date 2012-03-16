#ifndef _CRON_H_
#define _CRON_H_

#define ROOM_WAR_HOUR 19
#define ROOM_WAR_MINU 30


typedef struct Job {
	int hour; /* 0 ~ 23 */
	int minu; /* 0 ~ 59 */

	ARGCB cb;
	void *arg;

	int next_run_timestamp;

	TAILQ_ENTRY(Job) link;
}Job;

extern Job * job_new();
extern void job_free(Job *j);


extern bool job_reg(int h, int m, ARGCB cb, void *arg);

extern bool job_run();

#endif
