/*
 $Header: F:\GCC\LIBC\LIBRARY\INCLUDE\RCS\getpages.h 1.1 90/08/30 15:07:08 kay Exp Locker: kay $
 $Author: kay $
 $Date: 90/08/30 15:07:08 $

 $Log:	getpages.h $
 * Revision 1.1  90/08/30  15:07:08  kay
 * Initial revision
 * 
*/

#ifdef TOWNS
#  define HAVE_GETPAGESIZE
#  define getpagesize()	(0x1000)
#else
#  undef HAVE_GETPAGESIZE
#endif
