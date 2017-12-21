require './test/test_helper'
require './lib/game'

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


  def test_it_evaluates_a_guess_against_the_random_number
    random_number = 78
    game = Game.new(random_number, random_number)

    game.guess(59)
    result_1 = game.evaluate
    game.guess(99)
    result_2 = game.evaluate
    game.guess(78)
    result_3 = game.evaluate

    assert_equal 'too low', result_1
    assert_equal 'too high', result_2
    assert_equal 'correct', result_3
  end

  def test_it_evaluates_and_gives_information_on_latest_guess_and_total_guesses
    random_number = 50
    game = Game.new(random_number, random_number)
    game.guess(57)
    assert_equal '1 total guesses. Your last guess (57) was too high', game.get_info

    game.guess(41)
    assert_equal '2 total guesses. Your last guess (41) was too low', game.get_info

    game.guess(50)
    assert_equal '3 total guesses. Your last guess (50) was correct', game.get_info
  end

  def test_it_does_not_give_evaluation_before_guesses_are_made_guesses
    game = Game.new
    assert_equal '0 total guesses.', game.get_info
  end
end
