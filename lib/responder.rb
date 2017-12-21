require 'pry'
require './lib/Game'

class Responder
  def package(response)
    @response = response
    return headers + output
  end

  def route(request)
    response = case request.verb + request.path
    when 'GET/word_search' then search_word(request.path)
    when 'POST/start_game' then start_game
    when 'GET/game' then @game.info
    when 'POST/game' then play_game(request)
    end
  end

  def output
    "<html><head></head><body><pre>
    #{@response}
    </pre></body></html>"
  end

  def start_game
    @game = Game.new
    return 'Good luck!'
  end

  def play_game(request)
    @game.guess(request.guess)
  end

  def search_word(request)
    @word_search = WordSearch.new
    path, word = request.path.split('?word=')
    @word_search.find(word)
  end
end
