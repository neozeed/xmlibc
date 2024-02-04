#ifndef _STRINGS_H
#define _STRINGS_H

#include <string.h>

char  *index(const char *, int);
char  *rindex(const char *, int);

void  bcopy(const void *, void *, int);
int  bcmp(const void *, const void *, int);
void  bzero(void *, int);
int  ffs(int);

#endif /* _STRINGS_H */
