# frozen_string_literal: true

require_relative './word'
require_relative './board'
require_relative './save'
require 'open-uri'

# handles the game execution
class Game
  attr_accessor :file

  def initialize
    @used_words = []
    execution
  end

  def execution
    return if start == true

    loop do
      case check_guess(ask_guess)
      when true
        puts 'You win!!'
        break
      when 'SAVING'
        puts 'Thanks for playing! You can load your save by restarting the program.'
        break
      end
      if @errors == 6
        puts "You made 6 errors, you lost! The secret word was #{@secret_word}"
        break
      end
    end
  end

  def start
    @errors = 0
    puts 'This is Hangman! Do you want to play(1) or load a saved game(2)?'
    if get_choice == 1
      generate_secret_word
    else
      return true if check_saves == true
      return true if file_load_choice == true
    end
    @current_board.display
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
      save_current_file
      return 'GAME-SAVING'
    end
    choice.gsub!(/[^A-Za-z]/, '')
    if @used_words.include?(choice)
      puts 'You already used that letter or word! Try again.'
      @current_board.display
      return ask_guess
    elsif choice.length < 1
      puts 'Invalid input! Try again with a word or a letter'
      @current_board.display
      return ask_guess
    end
    @used_words.push(choice)
    return choice
  end

  def check_guess(player_choice)
    if player_choice == 'GAME-SAVING'
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
      @secret_word.chars.each do |correct_letter| 
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

  def generate_secret_word
    @secret_word = Word.new
    puts "Lets start a new game! \nSecret word generated."
    @secret_word = @secret_word.word
    @current_board = Board.new(@secret_word)
  end

  def check_saves
    if Save.display_all_saves == true
      puts "You don't have any saves yet!"
      return true
    end
  end

  def file_load_choice
    begin
      puts "Choose which of the saves you want to load by number (example:1)\nIf you want to delete all the saves type: -delete"
      get_load_choice
    rescue
      puts "This save doesn't exist! Retry, remember to not use any spaces."
      retry
    end
    load_save
  end

  def get_load_choice
    file_choice = gets.chomp
    if file_choice == '-delete'
      return true if Save.delete_all_saves == true
    else
      @file = Save.unserialize(URI.open("saves/save-#{file_choice}.txt", "r"))
    end
  end

  def load_save
    @current_board = Board.new(file.secret_word, file.correct_letters, file.incorrect_letters)
    @secret_word = file.secret_word
    @errors = file.errors
    @used_words = file.used_words
    puts "Game loaded! Lets continue from where we left the last time: \n"
  end

  def save_current_file
    puts 'Choose the save name:'
    file_name = gets.chomp.upcase
    new_save = Save.new(@secret_word, @errors, @current_board.correct_letters, @current_board.incorrect_letters, @used_words, file_name)
    new_save.serialize
    puts "Game saved in slot: #{Dir.glob('saves/*').length}"
  end
end
