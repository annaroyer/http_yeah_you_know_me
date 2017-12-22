require 'socket'
require './lib/request'
require './lib/responder'
require './lib/wrapper'

class Server
  def initialize
    @server = TCPServer.new(9292)
    @responder = Responder.new
  end

  def request
    @client = @server.accept
    read_request
    write_response
    @client.close
    unless @request.path == '/shutdown' || @request.path == '/force_error'
      request
    end
  end

  def read_request
    request_lines = []
    while line = @client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    @request = Request.new(request_lines)
    read_body if @request.verb + @request.path == 'POST/game'
  end

  def read_body
    body = @client.read(@request.content_length)
    @request.find_guess(body)
  end

  def write_response
    response = @responder.route(@request)
    wrapper = Wrapper.new(@request, response)
    @client.puts wrapper.output
  end
end
