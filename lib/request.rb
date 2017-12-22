require 'socket'

class Request
  attr_reader :path,
              :verb,
              :param,
              :content_length,
              :guess


  def initialize(request_lines)
    @verb, path, @protocol = request_lines[0].split
    @path, @param = path.split('?word=')
    parse(request_lines)
  end

  def parse(request_lines)
    request_lines[1..-1].each do |line|
      key, value = line.chomp.split(': ')
      case key
      when 'Host' then @host, @port = value.split(':')
      when 'Accept' then @accept = value
      when 'Content-Length' then @content_length = value.to_i
      end
    end
  end

  def find_guess(body)
    @guess = body.split("\r\n")[-2].to_i
  end

  def location
    return "Location: http://#{@host}:#{@port}#{@path}\r\n"
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
