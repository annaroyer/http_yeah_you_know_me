class RequestParser
  def initialize(request)
    @request_lines = request.lines
    @elements = {}
  end

  def parse_first_line
    verb, path, protocol = @request_lines[0].split
    @elements[Verb:] = verb
    @elements[Path:] = path
    @elements[Protocol:] = protocol
  end
  
  def parse
    parse_first_line
    @request_lines[1..-1].each do |line|
      key, value = line.split(': ')
      if key == 'Host'
        value, port = value.split(':')
        @elements[Port:] = port
      end
      @elements[key.to_sym] = value.chomp
    end
  end
end
