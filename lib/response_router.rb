class ResponseRouter
  def initialize
    @request_counter = 0
  end

  def route(request)
    

  def route
    response = case @request.path
      when '/hello' then "Hello World! (#{@request_counter})"
      when '/datetime' then Time.now.strftime("%I:%M%p on %A, %B %-d, %Y")
      when '/shutdown' then "Total requests: #{@request_counter}"
      when '/word_search' then search_word
      when '/start_game' then 'Good luck!'
    end
    return response
  end

  def search_word
    File.readlines('/usr/share/dict/words').each do |line|
      return "#{@request.param} is a known word" if @request.param == line.chomp
    end
    "#{@request.param} is not a known word"
  end
end
