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
    if start == true
      return
    end
    loop do
      case check_guess(ask_guess)
      when true
        puts "You win!!"
        break
      when 'SAVING'
        puts "File saved! Thanks for playing, you can load it restarting the program."
        break
      end
      #if check_guess(ask_guess) == true
      #  puts "You win!!"
      #  break
      #end
      if @errors == 6
        puts "You made 6 errors, you lost! The secret word was #{@secret_word}"
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
      @secret_word = @secret_word.word
      @current_board = Board.new(@secret_word)
      @current_board.display
    else
      if Save.display_all_saves == true
        puts "You don't have any saves yet!"
        return true
      end
      puts "Choose which of the files you want to load:"
      file_choice = gets.chomp
      file = Save.unserialize(URI.open("saves/save-#{file_choice}.txt", "r"))
      @current_board = Board.new(file.secret_word, file.correct_letters, file.incorrect_letters)
      @secret_word = file.secret_word
      @errors = file.errors
      @used_words = file.used_words
      puts "Game loaded! Lets continue from where we left the last time: \n"
      @current_board.display
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
    puts "\nWrite a letter or a word. If you want to save type: '-save'"
    choice = gets.chomp.upcase
    if choice == "-SAVE"
      puts "Choose the file name:"
      file_name = gets.chomp.upcase
      new_save = Save.new(@secret_word, @errors, @current_board.correct_letters, @current_board.incorrect_letters, @used_words, file_name)
      new_save.serialize
      puts "File saved in slot: #{Dir.glob('saves/*').length}"
      return 'GAME-SAVING'
    end
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
    if player_choice == "GAME-SAVING"
      return 'SAVING'
    end
    if player_choice.length > 1
      puts "Lets see if the word '#{player_choice}' is right:"
      if player_choice == @secret_word.upcase
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
    if @secret_word.chars.include?(letter)
      @current_board.add_correct_letter(letter)
      @current_board.display
      letters_guessed = 0
      @secret_word.chars.each do | correct_letter | 
        if @current_board.correct_letters.include?(correct_letter)
          letters_guessed += 1
        end
        if letters_guessed == @secret_word.chars.length
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