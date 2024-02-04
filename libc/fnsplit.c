/*** 
	library program for GCC on DOS-Extender
	
	(c) kay & h.yama  1989,90		ver 0.92

*/
#include <dir.h>

int 
fnsplit(const char *path, char *drive, char *dir, char *name, char *ext)
{
  char *s,*t,*p,*b;
  int  i,retv = 0;
	
  for (t=path; *t; t++) {
    if (*t =='*' || *t == '?') {
      retv |= WILDCARDS;
      break;
    }
  }
	
  s = t = path;

 s_drive:
  if (s[1] == ':')  {
    *(short *) drive = *(short *) s;
    drive[2] = 0;
    s += 2; 
    retv |= DRIVE;
  }
  else drive[0] = 0;
	
  for (b = p = t=s; *t; t++) {
    if (*t == '\\' || *t == '/') 	b = t;
    else if (*t == '.')				p = t;
  }

 s_ext:
  if (p != s) {
    for (i =1; i<= MAXEXT && p[i]; i++)  ext[i-1] = p[i];
    ext[i] = 0;
    retv |= EXTENSION;
  }
  else 
    ext[0] = 0;

 s_name:
  if (b > s)
   for (i=0; i<MAXFILE && b[i+1] && b[i+1] != '.'; i++)
    name[i] = b[i+1];
  else
   for (i=0; i<MAXFILE && b[i] && b[i] != '.'; i++)
    name[i] = b[i];

 			
  if (b[i+1] == '.') {
    name[i] = b[i+1];
    i++;
  }

  if (i > 0) retv |= FILENAME;
  name[i] = 0;

 s_dir:
  if (b != s) {
    retv |= DIRECTORY;
    for (t=s; t <= b && (t-s) <= MAXDIR	; )
    *dir++ = *t++;
  }

  *dir = 0;
  return retv;
}
	
