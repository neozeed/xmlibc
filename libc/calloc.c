#include <strings.h>
#include <stdlib.h>
#include <stdio.h>

void *
calloc(size_t nelements, size_t element_size)
{
  size_t size = nelements * element_size;
  void   *ptr = malloc(size);

  if (ptr == NULL) return NULL;

  bzero(ptr, size);

  return ptr;
}