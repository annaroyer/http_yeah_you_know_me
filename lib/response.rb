require 'pry'

class Response
  def route(path)
    case path
    when '/' then "#{@formatted_request}"
    when '/hello' then "Hello World(#{@requests})"
    when '/datetime' then "#{Time.now.strftime("%I:%M%p on %A, %B %-d, %Y")}"
    when '/shutdown' then "Total requests: #{@requests}"
    when '/word_search' then search_word(word)
    end
  end

  def search_word(word)
    File.readlines('/usr/share/dict/words').each do |line|
      return "#{word} is a known word" if word == line.chomp
    end
    return "#{word} is not a known word"
  end
end

binding.pry
