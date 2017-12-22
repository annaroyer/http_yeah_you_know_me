require './test/test_helper'
require './lib/wrapper'

class WrapperTest < Minitest::Test
  def test_it_takes_a_response_and_wraps_it_in_html
    wrapper = Wrapper.new(request)

    response = 'Hello World! (0)'
    expected = "<html><head></head><body><pre>Hello World! (0)</pre></body></html>"

    assert_equal wrapper.output(response), expected
  end

  def test_it_creates_a_header_depending_on_the_path
    
  end


end
