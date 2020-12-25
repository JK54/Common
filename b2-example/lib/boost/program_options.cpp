#include "program_options.hpp"
#include <string>
#include <fstream>
#include <iostream>
#include <cstdlib>
using std::string;
using std::cout;
using std::endl;

string Options::getconfname()
{
	return string(getenv("HOME")) + "/Inventory/Common/b2-example/test.config";
}

Options::Options()
{
	bpo::options_description cnf("Configuration");
	string config_file = getconfname();
	std::ifstream ifs(config_file);
	cnf.add_options()
		("help","help message")
		("config,c",bpo::value<string>(&config_file),"input config file")
		("test_directory",bpo::value<string>(),"test_directory")
		("test_files_create_num",bpo::value<int>(),"test file nums")
		("thread_num",bpo::value<int>(),"thread_num")
		("client_mod_thread_num_loop_wait",bpo::value<int>(),"client wait time")
		("server_wait_for_client_mod",bpo::value<int>(),"server wait time");
	store(parse_config_file(ifs,cnf),vmap);
	notify(vmap);
}

Options::Options(const int &ac,char **av):generic("Generic Options"),cmdline("Options")
{
	string config_file;
	generic.add_options()
		("help","help message")
		("config,c",bpo::value<string>(&config_file)->default_value(getconfname()),"input config file");
	cmdline.add_options()
		("test_directory,D",bpo::value<string>(),"test_directory")
		("test_files_create_num,N",bpo::value<int>(),"test file nums")
		("thread_num,n",bpo::value<int>(),"thread_num")
		("client_mod_thread_num_loop_wait,T",bpo::value<int>(),"client wait time")
		("server_wait_for_client_mod,t",bpo::value<int>(),"server wait time");
	bpo::options_description cnfoption;
	bpo::options_description cmdoption;
	cnfoption.add(generic).add(cmdline);
	cmdoption.add(cmdline);
	store(bpo::command_line_parser(ac,av).options(cnfoption).run(),vmap);
	notify(vmap);
	std::ifstream ifs(config_file);
	store(parse_config_file(ifs,cmdoption),vmap);
	notify(vmap);
}

void Options::disp()
{
	if(vmap.count("help"))
	{
		bpo::options_description bo;
		bo.add(generic).add(cmdline);
		cout<<bo<<'\n';
	}
	if(vmap.count("test_directory"))
	{
		cout<<"test_directory : "<<vmap["test_directory"].as<string>()<<'\n';
	}
	if(vmap.count("test_files_create_num"))
	{
		cout<<"test_files_create_num : "<<vmap["test_files_create_num"].as<int>()<<'\n';
	}
	if(vmap.count("thread_num"))
	{
		cout<<"thread_num : "<<vmap["thread_num"].as<int>()<<'\n';
	}
	if(vmap.count("thread_count"))
	{
		cout<<"thread_count : "<<vmap["thread_count"].as<int>()<<'\n';
	}
	if(vmap.count("client_mod_thread_num_loop_wait"))
	{
		cout<<"client_mod_thread_num_loop_wait : "<<vmap["client_mod_thread_num_loop_wait"].as<int>()<<'\n';
	}
	if(vmap.count("server_wait_for_client_mod"))
	{
		cout<<"server_wait_for_client_mod : "<<vmap["server_wait_for_client_mod"].as<int>()<<'\n';
	}
}

bpo::variables_map& Options::get()
{
	return vmap;
}
