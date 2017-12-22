require './lib/game'
require './lib/word_search'

class Responder
  attr_reader :game

  def initialize
    @request_counter = 0
  end

  def route(request)
    @request = request
    @request_counter += 1
    case @request.verb
    when 'POST' then route_post
    when 'GET' then route_get
    end
  end

  def route_post
    case @request.path
    when '/start_game' then @game = Game.new
    when '/game' then @game.take_guess(@request.guess)
    end
  end

  def route_get
    case @request.path
    when '/word_search' then search_word
    when '/game' then @game.get_info
    else simple_responses[@request.path]
    end
  end

  def simple_responses
    {'/' => @request.format,
     '/hello' => "Hello World! (#{@request_counter})",
     '/datetime' => Time.now.strftime("%I:%M%p on %A, %B %-d, %Y"),
     '/shutdown' => "Total requests: #{@request_counter}",
     '/start_game' => 'Good luck!'}
  end

  def search_word
    word_search = WordSearch.new
    word_search.find(@request.param)
  end

  def start_game
    @game = Game.new
    return 'Good luck!'
  end
end
