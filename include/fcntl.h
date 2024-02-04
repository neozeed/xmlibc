#ifndef _FCNTL_H
#define _FCNTL_H

extern int _fmode;

#define O_RDONLY	0
#define O_WRONLY	1
#define O_RDWR		2
#define O_NDELAY	(1 << 2)
#define O_APPEND	(1 << 3)
#define O_CREAT		(1 << 4)
#define O_TRUNC		(1 << 5)
#define O_EXCL		(1 << 6)
#define O_TEXT		(1 << 7)
#define O_BINARY	(1 << 8)

#define F_OK  00
#define X_OK  01
#define W_OK  02
#define R_OK  04


int read(int, char *, int);
int write(int, const char *, int);

int creat(const char *, int);
int open(const char *, int, ...);
int close(int);
long int lseek(int, long, int);

long int  tell(int);

int  dup(int);
void  dup2(int, int);

int  access(const char *, int);

#endif
