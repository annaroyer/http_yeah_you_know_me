class Game
  def initialize
    @random_number = rand(100)
    @guess_counter = 0
    @guess = guess
  end

  def info
    return "You have taken #{guess_counter} guesses. " + latest_guess
  end

  def latest_guess
    return "Your latest guess (#{@guess}) was #{evaluate_guess}" if @guess
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
    info
  end
end
