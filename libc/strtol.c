/*   Library program for GCC on DOS-Extender		

	(c) Copyright by H.yama,  1990  ver 1.00
	
*/ 

#include <stdlib.h>
#include <ctype.h>

#define  MAX_INT 	 (0x7fffffffL)
#define	 max_allowable(A) 	 (( MAX_INT )/A - 1)


long
 strtol (const char *string, char **endptr, int base)
{
	long  i = 0;
	int   s = 1;
	int 	c;
	
	/* skip white space */
	while(isspace(*string)) {
		string++;
	}
	
	/* sign flag check */
	if (*string == '+') string++;
	else if (*string == '-') {
		s = -1;
		string++;
	}

	if (*string == '0') {
		if (toupper(*++string) == 'X')	base = 16,string++;
		else if (base == 0)		base = 8;
		}
	if (base == 0) base = 10;
	
	
	if (base <= 10)
	/* digit string to number */
		for (; isdigit(*string); string++) {
#if 0	/* yama's code has bug */
			if (i < max_allowable(base))
				i = i * base + (*string++ - '0');
			else i = MAX_INT;
#else
			if (i < max_allowable(base))
				i = i * base + (*string - '0');
			else i = MAX_INT;
#endif
		}
	else if (base > 10) {
		for (; c = *string; string++) {
			if (isdigit(c))
			 c = c - '0';
			else {
				c = toupper(c);

				if (c >= 'A' && c < ('A' - 10 + base))
				 c = c - 'A' + 10;
				else
				 break;
			}
			if (i < max_allowable(base))
			 i = i * base + c;
			else
			 i = MAX_INT;
			}
		}	
 	else
	 return 0;		/* negative base is not allowed */
	
	*endptr = string;

	if (s == -1)
	 i = -i;

	return i;
}

