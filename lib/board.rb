# frozen_string_literal: true

# handles the creation of the board in which the word is displayed
class Board
  attr_accessor :correct_letters, :incorrect_letters

  def initialize(secret_word, correct_letters = [], incorrect_letters = [])
    @secret_word = secret_word
    @secret_word_arr = @secret_word.chars
    @correct_letters = correct_letters
    @incorrect_letters = incorrect_letters
  end

  def display
    @secret_word_arr.each do |letter|
      if @correct_letters.include?(letter)
        print "#{letter} "
      else
        print '_ '
      end
    end
    puts ''
  end

  def add_correct_letter(letter)
    @correct_letters.push(letter)
  end

  def display_incorrect_letters
    puts "The incorrect letters you tried were: #{@incorrect_letters.join(' ')}"
  end

  def display_full_board
    self.display_incorrect_letters
    self.display
  end
end
