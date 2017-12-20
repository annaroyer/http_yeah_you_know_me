require 'pry'
require './lib/Game'

class Responder
  attr_reader :response

  def initialize
    @request_counter = 0
  end

  def route(request)
    @request_counter += 1
    response = case request.verb + request.path
    when 'GET/' then request.format
    when 'GET/hello' then "Hello World! (#{@request_counter})"
    when 'GET/datetime' then Time.now.strftime("%I:%M%p on %A, %B %-d, %Y")
    when 'GET/shutdown' then "Total requests: #{@request_counter}"
    when 'GET/word_search' then search_word(request.param)
    when 'POST/start_game' then start_game
    when 'GET/game' then @game.info
    when 'POST/game' then @game.guess(request.guess)
    end
  end

  def headers
    ["http/1.1 200 ok",
     "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
     "server: ruby",
     "content-type: text/html; charset=iso-8859-1",
     "content-length: #{@response.length}\r\n\r\n"].join("\r\n")
  end

  def html(request)
    @response =
    "<html><head></head><body><pre>
    #{route(request)}
    </pre></body></html>"
  end

  def output(request)
    html(request) + headers
  end

  def start_game
    @game = Game.new
    return 'Good luck!'
  end

  def search_word(word)
    File.readlines('/usr/share/dict/words').each do |line|
      return "#{word} is a known word" if word == line.chomp
    end
    return "#{word} is not a known word"
  end
end
