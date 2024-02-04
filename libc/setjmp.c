#include <setjmp.h>

/*
high address
  argment[n]      <- %ebp + 4 + 4 * i
	.
	.
	.
	.
  argment[1]      <- %ebp + 8
  return address  <- %ebp + 4
  old %ebp	  <- %ebp
  auto variable[1]
	.
	.
	.
  auto variable[n]	<- %esp
low address
*/

enum REGISTERS {
  EAX,  EBX,  ECX,  EDX,
  EDI,  ESI,  EBP,  ESP,
  RAD,
};

int
setjmp(jmp_buf buf)
{
  int i;
  buf[EBP] = (&i)[1];
  buf[RAD] = (&i)[2];

  asm("movl %%ebp,%0": "=m"(buf[ESP]));
  asm("movl %%ebx,%0": "=m"(buf[EBX]));
  asm("movl %%esi,%0": "=m"(buf[ESI]));
  asm("movl %%edi,%0": "=m"(buf[EDI]));

  return 0;
}

void
longjmp(jmp_buf buf, int value)
{
  int i;
  (&i)[1] = buf[EBP];
  (&i)[2] = buf[RAD];

#if 0
  asm("movl %0,%%esp": /* no input */: "m"(buf[ESP]));
#endif
  asm("movl %0,%%ebx": /* no input */: "m"(buf[EBX]));
  asm("movl %0,%%esi": /* no input */: "m"(buf[ESI]));
  asm("movl %0,%%edi": /* no input */: "m"(buf[EDI]));

  if (value != 0)
   asm("movl %0,%%eax": /* no input */: "g"(value): "ax");
  else
   asm("movl %0,%%eax": /* no input */: "i"(1): "ax");
}
