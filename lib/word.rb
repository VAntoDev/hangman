class Word
  attr_accessor :word
  def initialize
    @word = filtered_word
  end

  def filtered_word
    rand_word = pick_rand_word.chomp
    if rand_word.length > 4 && rand_word.length < 13
      return rand_word
    end 
    filtered_word
  end

  def pick_rand_word
    dictionary = File.open("google-10000-english-no-swears.txt", "r")
    word = dictionary.readlines[Random.new.rand(0..9895)]
    dictionary.close
    return word.upcase
  end
end