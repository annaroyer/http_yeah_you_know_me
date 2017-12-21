require './test/test_helper'
require './lib/request'

class RequestTest < Minitest::Test
  def setup
    def request_headers(added_lines*)
      [added_lines,
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

  def test_it_takes_a_request_string_and_finds_the_verb
    request_1 = request_headers('GET / HTTP/1.1')
    request_2 = request_headers('POST /start_game HTTP/1.1')

    result_1 = Request.new(request_1)
    result_2 = Request.new(request_2)

    assert_equal 'GET', result_1.verb
    assert_equal 'POST', result_2.verb
  end

  def test_it_takes_a_request_string_and_finds_the_path
    request_1 = request_headers('GET /hello HTTP/1.1')
    request_2 = request_headers('GET /word_search?word=hello HTTP/1.1')
    request_3 = request_headers('GET /datetime HTTP/1.1')
    request_4 = request_headers('GET /shutdown HTTP/1.1')
    request_5 = request_headers('GET / HTTP/1.1')
    request_6 = request_headers('GET /game HTTP/1.1')
    request_7 = request_headers('POST /start_game HTTP/1.1')
    request_8 = request_headers('GET /game HTTP/1.1')

    result_1 = Request.new(request_1)
    result_2 = Request.new(request_2)
    result_3 = Request.new(request_3)
    result_4 = Request.new(request_4)
    result_5 = Request.new(request_5)
    result_6 = Request.new(request_6)
    result_7 = Request.new(request_7)
    result_8 = Request.new(request_8)


    assert_equal '/hello', result_1.path
    assert_equal '/word_search?word=hello', result_2.path
    assert_equal '/datetime', result_3.path
    assert_equal '/shutdown', result_4.path
    assert_equal '/', result_5.path
    assert_equal '/game', result_6.path
    assert_equal '/start_game', result_7.path
    assert_equal '/game', result_8.path
  end

#need to get an example post request string to use in all tests calling post requests..
  def test_it_takes_a_request_string_and_finds_the_content_length_of_body
    request = request_headers('POST /game HTTP/1.1')
    request << "content_length = 138"

  end

  def test_it_takes_a_request_string_and_reformats_the_important_values
    request = request_headers('GET /word_search?word=hello HTTP/1.1')

    result = Request.new(request)
    expected = "
    Verb: GET
    Path: /word_search?word=hello
    Protocol: HTTP/1.1
    Host: 127.0.0.1
    Port: 9292
    Origin: 127.0.0.1
    Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
    assert_equal expected, result.format
  end
end
