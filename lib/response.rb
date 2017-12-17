require 'pry'

class Response
  def route
    if @path == '/'
      "#{@formatted_request}"
    elsif @path == '/hello'
      "Hello World(#{@requests})"
    elsif @path == '/datetime'
      "#{Time.now.strftime("%I:%M%p on %A, %B %-d, %Y")}"
    elsif @path == '/shutdown'
      "Total requests: #{@requests}"
    elsif @path == '/word_search'
      search_word(param)
    end
  end

  def search_word(word)
    File.readlines('/usr/share/dict/words').each do |line|
      return "#{word} is a known word" if word == line.chomp
    end
    return "#{word} is not a known word"
  end

  def response
    "<pre>\n#{route}</pre>"
  end
end

binding.pry
