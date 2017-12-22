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
  end

  def test_it_creates_a_header_depending_on_the_path
    request_line_headers = request_headers('GET /hello HTTP/1.1')
    request = Request.new(request_line_headers)
    result = 'Hello World! (5)'
    wrapper = Wrapper.new(request, result)

    expected = ["HTTP/1.1 200 ok",
      "Server: ruby",
      "Content-Type: text/html; charset=iso-8859-1",
      "Content-Length: #{65}\r\n\r\n"].join("\r\n")

    assert_equal expected, wrapper.headers
  end

  def test_it_creates_a_different_header_for_a_post_request
    request_line_headers = request_headers('POST /start_game HTTP/1.1')
    request = Request.new(request_line_headers)
    result = '4 total guesses. 89 was too high'
    wrapper = Wrapper.new(request, result)

    expected = ["HTTP/1.1 302 Moved Permanently",
      "Server: ruby",
      "Content-Type: text/html; charset=iso-8859-1",
      "Content-Length: #{81}\r\n\r\n"].join("\r\n")

    assert_equal expected, wrapper.headers
  end

  def test_it_creates_a_header_for_a_system_error
    request_line_headers = request_headers('GET /force_error HTTP/1.1')
    request = Request.new(request_line_headers)
    result = '500 SystemError'
    wrapper = Wrapper.new(request, result)

    expected = ["HTTP/1.1 500 Internal Server Error",
      "Server: ruby",
      "Content-Type: text/html; charset=iso-8859-1",
      "Content-Length: #{64}\r\n\r\n"].join("\r\n")

    assert_equal expected, wrapper.headers
  end

  def test_it_creates_a_header_for_an_unknown_path
    request_line_headers = request_headers('GET /fomafalou HTTP/1.1')
    request = Request.new(request_line_headers)
    result = '404 Not Found'
    wrapper = Wrapper.new(request, result)

    expected = ["HTTP/1.1 404 Not Found",
      "Server: ruby",
      "Content-Type: text/html; charset=iso-8859-1",
      "Content-Length: #{62}\r\n\r\n"].join("\r\n")

    assert_equal expected, wrapper.headers
  end

  def test_it_builds_header_and_body_output
    request_line_headers = request_headers('GET /datetime HTTP/1.1')
    request = Request.new(request_line_headers)
    result = Time.now.strftime("%I:%M%p on %A, %B %-d, %Y")
    wrapper = Wrapper.new(request, result)

    expected = ["HTTP/1.1 200 ok\r\n",
      "Server: ruby\r\n",
      "Content-Type: text/html; charset=iso-8859-1\r\n",
      "Content-Length: #{85}\r\n\r\n",
      "<html><head></head><body><pre>#{result}<pre></body></html>"].join

    assert_equal expected, wrapper.output
  end

  def test_it_outputs_headers_with_changed_location_for_post_requests
    request_line_headers = request_headers('POST /start_game HTTP/1.1')
    request = Request.new(request_line_headers)
    result = '4 total guesses. 89 was too high'
    wrapper = Wrapper.new(request, result)

    expected = ["HTTP/1.1 302 Moved Permanently",
      "Location: http://127.0.0.1:9292/start_game",
      "Server: ruby",
      "Content-Type: text/html; charset=iso-8859-1",
      "Content-Length: #{81}\r\n\r\n"].join("\r\n")

    assert_equal expected, wrapper.output
  end
end
