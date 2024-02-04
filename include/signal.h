#ifndef _SIGNAL_H
#define _SIGNAL_H

typedef long int	sig_atomic_t;


#define SIGNO	0

#define SIGHUP	0	/* same as SIGNO, because never happen. */
#define SIGABRT	1
#define SIGFPE	2
#define SIGILL	3
#define SIGINT	4
#define SIGSEGV	5
#define SIGTERM	6

#define SIGPIPE	7
#define SIGUSR1	8
#define SIGUSR2	9
#define SIGUSR3	10

#define NSIG	11


#define SIG_DFL (void (*)()) (0)
#define SIG_IGN (void (*)()) (1)
#define SIG_ERR (void (*)()) (-1)


int  raise(int);
void  (*signal(int, void (*)(int)))(int);

#endif
