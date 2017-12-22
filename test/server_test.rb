require './test/test_helper'

class ServerTest < Minitest::Test

  def test_it_responds_to_http_requests_with_valid_html
    skip
    response = Faraday.get 'http://127.0.0.1:9292/hello'

    expected = "<html><head></head><body><pre>Hello World! (1)<pre></body></html>"

    assert_equal expected, response.body
  end

  def test_it_increments_the_request_counter_until_the_server_is_restarted
    skip
    2.times do
      Faraday.get 'http://localhost:9292/hello'
    end
    response = Faraday.get 'http://localhost:9292/hello'

    expected = "<html><head></head><body><pre>Hello World! (3)<pre></body></html>"

    assert_equal expected, response.body
  end

  def test_it_responds_to_a_request_with_the_formatted_request
    skip
    response = Faraday.get 'http://localhost:9292/'

    formatted_string = "
     Verb: GET
     Path: /
     Protocol: HTTP/1.1
     Host: 127.0.0.1
     Port: 9292
     Origin: 127.0.0.1
     Accept: */*"

    expected = "<html><head></head><body><pre>#{formatted_string}<pre></body></html>"

    assert_equal expected, response.body
  end

  def test_it_responds_to_a_request_with_todays_date_and_time
    skip
    response = Faraday.get 'http://localhost:9292/datetime'
    date_and_time = Time.now.strftime("%I:%M%p on %A, %B %-d, %Y")

    expected = "<html><head></head><body><pre>#{date_and_time}<pre></body></html>"

    assert_equal expected, response.body
  end

end
