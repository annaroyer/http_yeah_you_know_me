require 'pry'
require './lib/Game'

class Responder
  attr_accessor :request_counter
  def initialize
    @request_counter = 0
    @guess = 50
  end

  def route(request)
    response = case request.verb + request.path
    when 'GET/hello' then "Hello World! (#{@request_counter})"
    when 'GET/datetime' then Time.now.strftime("%I:%M%p on %A, %B %-d, %Y")
    when 'GET/shutdown' then "Total requests: #{@request_counter}"
    when 'GET/word_search' then search_word(request.param)
    when 'POST/start_game' then start_game
    when 'GET/game' then @game.info
    when 'POST/game' then @game.guess(@guess)
    end
    return response
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
