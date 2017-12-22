require './test/test_helper'

class ServerTest < Minitest::Test

  def test_it_responds_to_http_requests
    response = Faraday.get 'http://127.0.0.1:9292/start_game'

    expected = "<html><head></head><body><pre>Good luck!<pre></body></html>"

    assert_equal expected, response.body
  end

  def test_it_responds_to_a_request_with_the_formatted_request
    response = Faraday.get 'http://localhost:9292/'

    formatted_string = "
    Verb: GET
    Path: /
    Protocol: HTTP/1.1
    Host: localhost
    Port: 9292
    Origin: localhost
    Accept: */*"

    expected = "<html><head></head><body><pre>#{formatted_string}<pre></body></html>"

    assert_equal expected, response.body
  end

  def test_it_responds_to_a_request_with_todays_date_and_time
    response = Faraday.get 'http://localhost:9292/datetime'
    date_and_time = Time.now.strftime("%I:%M%p on %A, %B %-d, %Y")

    expected = "<html><head></head><body><pre>#{date_and_time}<pre></body></html>"

    assert_equal expected, response.body
  end
end
