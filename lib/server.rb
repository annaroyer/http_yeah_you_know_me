require 'socket'
require './lib/request'
require './lib/game'
require 'pry'

class Server
  def initialize
    @server = TCPServer.new(9292)
    @request_counter = 0
  end

  def request
    client = @server.accept
    @request = Request.new(client.readpartial(2048))
    @request_counter += 1
    client.puts headers + output
    client.close
    request unless @request.path == '/shutdown'
  end

  def route
    response = case @request.path
      when '/hello' then "Hello World! (#{@request_counter})"
      when '/datetime' then Time.now.strftime("%I:%M%p on %A, %B %-d, %Y")
      when '/shutdown' then "Total requests: #{@request_counter}"
      when '/word_search' then search_word
      when '/start_game' then 'Good luck!'
    end
    return response
  end

  def search_word
    File.readlines('/usr/share/dict/words').each do |line|
      return "#{@request.param} is a known word" if @request.param == line.chomp
    end
    "#{@request.param} is not a known word"
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
    #{route}
    #{@request.format}
    </pre></body></html>"
  end
end


binding.pry
