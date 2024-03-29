#ifndef STAT_H
#define STAT_H

#include <sys/types.h>

struct stat {
  dev_t st_dev;
  ino_t st_ino;
  short st_mode;
  short st_nlink;
  short st_uid;
  short st_gid;
  dev_t st_rdev;
  off_t st_size;
  time_t st_atime;
  time_t st_mtime;
  time_t st_ctime;
};

#define S_IFMT	0160000 /* file type */
#define S_IFDIR	0040000 /* directory */
#define S_IFCHR 0020000 /* character special */
#define S_IFBLK 0060000 /* block special */
#define S_IFREG	0100000 /* genaral */

int stat(const char *, struct stat *);
int fstat(int, struct stat *);

#endif
