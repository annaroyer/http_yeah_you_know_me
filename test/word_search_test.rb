require './test/test_helper'
require './lib/word_search'

class WordSearchTest < Minitest::Test
  def test_it_can_tell_you_if_it_is_a_known_word
    word_search = WordSearch.new('./test/mini_dictionary.txt')

    assert_equal word_search.find('butterfly'), 'butterfly is a known word'
  end

  def test_it_can_find_another_word_and_tells_you_it_is_known
    word_search = WordSearch.new('./test/mini_dictionary.txt')
    word_search.find('butterfly')

    assert_equal word_search.find('aardvark'), 'aardvark is a known word'
  end

  def test_it_tells_you_if_a_word_is_not_known
    word_search = WordSearch.new('./test/mini_dictionary.txt')

    assert_equal word_search.find('wahhh'), 'wahhh is not a known word'
  end
end
