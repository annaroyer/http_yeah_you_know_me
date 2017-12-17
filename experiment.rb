#start server instance: have it listen on port 9292
require 'socket'
tcp_server = TCPServer.new(9292)
client = tcp_server.accept

#read request from client object(IO stream)
#keep reading until response is a blank line and store all responses in array, request_lines
puts "Ready for a request"
request_lines = []
while line = client.gets and !line.chomp.empty?
  request_lines << line.chomp
end

#it'll hang on to the gets method call waiting for a response to come in
#when it gets the response, we will put it to the screen and inspect it for debugging
puts "Got this request:"
puts request_lines.inspect

#build a response
#print out the request data as a response
puts "Sending response."
response = "<pre>" + request_lines.join("\n") + "</pre>"
output = "<html><head></head><body>#{response}</body></html>"
headers = ["http/1.1 200 ok",
          "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
          "server: ruby",
          "content-type: text/html; charset=iso-8859-1",
          "content-length: #{output.length}\r\n\r\n"].join("\r\n")
client.puts headers
client.puts output

#close up the server
puts ["Wrote this response:", headers, output].join("\n")
client.close
puts "\nResponse complete, exiting."
