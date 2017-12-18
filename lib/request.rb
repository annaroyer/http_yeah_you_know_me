require 'pry'
require 'socket'

class Request
  attr_reader :path,
              :param,
              :verb

  def initialize(request)
    @verb, path, @protocol = request.lines[0].split
    @path, @param = path.split('?word=')
    parse(request.lines)
  end

  def parse(request)
    request[1..-1].each do |line|
      key, value = line.chomp.split(': ')
      if key == 'Host'
        @host, @port = value.split(':')
      elsif key == 'Accept'
        @accept = value
      end
    end
  end

  def format
   "
    Verb: #{@verb}
    Path: #{@path}
    Protocol: #{@protocol}
    Host: #{@host}
    Port: #{@port}
    Origin: #{@host}
    Accept: #{@accept}"
  end
end

binding.pry
