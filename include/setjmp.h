#ifndef _SETJMP_H
#define _SETJMP_H

typedef long jmp_buf[9];

void  longjmp(jmp_buf, int);
int  setjmp(jmp_buf);

#endif
