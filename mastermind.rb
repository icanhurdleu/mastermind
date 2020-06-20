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
    @guess_tracker = create_empty_guess_tracker
    @guess_number = 0
  end

  def intro
    puts "\n\nWelcome to Mastermind!"
    puts "In this game you will be tasked to guess a randomly generated code"
    puts "The available colors and their designations are:"
    puts "\tred = r \n\tblue = b \n\tpurple = p \n\tgreen = g \n\tyellow = y \n\torange = o"
    puts "\nYou have 12 total turns to guess the code."
    puts "Each turn, your guess will be evaluated and displayed."
    puts "'R' designates a correct color and correct location."
    puts "'W' designates a correct color but incorrect location."
    puts "Good luck!\n"
  end 

  def play
    loop do 
      if @guess_number == 12
        puts "Sorry..., you did not guess the code."
        return
      end
      guess = request_guess
      if guess == code
        puts "\n*******************************"
        puts "Congrats! You guessed the code!"
        puts "*******************************"
        return
      end
      evaluate_guess(guess)
      print_board
      @guess_number += 1
    end
  end


  def generate_code
    code = []
    4.times do 
      code.append(COLORS_LETTER.sample)
    end
    code
  end

  def create_empty_guess_tracker
    Array.new(12) { Array.new(2) }
  end

  def request_guess
    # gets guess from human player
    # guess is stored as an array, e.g. ["r", "b", "p", "y"]
    puts "\nEnter your guess, using a letter to designate each color,"
    puts " and separated by spaces"
    loop do 
      puts "red = r, blue = b, purple = p, green = g, yellow = y, orange = o"
      print "Guess: "
      guess = gets.chomp.downcase.split(' ')
      valid_colors = !guess.any? {|e| !@valid_guesses.include?(e)}
      if guess.size == 4 && valid_colors
        unless @guesses.include?(guess)
          @guesses.append(guess)
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
    # add reds
    for i in 0..3
      if code.include?(guess[i])
        if code[i] == guess[i]
          guess_evaluation[:reds] += 1
          code_hash[guess[i]] -= 1
        # elsif code_hash[guess[i]] > 0
        #   guess_evaluation[:whites] += 1
        #   code_hash[guess[i]] -= 1
        end
      end
    end
    # add whites
    for i in 0..3
      if code.include?(guess[i])
        if code_hash[guess[i]] > 0
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

example_game = Game.new
example_game.intro
example_game.play