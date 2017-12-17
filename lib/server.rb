require 'socket'
require './lib/request_parser'
require 'pry'

class Server
  PORT = 9292
  def initialize
    @server = TCPServer.new(PORT)
    @request_counter = 0
  end

  def request
    until @path == '/shutdown' do
      client = @server.accept
      @request = Request.new(client.readpartial(2048))
      @request_counter += 1
      client.puts headers + output
      client.close
    end
  end

  def route
    case @request.path
    when '/' return @request.format
    when '/hello' return "Hello World(#{@request_counter})"
    when '/datetime' return "#{Time.now.strftime("%I:%M%p on %A, %B %-d, %Y")}"
    when '/shutdown' return "Total requests: #{@request_counter}"
    when '/word_search' return search_word(@request.param)
    end
  end

  def search_word(word)
    File.readlines('/usr/share/dict/words').each do |line|
      return "#{word} is a known word" if word == line.chomp
    end
    return "#{word} is not a known word"
  end

  def headers
    ["http/1.1 200 ok",
     "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
     "server: ruby",
     "content-type: text/html; charset=iso-8859-1",
     "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  end

  def output
    "<html><head></head><body><pre>#{route}<pre></body></html>"
  end
end


binding.pry
