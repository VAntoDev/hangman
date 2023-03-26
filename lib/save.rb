require 'yaml'

class Save
  attr_accessor :secret_word, :errors, :correct_letters, :incorrect_letters, :used_words
  def initialize(secret_word, errors, correct_letters = [], incorrect_letters = [], used_words = [])
    @secret_word = secret_word
    @errors = errors
    @correct_letters = correct_letters
    @incorrect_letters = incorrect_letters
    @used_words = used_words
    serialize
  end

  def serialize
    data = YAML.dump ({
      :secret_word => @secret_word,
      :errors => @errors,
      :correct_letters => @correct_letters,
      :incorrect_letters => @incorrect_letters,
      :used_words => @used_words
    })
    File.open("saves/save-#{Dir.glob('saves/*').length}.txt", 'w'){|f| f.write(data)}
  end

  def self.unserialize(string)
    data = YAML.load string
    p data
    Save.new(data[:secret_word], data[:errors], data[:correct_letters], data[:incorrect_letters], data[:used_words])
  end
end