require 'pry'
require 'socket'

class Request
  attr_reader :path,
              :param,
              :verb,
              :guess

  def initialize(client)
    headers = []
    while line = client.gets and !line.chomp.empty?
      headers << line.chomp
    end
    @verb, path, @protocol = headers[0].split
    @path, @param = path.split('?word=')
    parse(headers)
    if @verb == 'POST'
      body = client.read(@content_length)
      @guess = body.split("\r\n")[3].to_i
    end
  end

  def parse(headers)
    headers[1..-1].each do |line|
      key, value = line.chomp.split(': ')
      case key
      when 'Host' then @host, @port = value.split(':')
      when 'Accept' then @accept = value
      when 'Content-Length' then @content_length = value.to_i
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
