class Game
  attr_reader :guess_counter,
              :guess

  def initialize(num1=0, num2=100)
    @random_number = rand(num1..num2)
    @guess_counter = 0
    @evaluation = ''
  end

  def evaluate
    scores = ['correct', 'too high', 'too low']
    scores[@guess <=> @random_number]
  end

  def get_info
    @evaluation = " (#{@guess}) is #{evaluate}" unless @guess_counter == 0
    return "#{@guess_counter} total guesses." + @evaluation
  end

  def take_guess(guess)
    @guess = guess
    @guess_counter += 1
  end
end
