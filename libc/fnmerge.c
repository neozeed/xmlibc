/*** 
	library program for GCC on DOS-Extender
	
	(c) kay & h.yama  1989,90		ver 0.92

*/
#include <dir.h>

void 
fnmerge(char *path, char *drive, char *dir, char *name, char *ext)
{
  char *s,*t;
	
  for (s = drive; *s; s++)
   *path++ = *s;
  for (s = dir; *s; s++)
   *path++ = *s;
  for (s = name; *s; s++)
   *path++ = *s;
  for (s = ext; *s; s++)
   *path++ = *s;

  *path = 0;
}
	
