# frozen_string_literal: true

# handles the random generation of the secret word
class Word
  attr_accessor :word

  def initialize
    @word = filtered_word
  end

  def filtered_word
    rand_word = pick_rand_word.chomp
    return rand_word if rand_word.length > 4 && rand_word.length < 13

    filtered_word
  end

  def pick_rand_word
    dictionary = File.open('google-10000-english-no-swears.txt', 'r')
    word = dictionary.readlines[Random.new.rand(0..9895)]
    dictionary.close
    word.upcase
  end
end
