require './test/test_helper'

class RequestTest < Minitest::Test
  def setup
    @request_string = "GET / HTTP/1.1
    Host: 127.0.0.1:9292
    Connection: keep-alive
    Cache-Control: max-age=0
    Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
    Upgrade-Insecure-Requests: 1
    User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36
    Accept-Encoding: gzip, deflate, sdch
    Accept-Language: en-US,en;q=0.8"
end

  def test_it_takes_a_request_string_and_finds_the_verb
    request = Request.new(@request_string)

    assert_equal "GET", request.verb
  end

  def test_it_takes_a_request_string_and_finds_the_path
    request = Request.new(@request_string)

    assert_equal "/", request.path
  end

  def test_it_takes_a_request_string_and_finds_the_verb
    request = Request.new(@request_string)

    assert_equal "GET", request.verb
  end




end
