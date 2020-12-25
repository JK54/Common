#include <iostream>
#include "config.h"
#ifndef USE_MYMATH
// #ifdef HAVE_POW
	#include <cmath>
#else
	#include "lib/fast_pow.h"
#endif

int main()
{
	std::cout<<"Version : "<<VERSION_MAJOR<<"."<<VERSION_MINOR<<std::endl;
	double r;
#ifndef USE_MYMATH
// #ifdef HAVE_POW
	r = pow(2,60);
	std::cout<<"sys,"<<r<<std::endl;
#else
	r = fast_pow(2,60);
	std::cout<<"my,"<<r<<std::endl;
#endif
	return 0;
}
