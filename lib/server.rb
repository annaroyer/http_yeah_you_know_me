require 'socket'
require './lib/request'
require './lib/responder'
require 'pry'

class Server
  def initialize
    @server = TCPServer.new(9292)
    @responder = Responder.new
    @request_counter = 0
  end

  def request
    @client = @server.accept
    read
    @request_counter += 1
    @client.puts headers + output
    @client.close
    request unless @request.path == '/shutdown'
  end

  def read
    request_lines = []
    while line = @client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    @request = Request.new(request_lines)
    read_body if request_lines[0].start_with?('POST /game')
  end

  def read_body
    body = @client.read(@request.content_length)
    @request.find_guess(body)
  end

  def response
    route
    responses[@request.path] if responses.has_key?(@request.path)
  end

  def responses
    {'/' => @request.format,
     '/hello' => "Hello World#{@request_counter}",
     '/datetime' => Time.now.strftime("%I:%M%p on %A, %B %-d, %Y"),
     '/shutdown' => "Total requests: #{@request_counter}",
     '/start_game' => 'Good luck!'
    }
  end

  def headers
    ["http/1.1 200 ok",
     "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
     "server: ruby",
     "content-type: text/html; charset=iso-8859-1",
     "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  end

  def redirect
    "http/1.1 302 Moved Permanently
     location: http://127.0.0.1:9292/game
     date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}
     server: ruby
     content-type: text/html; charset=iso-8859-1
     content-length: #{output.length}"
   end

  def route
    response = case @request.verb + @request.path
    when 'GET/word_search' then search_word
    when 'POST/start_game' then start_game
    when 'GET/game' then @game.info
    when 'POST/game' then play_game
    end
  end

  def output
    if @request.verb + @request.path == 'POST/game'
      return redirect
    else
      return "<html><head></head><body><pre>#{response}</pre></body></html>"
    end
  end

  def start_game
    @game = Game.new
  end

  def play_game
    @game.guess(@request.guess)
    @game.info
  end

  def search_word
    @word_search = WordSearch.new
    path, word = @request.path.split('?word=')
    @word_search.find(word)
  end
end

binding.pry
