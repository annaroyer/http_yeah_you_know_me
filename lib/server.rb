require 'socket'
require './lib/request'
require './lib/response_router'
require './lib/game'
require 'pry'

class Server
  def initialize
    @server = TCPServer.new(9292)
    @response_router = ResponseRouter.new
  end

  def request
    client = @server.accept
    @request = Request.new(client.readpartial(2048))
    @response_router.request_counter += 1
    client.puts headers + output
    client.close
    request unless @request.path == '/shutdown'
  end

  def headers
    ["http/1.1 200 ok",
     "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
     "server: ruby",
     "content-type: text/html; charset=iso-8859-1",
     "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  end

  def output
    "<html><head></head><body><pre>
    #{@response_router.route(@request)}
    #{@request.format}
    </pre></body></html>"
  end
end


binding.pry
