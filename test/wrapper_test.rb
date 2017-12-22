require './test/test_helper'
require './lib/wrapper'

class PackagerTest < Minitest::Test
  def test_it_takes_a_response_and_wraps_it_in_html
    packager = Packager.new

    response = 'Hello World (0)'
    expected = "<html><head></head><body><pre>Hello World! (0)</pre></body></html>"

    assert_equal packager.output(response), expected
  end


end
