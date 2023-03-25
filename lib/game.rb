require_relative './word.rb'
require_relative './board.rb'
require_relative './save.rb'
require 'open-uri'

class Game
  def initialize
    @used_words = []
    execution
  end

  def execution
    start
    loop do
      if check_guess(ask_guess) == true
        puts "You win!!"
        break
      end
      if @errors == 6
        puts "You made 6 errors, you lost! The secret word was #{@secret_word.word}"
        break
      end
    end
  end
  
  def start
    @errors = 0
    puts "This is Hangman! Do you want to play(1) or load a saved game(2)?"
    if get_choice == 1
      @secret_word = Word.new
      puts "Lets start a new game! \nSecret word generated."
      @current_board = Board.new(@secret_word.word)
      @current_board.display
    else
      new_save = Save.new("CIAO",2)
      new_save.serialize
      # new_save.unserialize(new_save.serialize) working
      file = new_save.unserialize(URI.open("saves/new-file.txt", "r"))
      puts "Errors: #{file.errors}"
      puts "Secret word: #{file.secret_word}"
      puts "Correct_letters: #{file.correct_letters}"

      # @secret_word = serialized_secret_word     unrelated for now
      # @current_board = Board.new(serialized_secret_word)
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
    puts "\nWrite a letter or a word."
    choice = gets.chomp.upcase
    choice.gsub!(/[^A-Za-z]/, '')
    if @used_words.include?(choice)
      puts "You already used that letter or word! Try again."
      @current_board.display
      return ask_guess
    elsif choice.length < 1
      puts "Invalid input! Try again with a word or a letter"
      @current_board.display
      return ask_guess
    end
    @used_words.push(choice)
    return choice
  end

  def check_guess(player_choice)
    if player_choice.length > 1
      puts "Lets see if the word '#{player_choice}' is right:"
      if player_choice == @secret_word.word.upcase
        return true
      else
        @errors += 1
        puts "The word is incorrect, +1 error. Current number of errors: #{@errors}"
        @current_board.display
      end
    else
      puts "Lets see if the letter '#{player_choice}' is present in the word"
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
          return true
        end
      end
    else
      @errors += 1
      puts "The letter is not present in the secret word! Current number of errors: #{@errors}"
      @current_board.incorrect_letters.push(letter)
      @current_board.display_incorrect_letters
      @current_board.display
    end
  end
end

# Implement game saves, the player can choose where to save their game and save it in the saves directory
# at the start of the game the player can load a save 
# during any point in the game the player can save the game.
# When the game is saved the instance varaibles @errors, @secret_word.word, @correct_letters and @incorrect_letters