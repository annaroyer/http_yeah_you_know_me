class Wrapper

  STATUS_CODES = {'POST/game' => "302 Moved Permanently",
                  'POST/start_game' => '302 Moved Permanently',
                  'POST/force_error' => '500 Internal Server Error',
                  'GET/' => "200 ok",
                  'GET/word_search' => '200 ok',
                  'GET/hello' => '200 ok',
                  'GET/game' => '200 ok',
                  'GET/start_game' => '200 ok',
                  'GET/datetime' => '200 ok',
                  'GET/shutdown' => '200 ok',
                  'GET/force_error' => '500 Internal Server Error'}
  STATUS_CODES.default = '404 Not Found'

  def initialize(request, response)
    @request = request
    @key = @request.verb + @request.path
    @status_code = STATUS_CODES[@key]
    @location = nil
    @output = "<html><head></head><body><pre>#{response}<pre></body></html>"
  end

  def output
    if @status_code == '302 Moved Permanently'
      @location = @request.location
      return headers
    else
      return headers + @output
    end
  end

  def headers
    ["HTTP/1.1 #{@status_code}\r\n",
     @location,
     "Server: ruby\r\n",
     "Content-Type: text/html; charset=iso-8859-1\r\n",
     "Content-Length: #{@output.length}\r\n\r\n"].join
  end
end
