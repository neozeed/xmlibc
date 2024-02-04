/* ieee.h */
#ifndef IEEE_H
#define IEEE_H 1

union ieee_double {
	struct {
		unsigned int	ml: 32;
		unsigned int	mh: 20;
		unsigned int	e:  11;
		unsigned int	s:   1;
	}         i;
	double    d;
	long long ll;
};

union ieee_float {
	struct {
		unsigned int	m: 23;
		unsigned int	e:  8;
		unsigned int	s:  1;
	}	f;
	long	si;
	float	sf;
};

static __inline__ long long
_getall(double x)
{
	union ieee_double d;

	d.d = x;

	return d.ll;
}

static __inline__ int
_getsign(double d)
{
	union ieee_double work;

	work.d   = d;

	return work.i.s;
}

static __inline__ long long
_getmantissa(double d)
{
	union ieee_double work;

	work.d   = d;

	return (work.ll & 0x000fffffffffffffLL) | 0x0010000000000000LL;
}

static __inline__ int
_getexponent(double d)
{
	union ieee_double work;

	work.d = d;

	return work.i.e - 0x3ff;
}

static __inline__ double
_setall(long long ll)
{
	union ieee_double work;

	work.ll = ll;

	return work.d;
}

static __inline__ double
_setsign(double d, int sign)
{
	union ieee_double work;

	work.d   = d;
	work.i.s = sign;

	return work.d;
}

static __inline__ double
_setmantissa(double d, long long mant)
{
	union ieee_double work;

	work.d   = d;
	work.ll  = (work.ll & 0xfff0000000000000LL)
		 | (mant    & 0x000fffffffffffffLL);

	return work.d;
}

static __inline__ double
_setexponent(double d, int exp)
{
	union ieee_double work;

	work.d   = d;
	work.i.e = exp + 0x3ff;

	return work.d;
}

#endif
