require_relative './word.rb'
require_relative './board.rb'

class Game
  def initialize
    @used_words = []
    execution
  end

  def execution
    start
    loop do
      check_guess(ask_guess)
    end
  end
  
  def start
    puts "This is Hangman! Do you want to play(1) or load a saved game(2)?"
    if get_choice == 1
      @secret_word = Word.new
      puts "Lets start a new game! \nSecret word generated. It is #{@secret_word.word}"
      @current_board = Board.new(@secret_word.word)
      @current_board.display
    else
      puts "Saved games feature yet to be implemented"
    end
  end

  def get_choice
    loop do
      choice = gets.chomp.to_i
      if choice == 1 || choice == 2
        return choice
      end
      puts "Invalid input! Retry with '1' or '2'."
    end
  end

  def ask_guess
    puts "Write a letter or a word."
    choice = gets.chomp.upcase
    if @used_words.include?(choice)
      puts "You already used that letter or word! Try again."
      return ask_guess
    elsif choice.length < 1 
      puts "Invalid input! Try again with a word or a letter"
      return ask_guess
    end
    @used_words.push(choice)
    return choice
  end

  def check_guess(player_choice)
    puts "Lets see if '#{player_choice}' is present in the word"
    if player_choice.length > 1
      if player_choice == @secret_word.word.upcase
        return puts "YOU WIN!"
      else
        return puts "The word is incorrect, +1 error"
      end
    else
      puts "Checks if the letter given is present in the word gives feedback based on it"
      check_letter(player_choice)
    end
  end

  def check_letter(letter)
    if @secret_word.word.chars.include?(letter)
      @current_board.add_correct_letter(letter)
      @current_board.display
      letters_guessed = 0
      @secret_word.word.chars.each do | correct_letter | 
        if @current_board.correct_letters.include?(correct_letter)
          letters_guessed += 1
        end
        if letters_guessed == @secret_word.word.chars.length
          puts "U win!"
        end
      end
    else
      puts "The letter is not present in the secret word! +1 error"
    end
  end
end

# create Board class
# board in which the letters that the player guessed are displayed and the other letters aren't (example: b r _ _ d)
# 