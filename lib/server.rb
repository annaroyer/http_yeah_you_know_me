require 'socket'
require './lib/request_parser'
require 'pry'

class Server
  PORT = 9292
  def initialize
    @server = TCPServer.new(PORT)
    @requests = 0
    @path = nil
  end

  def request
    until @path == '/shutdown' do
      client = @server.accept
      request = Request.new(client.readpartial(2048))
      @requests += 1
      client.puts headers + output
      client.close
    end
  end

  def format_request(client_request)
    verb, @path, protocol = client_request.lines[0].split(' ')
    @formatted_request = "Verb: #{verb}\nPath: #{@path}\nProtocol: #{protocol}\n"
    host = client_request.lines[1][/:.*:/].gsub(':', '')
    @formatted_request += "Host:#{host}\nPort: #{PORT}\nOrigin:#{host}\n"
    @formatted_request += client_request.lines[6]
  end

  def route
    if @path == '/'
      "#{@formatted_request}"
    elsif @path == '/hello'
      "Hello World(#{@requests})"
    elsif @path == '/datetime'
      "#{Time.now.strftime("%I:%M%p on %A, %B %-d, %Y")}"
    elsif @path == '/shutdown'
      "Total requests: #{@requests}"
    elsif @path == '/word_search'
      search_word(word)
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

  def response
    "<pre>\n#{route}</pre>"
  end

  def output
    "<html><head></head><body>#{response}</body></html>"
  end
end


binding.pry
