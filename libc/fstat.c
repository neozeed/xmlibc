#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>

int
fstat(int fd, struct stat *buf)
{
  if (_legal_fd(fd))
   return -1;

  buf->st_dev	= 0;
  buf->st_ino	= 0;
/* _fgetmode(fd) is now not support */
  buf->st_mode	= 0666 | _fget_file_type(fd);
  buf->st_nlink	= 1;
  buf->st_uid	= 0;
  buf->st_gid	= 0;
  buf->st_rdev	= 0;
  buf->st_size	= _fget_file_size(fd);
  buf->st_atime	=
  buf->st_mtime	=
  buf->st_ctime	= _fget_file_time(fd);

  return 0;
}
