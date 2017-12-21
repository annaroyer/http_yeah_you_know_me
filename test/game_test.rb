require './test/test_helper'
require_relative '../lib/game'

class GameTest < Minitest::Test
  def test_it_starts_with_zero_guesses
    game = Game.new

    assert_equal 0, game.guess_counter
  end

  def test_it_counts_how_many_guesses_have_been_made
    game = Game.new
    game.guess(10)
    assert_equal 1, game.guess_counter

    game.guess(47)
    assert_equal 2, game.guess_counter

    game.guess(86)
    assert_equal 3, game.guess_counter
  end

  def test_it_evaluates_and_gives_information_on_latest_guess_and_total_guesses
    game = Game.new(50,50)
    game.guess(57)
    assert_equal '1 total guesses. Last guess (57) was too high', game.get_info

    game.guess(41)
    assert_equal '2 total guesses. Last guess (41) was too low', game.get_info

    game.guess(57)
    assert_equal '3 total guesses. Last guess (57) was correct', game.get_info
  end

  def test_it_does_not_give_evaluation_before_guesses_are_made_guesses
    game = Game.new
    assert_equal '0 total guesses', game.get_info
  end
end
