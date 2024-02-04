/* jctype.h */
#ifndef _JCTYPE_H
#define _JCTYPE_H

#ifdef __GNUC__

static int __inline__
iskanji(int c)
{
  return ((c >= 0x81) && (c <= 0x9f) || (c >= 0xe0) && (c <= 0xff));
}

static int __inline__
iskanji2(int c)
{
  return ((c >= 0x40) && (c <= 0x7e) || (c >= 0x9f) && (c <= 0xfc));
}

#else

#define iskanji(c)  ((c >= 0x81) && (c <= 0x9f) || (c >= 0xe0) && (c <= 0xff))
#define iskanji2(c) ((c >= 0x40) && (c <= 0x7e) || (c >= 0x9f) && (c <= 0xfc))

#endif /* __GNUC__ */

#endif /* _JCTYPE_H */
