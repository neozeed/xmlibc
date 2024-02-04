/*** 
	library program for GCC on DOS-Extender
	
	(c) kay & h.yama  1989,90		ver 0.92

*/
#include <stdio.h>
#include <dir.h>
#include <sys/extender.h>

int
findnext(struct ffblk *ffblk)	
{
  _setdta((char *) (ffblk), sizeof(struct ffblk));

  if (_dos_find_next() == 0) {
    _getdta((char *)ffblk, sizeof(struct ffblk));
    return 0;
  }

  else return -1;
}
