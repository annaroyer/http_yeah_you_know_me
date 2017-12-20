require 'socket'
require './lib/request'
require './lib/responder'
require 'pry'

class Server
  def initialize
    @server = TCPServer.new(9292)
    @responder = Responder.new
  end

  def request
    @client = @server.accept
    @request = Request.new(read)
    @client.puts @responder.output(@request)
    @client.close
    request unless @request.path == '/shutdown'
  end

  def read
    request_lines = []
    while line = @client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    request_lines
  end
end

binding.pry
