require 'pry'
require 'socket'

class Request
  def initialize(request)
    @verb, @path, @protocol = request.lines[0].split
    @host = parse(request.lines)['Host']
    @accept = parse(request.lines)['Accept']
  end

  def parse(request)
    headers = {}
    request[1..-1].each do |line|
      key, value = line.split(':')
      if ['Host', 'Accept'].include?(key)
        headers[key] = value.strip
      end
    end
    headers
  end
end

binding.pry
