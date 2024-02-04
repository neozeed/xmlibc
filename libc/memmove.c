/*
	memmove: memory copy, souce and dest. may overlap
				by elfin 	V0.8  1990-07-30
*/
#include <stdlib.h>

void *
memmove(void *s1, const void *s2, size_t n)
{
	if((s1 > s2) && (s1 < s2 + n)) {	/* overlapping dest. */
		asm("	movl	%0, %%esi":: "g" (s2 + n - 1): "si");
		asm("	movl	%0, %%edi":: "g" (s1 + n - 1): "di");
		asm("	movl	%0, %%ecx":: "g" (n): "cx");
		asm("	std
			rep
			movsb": : : "cx","si","di");
	} else {
		asm("	movl	%0, %%esi":: "g" (s2): "si");
		asm("	movl	%0, %%edi":: "g" (s1): "di");
		asm("	movl	%0, %%ecx":: "g" (n): "cx");
		asm("	cld
			rep
			movsb": : : "cx","si","di");
	}
	return s1;
}

