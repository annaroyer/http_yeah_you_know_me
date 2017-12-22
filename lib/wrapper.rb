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
      return flexible_headers
    else
      return basic_headers + @output
    end
  end

  def basic_headers
    "http/1.1 200 ok
     date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}
     server: ruby
     content-type: text/html; charset=iso-8859-1
     content-length: #{@output.length}\r\n\r\n"
  end

  def redirect_headers
    ["HTTP/1.1 302 Moved Permanently",
     "Location: http://127.0.0.1:9292/start_game",
     "Server: ruby",
     "Content-Type: text/html; charset=iso-8859-1",
     "Content-Length: #{@output.length}\r\n\r\n"].join("\r\n")
  end

  def flexible_headers
    ["HTTP/1.1 302 Moved Permanently\r\n",
     "#{@request.location}\r\n",
     "Server: ruby\r\n",
     "Content-Type: text/html; charset=iso-8859-1\r\n",
     "Content-Length: #{@output.length}\r\n\r\n"].join
   end
end
