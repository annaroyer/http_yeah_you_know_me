class WordSearch
  def initialize(dictionary='/usr/share/dict/words')
    @dictionary = dictionary
  end

  def find(word)
    File.readlines(@dictionary).each do |line|
      return "#{word} is a known word" if word == line.chomp
    end
    return "#{word} is not a known word"
  end
end
