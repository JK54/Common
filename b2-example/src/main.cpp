#include <iostream>
#ifdef USE_MYMATH
	#include <cmath>
#else
	#include "../lib/others/fast_pow.hpp"
#endif
#include "../lib/boost/boost_test.hpp"

int main()
{
	double r;
#ifdef USE_MYMATH
	r = pow(2,60);
	std::cout<<"sys,";
#else
	r = fast_pow(2,60);
	std::cout<<"my,";
#endif
	std::cout<<"2 ^ 60 = "<<r<<std::endl;
	boost_test_in_common();
}
