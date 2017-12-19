class Game
  def initialize
    @random_number = rand(100)
    @guess_counter = 0
    @guess = guess
  end

  def info
    "You have taken #{@guess_counter} guesses" + last_guess
  end

  def last_guess
    "Your last guess, #{@guess}, was #{evaluate_guess}" if @guess
  end

  def evaluate_guess
    if @guess > @random_number
      return "too high"
    elsif @guess < @random_number
      return "too low"
    else
      return "correct"
    end
  end

  def guess(guess)
    @guess = guess
    @guess_counter += 1
  end
end
