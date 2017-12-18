require 'minitest/autorun'
require 'minitest/pride'
require 'faraday'
require './lib/server'
require './lib/request'

class ServerTest < Minitest::Test
  # def setup
  #   @server = Server.new
  #   @server.request
  # end

  def test_it_responds_to_http_requests_with_valid_html
    response = Faraday.get 'http://localhost:9292/hello'

    expected = "<html><head></head><body><pre>Hello World! (1)<pre></body></html>"

    assert_equal expected, response.body
  end
end
