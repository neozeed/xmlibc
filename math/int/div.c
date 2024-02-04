/*  gnu cc library
	(c) h.yama 	1990,
*/
#include  <stdlib.h>
div_t  div(int num, int dvisor)
{
   div_t ans;
   asm( "
	movl	%0,%%eax
	movl	%1,%%ebx
	cltd
	idivl	%%ebx
	movl	%%eax,%2
	movl	%%edx,%3
	 " : : "g"(num),"g"(divsor),"g"((ans.quot),"g"(ans.reminder))
	 : "ax","bx","cx","dx");
   return ans;
}
