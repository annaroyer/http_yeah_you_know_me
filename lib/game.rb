class Game
  def initialize
    @random_number = rand(100)
    @guess_counter = 0
  end

  def info
    total_guesses =  "You have taken #{@guess_counter} guesses. "
    if @guess
      return total_guesses + "Your latest guess (#{@guess}) was #{evaluate}"
    else
      return total_guesses
    end
  end

  def evaluate
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
