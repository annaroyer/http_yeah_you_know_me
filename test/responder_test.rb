require './test/test_helper'
require './lib/responder'

class ResponderTest < Minitest::Test
  def setup
    @responder = Responder.new
  end

  def test_it_generates_a_response_based_on_the_request_path
    
end
