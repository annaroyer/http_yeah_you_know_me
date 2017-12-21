require './lib/game'
require './lib/word_search'
require './lib/packager'

class Responder
  def initialize
    @request_counter = 0
  end

  def route(request)
    @request = request
    @request_counter += 1
    if @request.verb + @request.path == 'POST/game'
      take_guess
    else
      package_response
    end
  end

  def package_response
    @response = case @request.path
    when '/word_search' then search_word
    when '/start_game' then start_game
    when '/game' then @game.get_info
    else simple_responses[@request.path]
    end
    return headers + output
  end

  def simple_responses
    {'/' => @request.format,
     '/hello' => "Hello World! (#{@request_counter})",
     '/datetime' => Time.now.strftime("%I:%M%p on %A, %B %-d, %Y"),
     '/shutdown' => "Total requests: #{@request_counter}"}
  end

  def search_word
    @word_search = WordSearch.new
    return word_search.find(@request.param)
  end

  def start_game
    @game = Game.new
    return 'Good luck!'
  end

  def take_guess
    @game.guess(@request.guess)
    return redirect_headers
  end

  def output
    "<html><head></head><body><pre>
    #{@response}
    </pre></body></html>"
  end

  def headers
     "http/1.1 200 ok
     date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}
     server: ruby
     content-type: text/html; charset=iso-8859-1
     content-length: #{output.length}\r\n\r\n"
  end

  def redirect_headers
    ["HTTP/1.1 302 Moved Permanently",
     "Location: http://127.0.0.1:9292/game",
     "Server: ruby",
     "Content-Type: text/html; charset=iso-8859-1",
     "Content-Length: #{output.length}\r\n\r\n"].join("\r\n")
  end
end
