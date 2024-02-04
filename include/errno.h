#ifndef _ERRNO_H
#define _ERRNO_H

/* For Unix compatibility */
/* #define EFUNCTION	1	/*	*/
/* #define ENOENT	2	/*	*/
/* #define ENOPATH	3	/*	*/
/* #define EMFILE	4	/*	*/
/* #define EACCESS	5	/*	*/
/* #define EBADF	6	/*	*/
/* #define EMCDSTRY	7	/*	*/
/* #define ENOMEM	8	/*	*/
/* #define EMBBADA	9	/*	*/
/* #define EINVENV	10	/*	*/
/* #define EINVFMT	11	/*	*/
/* #define EINVACC	12	/*	*/
/* #define EINVDAT	13	/*	*/
/* #define ENOTEXIST	14	/* not exist this error */
/* #define EINVDRV	15	/*	*/

/* #define ENOTEMPTY	16	/*	*/
/* #define ENOSAMEDV	17	/*	*/
/* #define ENOMRFILE	18	/*	*/
/* #define EROFS	19	/*	*/
/* #define EUNKUNIT	20	/*	*/
/* #define ENOTREADY	21	/*	*/
/* #define EUNKCOM	22	/*	*/
/* #define EDATA	23	/*	*/
/* #define EBADSTRLEN	24	/*	*/
/* #define ESEEK	25	/*	*/
/* #define EUNKMEDIA	26	/*	*/
/* #define ESECNOTFIND	27	/*	*/
/* #define EOUTOFPAPER	28	/*	*/
/* #define EWRFAULT	29	/*	*/
/* #define ERDFAULT	30	/*	*/
/* #define EGENFAIL	31	/*	*/

/* #define ESHAREVIO	32	/*	*/
/* #define ELOCKVIO	33	/*	*/
/* #define ENDSKCHNG	34	/*	*/
/* #define EFCBUNAVIL	35	/*	*/
/* #define ESHAREBUFOVF	36	/*	*/

#define EFAULT	(-1)	/* not exist for ms-dos */

/* ANSI Standard */
#define EDOM	128
#define ERANGE	129

extern int errno;

#endif
