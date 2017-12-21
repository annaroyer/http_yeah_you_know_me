class Game
  attr_reader :guess_counter

  def initialize(num1=0, num2=100)
    @random_number = rand(num1..num2)
    @guess_counter = 0
    @evaluation = ''
  end

  def evaluate
    if @guess
      evaluations = ['too low', 'correct', 'too high']
      score = evaluations[@guess <=> @random_number]
      @evaluation += "Last guess #{@guess} was #{score}"
    end
  end

  def get_info
    return "#{@guess_counter} total guesses. " + @evaluation
  end

  def guess(guess)
    @guess = guess
    @guess_counter += 1
  end
end
