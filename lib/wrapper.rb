class Wrapper

  STATUS_CODES = {'POST' => "302 Moved Permanently", "GET" => "200 ok"}

  def initialize(request, response)
    @request = request
    @status_code = STATUS_CODES[@request.verb]
    @location = nil
    @output = "<html><head></head><body><pre>#{response}<pre></body></html>"
  end

  def output
    if @request.verb == 'POST'
      @location = @request.location
      return headers
    else
      return headers + @output
    end
  end

  def headers
    ["HTTP/1.1 302 Moved Permanently\r\n",
     @location,
     "Server: ruby\r\n",
     "Content-Type: text/html; charset=iso-8859-1\r\n",
     "Content-Length: #{@output.length}\r\n\r\n"].join
   end
end
