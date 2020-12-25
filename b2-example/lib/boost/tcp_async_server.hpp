#include <boost/asio.hpp>
#include <memory>
#include <map>
#include <string>
#include <boost/array.hpp>
#include <boost/array.hpp>

namespace ao = boost::asio;
class Session;
class TcpAsyncServer;
using sockpointer = std::shared_ptr<Session>;
using ao::ip::tcp;

class Session : public std::enable_shared_from_this<Session>
{
	public:
		Session(ao::io_context &io):socket_(io){}
		Session(tcp::socket sock):socket_(std::move(sock)){}
		tcp::socket& socket();
		void start();

	private:
		void do_write(std::size_t len);
		void do_read();
	private:
		tcp::socket socket_;
		boost::array<char,BUFSIZ> buf_;
};

class TcpAsyncServer
{
	public:
		TcpAsyncServer(ao::io_context &io,short port);
		~TcpAsyncServer() = default;
	private:
		void do_accept();
	private:
		ao::io_context &io_context_;
		tcp::acceptor acceptor_;
};
