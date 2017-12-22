require './test/test_helper'
require './lib/responder'
require './lib/request'
require './lib/word_search'
require './lib/game'

class ResponderTest < Minitest::Test
  def setup
    def request_headers(first_line)
      [first_line,
      "Host: 127.0.0.1:9292",
      "Connection: keep-alive",
      "Cache-Control: no-cache",
      "Content-Type: application/x-www-form-urlencoded",
      "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84 Safari/537.36",
      "Postman-Token: 7c8882a7-5dbd-2372-b0fc-f44483937db5",
      "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
      "DNT: 1",
      "Accept-Encoding: gzip, deflate, br",
      "Accept-Language: en-US,en;q=0.9"]
    end
  end

  def test_it_responds_to_get_root_with_debugging_information
    responder = Responder.new
    request_lines = request_headers('GET / http/1.1')
    request = Request.new(request_lines)

    assert_equal request.format, responder.route(request)
  end

  def test_it_responds_to_get_hello_with_hello_world_and_request_count
    responder = Responder.new
    request_lines = request_headers('GET /hello http/1.1')
    request = Request.new(request_lines)

    assert_equal 'Hello World! (1)', responder.route(request)
  end

  def test_it_increments_the_request_counter_each_new_request
    responder = Responder.new
    request_lines = request_headers('GET /hello http/1.1')
    request_1 = Request.new(request_lines)
    responder.route(request_1)
    request_2 = Request.new(request_lines)

    assert_equal 'Hello World! (2)', responder.route(request_2)

    2.times {responder.route(Request.new(request_lines))}
    request_5 = Request.new(request_lines)

    assert_equal 'Hello World! (5)', responder.route(request_5)
  end

  def test_it_responds_to_get_datetime_with_the_current_date_and_time
    responder = Responder.new
    request_lines = request_headers('GET /datetime http/1.1')
    request = Request.new(request_lines)

    time_and_date = Time.now.strftime("%I:%M%p on %A, %B %-d, %Y")

    assert_equal time_and_date, responder.route(request)
  end

  def test_it_responds_to_get_shutdown_with_total_requests
    responder = Responder.new
    request_lines = request_headers('GET / http/1.1')
    5.times {responder.route(Request.new(request_lines))}
    request_lines_2 = request_headers('GET /shutdown http/1.1')
    request_6 = Request.new(request_lines_2)

    assert_equal 'Total requests: 6', responder.route(request_6)
  end

  def test_it_responds_to_a_get_word_search_request_with_a_word_search_result
    responder = Responder.new
    request_lines = request_headers('GET /word_search?word=hello http/1.1')
    request = Request.new(request_lines)
    binding.pry
    assert_equal 'hello is a known word', responder.route(request)
  end

  def test_search_word_creates_word_search_and_searches_for_word
    responder = Responder.new
    request_lines = request_headers('GET /word_search?word=hello http/1.1')
    request = Request.new(request_lines)
    responder.route(request)

    assert_equal 'hello is a known word', responder.search_word
  end

  def test_it_responds_to_a_get_start_game_request_with_good_luck
    responder = Responder.new
    request_lines = request_headers('GET /start_game http/1.1')
    request = Request.new(request_lines)

    assert_equal 'Good luck!', responder.route(request)
  end

  def test_get_start_game_request_starts_a_new_game
    responder = Responder.new
    assert_nil responder.game
    request_lines = request_headers('GET /start_game http/1.1')
    request = Request.new(request_lines)
    responder.route(request)

    assert_instance_of Game, responder.game
  end

  def test_it_responds_to_post_game_requests_by_making_a_new_guess_in_game
    responder = Responder.new
    request_lines_1 = request_headers('GET /start_game http/1.1')
    request_start = Request.new(request_lines_1)
    responder.route(request_start)

    assert_nil responder.game.guess

    request_lines_2 = request_headers('POST /game http/1.1')
    request_guess = Request.new(request_lines_2)
    request_guess_body = ["------WebKitFormBoundaryqommBwQNJyHZJ2L8",
                          "Content-Disposition: form-data; name='guess'\r\n",
                          "28",
                          "------WebKitFormBoundaryqommBwQNJyHZJ2L8--"].join("\r\n")
    request_guess.find_guess(request_guess_body)
    responder.route(request_guess)

    assert_equal 28, responder.game.guess
  end

end
