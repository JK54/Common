#include <boost/program_options.hpp>
#include <string>
namespace bpo = boost::program_options;
class Options
{
	public:
		Options();
		Options(const int &ac,char **av);
		~Options() = default;
		void disp();
		bpo::variables_map& get();
		std::string getconfname(); 
	private:
		//这两个成员是给disp()使用的
		bpo::options_description generic;
		bpo::options_description cmdline;
		bpo::variables_map vmap;
};
