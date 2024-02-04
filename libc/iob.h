/*
 $Header: F:\GCC\LIBC\LIBRARY\INCLUDE\RCS\iob.h 1.1 90/08/30 15:07:23 kay Exp Locker: kay $
 $Author: kay $
 $Date: 90/08/30 15:07:23 $

 $Log:	iob.h $
 * Revision 1.1  90/08/30  15:07:23  kay
 * Initial revision
 * 
*/

#define PERM 0666

static __inline__ FILE *
get_free_file_structure()
{
  int   i;

  for (i = 0; i < FOPEN_MAX; i++)
   if (_iob[i]._file == -1)
    return &_iob[i];

  return  NULL;
}
