#ifndef ___DIR_H__
#define ___DIR_H__
#include <stddef.h>
#define  MAXPATH  (80)
#define  MAXDRIVE (3)
#define  MAXDIR   (66)
#define  MAXFILE  (9)
#define  MAXEXT   (3)

#define  EXTENSION  (1 << 1)
#define  WILDCARDS  (1 << 5)
#define  FILENAME   (1 << 2)
#define  DIRECTORY  (1 << 3)
#define  DRIVE    	(1 << 4)

struct  ffblk {
	char 	ff_reserved[21];
	char 	ff_attrib;
	short  	ff_ftime;
	short  	ff_fdate;
	struct	{
		short	low,high;
		}  ff_fsize;
	char  	ff_name[13];
	};

int 
  fnsplit(const char *path, char *drive, char *dir, char *name, char *ext);

void 
  fnmerge(char *path, char *drive, char *dir, char *name, char *ext);

int 
  findfirst(const char *path, struct ffblk * ffblk, int attrib);
 
int
  findnext( struct ffblk * ffblk);
  
void _getdta( char *buf, size_t size);	/* copy data from dta */
void _setdta( char *buf, size_t size);	/* copy data into dta */
  
#endif  
  