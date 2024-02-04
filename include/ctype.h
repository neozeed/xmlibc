#ifndef _CTYPE_H
#define _CTYPE_H

extern char _char_table[];

#define	_IS_DIGIT	(1 << 0)
#define	_IS_XDIGIT	(1 << 1)
#define	_IS_LOWER	(1 << 2)
#define	_IS_UPPER	(1 << 3)
#define	_IS_WHITE	(1 << 4)
#define	_IS_GRAPH	(1 << 5)
#define	_IS_PUNCT	(1 << 6)
#define	_IS_PRINT	(1 << 7)

#define _IS_ALNUM	(_IS_DIGIT | _IS_UPPER | _IS_LOWER)
#define _IS_ALPHA	(_IS_UPPER | _IS_LOWER)

#define isalnum(c) ((_char_table[(unsigned char)(c)] & _IS_ALNUM)? 1: 0)
#define isalpha(c) ((_char_table[(unsigned char)(c)] & _IS_ALPHA)? 1: 0)
#define iscntrl(c) (((unsigned char)(c) < 0x20) ? 1: 0)
#define isdigit(c) ((_char_table[(unsigned char)(c)] & _IS_DIGIT)? 1: 0)
#define isgraph(c) ((_char_table[(unsigned char)(c)] & _IS_GRAPH)? 1: 0)
#define islower(c) ((_char_table[(unsigned char)(c)] & _IS_LOWER)? 1: 0)
#define isprint(c) ((_char_table[(unsigned char)(c)] & _IS_PRINT)? 1: 0)
#define ispunct(c) ((_char_table[(unsigned char)(c)] & _IS_PUNCT)? 1: 0)
#define isspace(c) ((_char_table[(unsigned char)(c)] & _IS_WHITE)? 1: 0)
#define isupper(c) ((_char_table[(unsigned char)(c)] & _IS_UPPER)? 1: 0)
#define isxdigit(c) ((_char_table[(unsigned char)(c)] & _IS_XDIGIT)? 1: 0)

#define isascii(c) ((unsigned char)(c) <= 0177)
#define toascii(c) ((unsigned char)(c) & 0177)

int toupper(int);
int tolower(int);

#ifdef __GNUC__
static __inline__ int  _toupper(int c) { return c - 'a' + 'A'; }
static __inline__ int  _tolower(int c) { return c - 'A' + 'a'; }
#else
#define _toupper(c)	(((c) - 'a') + 'A')
#define _tolower(c)	(((c) - 'A') + 'a')
#endif

#endif
