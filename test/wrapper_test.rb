require './test/test_helper'
require './lib/wrapper'
require './lib/request'

class WrapperTest < Minitest::Test
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
    request_2 = request_headers('GET /word_search?word=hello HTTP/1.1')
    request_3 = request_headers('GET /datetime HTTP/1.1')
    request_4 = request_headers('GET /shutdown HTTP/1.1')
    request_5 = request_headers('GET / HTTP/1.1')
    request_6 = request_headers('GET /game HTTP/1.1')
    request_7 = request_headers('POST /start_game HTTP/1.1')
    request_8 = request_headers('GET /game HTTP/1.1')
  end

  def test_it_creates_a_header_depending_on_the_path
    request_line_headers = request_headers('GET /hello HTTP/1.1')
    request = Request.new(request_line_headers)
    result = 'Hello World! (5)'
    wrapper = Wrapper.new(request, result)

    expected = ["HTTP/1.1 200 ok",
      "Server: ruby",
      "Content-Type: text/html; charset=iso-8859-1",
      "Content-Length: #{65}\r\n"].join("\r\n")

    assert_equal expected, wrapper.headers
  end

  def test_it_creates_a_different_header_for_a_different_request
    request_line_headers = request_headers('POST /start_game HTTP/1.1')
    request = Request.new(request_line_headers)
    result = '4 total guesses. 89 was too high'
    wrapper = Wrapper.new(request, result)

    expected = ["HTTP/1.1 302 Moved Permanently",
      "Location: http://127.0.0.1:9292/start_game",
      "Server: ruby",
      "Content-Type: text/html; charset=iso-8859-1",
      "Content-Length: #{81}\r\n"].join("\r\n")

    assert_equal expected, wrapper.headers
  end

  def 
end
