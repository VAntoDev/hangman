class Board
  attr_accessor :correct_letters
  def initialize(secret_word, correct_letters = [])
    @secret_word = secret_word
    @secret_word_arr = @secret_word.chars
    @correct_letters = correct_letters
  end

  def display
    @secret_word_arr.each do | letter |
      if @correct_letters.include?(letter)
        print "#{letter} "
      else
        print "_ "
      end
    end
    puts ""
  end

  def add_correct_letter(letter)
    @correct_letters.push(letter)
  end
end