/*   Library program for GCC on DOS-Extender		

	(c) Copyright by Keisuke Yoshida, 1989, 1990  ver 0.92

*/ 

#define PERM 0666

static __inline__ FILE *
get_free_file_structure()
{
	int   i;

	for (i = 0; i < FOPEN_MAX; i++) {
		if (_iob[i].fd == -1) {
			return &_iob[i];
		}
	}

	return  NULL;
}
