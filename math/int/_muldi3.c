muldi3(long long x, long long y)
{
	int ah,bh;
	unsigned int al,bl;
	int sign;
	long long z;
	
	ah = *((int *)&x + 1);
	bh = *((int *)&y + 1);
	
	sign = 1;
	if (ah < 0) {
		x = -x;
		if (bh >=0) sign = -1;
		ah = *((int *)&x + 1);
		}
	if (bh < 0) {
		y = -y;
		if (ah >= 0) sign = -1;
		bh = *((int *)&y + 1);
		}
	al = *(unsigned int *)&x;
	bl = *(unsigned int *)&y;

	if (ah >0 && bh >0) z = 0x7fffffff;

	z = al *bl + (ah * bl<<32) + (al*bh<<32);
	if (sign) z = -z;
	return z;

}
