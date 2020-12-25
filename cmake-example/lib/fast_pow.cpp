#include "fast_pow.h"

double fast_pow(double base,int exp)
{
	if(exp == 0)
		return 1;
	if(base == 0 && exp < 0)
		throw "div by zero";
	double result = 1;
	int absexp = exp > 0 ? exp : -exp;
	while(absexp != 0)
	{
		if(absexp & 1)
			result *= base;
		absexp >>= 1;
		base *= base;
	}
	if(exp < 0)
		result = 1 / result;
	return result;
}
