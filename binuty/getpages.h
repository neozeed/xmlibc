/*   Library program for GCC on DOS-Extender		

	(c) Copyright by Keisuke Yoshida, 1989, 1990  ver 0.92

*/ 


#ifdef TOWNS
#  define HAVE_GETPAGESIZE
#  define getpagesize()	(0x1000)
#else
#  undef HAVE_GETPAGESIZE
#endif
