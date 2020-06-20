# Mastermind in the console

COLORS = ["red", "blue", "purple", "green", "yellow", "orange"]
COLORS_LETTER = ["r", "b", "p", "g", "y", "o"]

class Game
  # handles the logic of playing the game
  attr_accessor :code, :guess_tracker, :guess_number

  def initialize
    @guesses = []
    @valid_guesses = ["r", "b", "p", "g", "y", "o"]
    @code = generate_code
    @guess_tracker = Array.new(12) { Array.new(2) }
    @guess_number = 0
  end

  def generate_code
    code = []
    4.times do 
      code.append(COLORS_LETTER.sample)
    end
    code
  end

  def request_guess
    # gets guess from human player
    # guess is stored as an array, e.g. ["r", "b", "p", "y"]
    puts "Enter your guess, using a letter to designate each color,"
    puts " and separated by spaces"
    loop do 
      puts "red = r, blue = b, purple = p, green = g, yellow = y, orange = o"
      print "Guess: "
      guess = gets.chomp.downcase.split(' ')
      valid_colors = !guess.any? {|e| !@valid_guesses.include?(e)}
      if guess.size == 4 && valid_colors
        unless @guesses.include?(guess)
          @guesses.append(guess)
          p @guesses
          return guess
        end
      end
      puts "Please enter a valid guess."
    end
  end

  def code_guessed?(guess)
    # returns true if the code was correctly guessed
    guess == code
  end

  def evaluate_guess(guess)
    # a red peg designates correct color and location
    # a white peg designates correct color
    # returns a hash with the number of red and white pegs
    guess_evaluation = {reds: 0, whites: 0}
    code_hash = code.each_with_object(Hash.new(0)) do |letter, new_hash|
      new_hash[letter] += 1
    end
    for i in 0..3
      if code.include?(guess[i])
        if code[i] == guess[i]
          guess_evaluation[:reds] += 1
          code_hash[guess[i]] -= 1
        elsif code_hash[guess[i]] > 0
          guess_evaluation[:whites] += 1
          code_hash[guess[i]] -= 1
        end
      end
    end
    guess_tracker[guess_number][0] = guess
    guess_tracker[guess_number][1] = guess_evaluation
  end

  def print_board
    # prints the current state of the board
    current_guesses = guess_tracker[0..guess_number]
    current_guesses.each do |element|
      element[0].each { |let| print let + " | "}
      print "| "
      print_evaluation(element[1])
    end

  end

  def print_evaluation(eval)
    # prepares evaluation for printing
    eval.each do |color, num|
      color == :reds ? (print "R" * num) : (print "W" * num)
    end
    print "\n"
  end


end

class Board
  # handles generating and outputing the board 
  attr_reader :board

  def initialize
    # code
  end
end

test = Game.new
p test.code
guess = test.request_guess
test.evaluate_guess(guess)
test.print_board