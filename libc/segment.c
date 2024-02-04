#include <towns/segment.h>

void
_memcpyfar(
  longword src_seg, longword src_offset,
  longword dst_seg, longword dst_offset,
  longword nbytes
	  )
{
  asm("pushl %ds");
  asm("pushl %es");
  asm("movl %0,%%esi":: "g" (src_offset): "si");
  asm("movl %0,%%edi":: "g" (dst_offset): "di");
  asm("movl %0,%%ecx":: "g" (nbytes):     "cx");
  asm("movl %0,%%ds" :: "r" ((unsigned short) src_seg));
  asm("movl %0,%%es" :: "r" ((unsigned short) dst_seg));
  asm("cld");
  asm("rep");
  asm("movsb"        :: /* no input */ : "si", "di");
  asm("popl %es");
  asm("popl %ds");
}


unsigned int
_peek_byte(longword segment, longword offset)
{
  register unsigned char c;

  asm("movl %0,%%fs"     : /* no output */: "r"((unsigned short) segment));
  asm("movb %%fs:(%1),%0": "=r"(c)        : "r"(offset));

  return c;
}

unsigned int
_peek_word(longword segment, longword offset)
{
  register unsigned short c;

  asm("movl %0,%%fs"     : /* no output */: "r"((unsigned short) segment));
  asm("movw %%fs:(%1),%0": "=r"(c)        : "r"(offset));

  return c;
}

unsigned int
_peek_longword(longword segment, longword offset)
{
  register unsigned int c;

  asm("movl %0,%%fs"     : /* no output */: "r"((unsigned short) segment));
  asm("movl %%fs:(%1),%0": "=r"(c)        : "r"(offset));

  return c;
}

void
_poke_byte(longword segment, longword offset, unsigned int data)
{
  asm("movl %0,%%fs"     : /* no output */: "r"((unsigned short) segment));
  asm("movb %0,%%fs:(%1)": /* no output */: "r"(data), "r"(offset));
}

void
_poke_word(longword segment, longword offset, unsigned int data)
{
  asm("movl %0,%%fs"     : /* no output */: "r"((unsigned short) segment));
  asm("movw %0,%%fs:(%1)": /* no output */: "r"(data), "r"(offset));
}

void
_poke_longword(longword segment, longword offset, unsigned int data)
{
  asm("movl %0,%%fs"     : /* no output */: "r"((unsigned short) segment));
  asm("movl %0,%%fs:(%1)": /* no output */: "r"(data), "r"(offset));
}

