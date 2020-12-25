#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <locale>
#include <vector>
#include <random>
#include <unistd.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdlib.h>
#include <boost/filesystem.hpp>
#include <boost/date_time.hpp>
#include <boost/lexical_cast.hpp>
#include <boost/algorithm/string.hpp>
#include <boost/regex.hpp>
#include <boost/format.hpp>
#include <boost/date_time.hpp>
#include <boost/system/error_code.hpp>
#include <boost/exception/all.hpp>
#include <boost/interprocess/managed_shared_memory.hpp>
#include <boost/interprocess/sync/named_condition.hpp>
#include <boost/interprocess/sync/interprocess_mutex.hpp>
#include <boost/interprocess/sync/scoped_lock.hpp>
#include <boost/asio.hpp>
#include <boost/array.hpp>
#include "program_options.hpp"
#include "tcp_async_server.hpp"
//基于boost库的一份简单代码测试，测试内容包括：
//1、smart_ptr
//2、bind,function,ref
//3、string,regex,format
//4、interprocess
//5、thread
//6、asio
//7、filesystem
//8、date_time
//9、error_code
//10、lexical_cast
//11、program_options
//使用boost.buildv2作为构建系统,尽量控制代码规模在400行之内。
//逻辑流程：
//1、服务端进程从test.config中读取参数配置,根据参数创建文件,完成测试环境构建。
//	 将部分参数存储于共享内存
//2、服务端派生出客户端进程。
//   客户端进程通过共享内存修改服务端线程数。WSL的测试环境中boost的命名条件变量出现死锁，暂时不用。
//   然后向服务端发送一次echo请求。
//3、服务端在客户端派生后，首先等待200ms，读取修改后的线程数设置进行构建，

namespace fs = boost::filesystem;
namespace ao = boost::asio;
namespace ipc = boost::interprocess;
using std::string;
using std::endl;
using std::cout;
typedef boost::error_info<struct tag_errmsg, std::string> errmsg_info;

//读取配置文件
Options& OP()
{
	static Options op;
	return op;
}

void init()
{

	try
	{
		//初始化测试路径
		// OP().disp();
		fs::path testpath(OP().get()["test_directory"].as<string>());
		remove_all(testpath);
		create_directory(testpath);

		//创建测试文件,文件名带时间戳与序号
		std::locale::global(std::locale("C.UTF-8"));
		boost::posix_time::ptime ptimetmp = boost::posix_time::microsec_clock::local_time();
		string splitsym = "_";
		string suffix = ".txt";
		string filename = testpath.string() + "/log" + splitsym + to_iso_string(ptimetmp) + splitsym + boost::lexical_cast<string>(112358);
		int testfilenum = OP().get()["test_files_create_num"].as<int>();
		//随机数生成器
		std::mt19937 mt(std::random_device{}());
		for(int num = 0;num < testfilenum;num++)
		{
			//分别使用了split方法与regex来替换文件名
			if(mt() % 2 == 0)
			{
				std::vector<string> vtmp;
				boost::algorithm::split(vtmp,filename,[](char sp){return sp == '_';});
				string prefix = vtmp.front();
				ptimetmp = boost::posix_time::microsec_clock::local_time();
				string timetmp = to_iso_string(ptimetmp);
				filename = prefix + splitsym +timetmp + splitsym + boost::lexical_cast<string>(num);
			}
			else
			{
				boost::regex exprtime("_\\w+T.\\w+_");
				boost::regex exprno("_\\w+$");
				ptimetmp = boost::posix_time::microsec_clock::local_time();
				filename = boost::regex_replace(filename,exprtime,"_" + to_iso_string(ptimetmp)+ "_");
				filename = boost::regex_replace(filename,exprno,"_" + boost::lexical_cast<string>(num));
			}
			filename = boost::algorithm::replace_all_copy(filename,".","_");
			std::ofstream ofs(filename);
			ofs<<"This file create at " << boost::format("date : %1%, time : %2%,use regex.") % ptimetmp.date() % ptimetmp.time_of_day() << std::endl;
		}
		//遍历测试文件夹，确保文件生成成功
		fs::directory_iterator endmark;
		int count = 0;
		for(fs::directory_iterator p(testpath);p != endmark;++p,++count)
			cout<<count<<"."<<p->path().string()<<" created successfully."<<endl;
		remove_all(testpath);
		//创建共享内存，供子进程修改thread_num参数
		ipc::shared_memory_object::remove("BOOST_TEST_IN_COMMON");
		ipc::managed_shared_memory shm_manager(ipc::open_or_create,"BOOST_TEST_IN_COMMON",1024);
		shm_manager.find_or_construct<int>("THREAD_NUM")(OP().get()["thread_num"].as<int>());
		shm_manager.find_or_construct<int>("THREAD_COUNT")(0);
	}
	catch(boost::exception &e)
	{
		e<<errmsg_info("init failed");
		throw;
	}
}

//同步的TCP客户端，为了减少代码规模，没有封装为类及分离文件。
void client()
{
	ipc::managed_shared_memory shm_manager(ipc::open_or_create,"BOOST_TEST_IN_COMMON",1024);
	std::pair<int*,std::size_t> thread_num_c = shm_manager.find<int>("THREAD_NUM");
	*(thread_num_c.first) = 3;
	ao::io_context io_context_;
	int waitms = OP().get()["client_mod_thread_num_loop_wait"].as<int>() + 1000;
	ao::steady_timer t(io_context_,ao::chrono::microseconds(waitms));

	ao::ip::tcp::resolver resolver(io_context_);
	ao::ip::tcp::socket sock(io_context_);
	t.wait();
	ao::connect(sock,resolver.resolve("127.0.0.1","12345"));
	char buf[BUFSIZ] = "PING";
	int request_len = strlen(buf);
	ao::write(sock,ao::buffer(buf,request_len));
	memset(buf,'\0',BUFSIZ);
	size_t reply_len = ao::read(sock,ao::buffer(buf,request_len));
	cout<<"The reply is : ";
	cout.write(buf,reply_len);
	cout<<endl;
}
//异步的TCP服务端
void serv()
{
	ipc::managed_shared_memory shm_manager(ipc::open_or_create,"BOOST_TEST_IN_COMMON",1024);
	int waitms = OP().get()["server_wait_for_client_mod"].as<int>();
	ao::io_context io_context_;
	ao::steady_timer t(io_context_,ao::chrono::microseconds(waitms));
	ao::steady_timer t2(io_context_,ao::chrono::seconds(3));
	t.wait();
	std::pair<int*,std::size_t> thread_num_s = shm_manager.find<int>("THREAD_NUM");
	int thread_num = *(thread_num_s.first);
	ipc::shared_memory_object::remove("BOOST_TEST_IN_COMMON");
	// server s(io_context_,12345);
	TcpAsyncServer s(io_context_,12345);
	cout<<"server program will shut down after 3s."<<endl;
	t2.async_wait(
			[](const boost::system::error_code &ec)
			{
				exit(0);
			});
	io_context_.run();
}

void boost_test_in_common()
{
	init();
	pid_t pid;
	if((pid = fork()) == 0)
		client();
	else
		serv();
}

