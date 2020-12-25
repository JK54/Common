#include "tcp_async_server.hpp"
#include <functional>
#include <iostream>

tcp::socket& Session::socket()
{
	return socket_;
}

void Session::start()
{
	do_read();
}

void Session::do_read()
{
	sockpointer self = shared_from_this();
	socket_.async_read_some(ao::buffer(buf_,BUFSIZ),
			[this,self](boost::system::error_code ec,std::size_t len)
			{
				if(!ec)
				{
					do_write(len);
				}
			});
}

void Session::do_write(std::size_t len)
{
	sockpointer self = shared_from_this();
	ao::async_write(socket_,ao::buffer(buf_,len),
			[this,self](boost::system::error_code ec,std::size_t /**/)
			{
				if(!ec)
				{
					do_read();
				}
			});
}

TcpAsyncServer::TcpAsyncServer(ao::io_context &io,short port):
	io_context_(io),
	acceptor_(io,tcp::endpoint(tcp::v4(),port))
{
	do_accept();
}

void TcpAsyncServer::do_accept()
{
	//官方example中的方式，session类需要定义一个接受socket的构造函数，未使用io_context去初始化socket，不明白原因
   /*  acceptor_.async_accept( */
			// [this](boost::system::error_code ec, tcp::socket socket)
			// {
				// if(!ec)
				// {
					// std::make_shared<Session>(std::move(socket))->start();
				// }
				// do_accept();
			/* }); */

	sockpointer new_connection = std::make_shared<Session>(io_context_);
	acceptor_.async_accept(new_connection->socket(),
			[this,new_connection](boost::system::error_code ec)
			{
				if(!ec)
					new_connection->start();
				this->do_accept();
			});
}
