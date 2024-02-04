#include <sys/types.h>
#include <sys/param.h>
#include <stdlib.h>
#include <strings.h>

#define SAFETY		(PAGE_SIZE / 4)

extern char end;

static caddr_t _break = &end;
static int safety     = SAFETY;

static __inline__ caddr_t
current_sp()
{
  caddr_t sp;

  asm("movl %%esp,%0": "=r"(sp): /* no input */);

  return sp;
}

caddr_t
brk(caddr_t addr)
{
  if (_break > current_sp())
   _abort("Memory Limit: Cannot Allocate Heap Area", 99);

  if ((addr + safety) > current_sp())
   return (caddr_t) -1;

  _break = addr;

  return (caddr_t) 0;
}

caddr_t
sbrk(int incr)
{
  caddr_t oldbreak = _break;

  if (!brk(_break + incr)) {
    if (oldbreak < _break)
      bzero(oldbreak, _break - oldbreak);

    return (caddr_t) oldbreak;
  }

  return (caddr_t) -1;
}

long
ulimit(int cmd, int newlimit)
{
  switch (cmd) {
   case 1:
    return 0x7fffffff;

   case 2:
    return newlimit;

   case 3:
    return (long) (current_sp() - safety);

   case 256:
    return safety;

   case 257:
    return safety = newlimit;

   default:
    return -1;
  }

  return -1;
}
