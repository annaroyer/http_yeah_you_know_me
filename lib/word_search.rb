class WordSearch
  def initialize(dictionary='/usr/share/dict/words')
    @dictionary = dictionary
  end

  def find(word)
    File.readlines(@dictionary).each do |line|
      if word == line.chomp
        return "#{word} is a known word"
      end
    end
    return "#{word} is not a known word"
  end
end
