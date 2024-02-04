#ifndef _SYS_TYPES_H
#define _SYS_TYPES_H

typedef short dev_t;
typedef short ino_t;
typedef long off_t;

#ifndef _TIME_T
#define _TIME_T
typedef long time_t;
#endif /* _TIME_T */

#ifndef _SIZE_T
#define _SIZE_T
typedef unsigned long size_t;
#endif /* _SIZE_T */

typedef unsigned char u_char;
typedef unsigned short u_short;
typedef unsigned int u_int;
typedef unsigned long u_long;
typedef unsigned short ushort;
typedef unsigned int uint;

typedef char *caddr_t;

#endif
