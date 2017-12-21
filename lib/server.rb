require 'socket'
require './lib/request'
require './lib/responder'
require './lib/game'
require 'pry'

class Server
  def initialize
    @server = TCPServer.new(9292)
    @request_counter = 0
    @responder = Responder.new
  end

  def request
    @client = @server.accept
    read_request
    @request_counter += 1
    @client.puts @responder.route(@request)
    @client.close
    request unless @request.path == '/shutdown'
  end

  def read_request
    request_lines = []
    while line = @client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    @request = Request.new(request_lines)
    puts request_lines
    read_body if @request.verb + @request.path == 'POST/game'
  end

  def read_body
    body = @client.read(@request.content_length)
    @request.find_guess(body)
  end
end

binding.pry
