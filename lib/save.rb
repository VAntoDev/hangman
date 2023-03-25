require 'yaml'

class Save
  attr_accessor :secret_word, :errors, :correct_letters, :incorrect_letters
  def initialize(secret_word, errors, correct_letters = [], incorrect_letters = [])
    @secret_word = secret_word
    @errors = errors
    @correct_letters = correct_letters
    @incorrect_letters = incorrect_letters
  end

  def create_new_save
    File.open("saves/new-file.txt", 'w'){|f| f.write(data)}
    #self.serialize
  end

  def serialize
    data = YAML.dump ({
      :secret_word => @secret_word,
      :errors => @errors,
      :correct_letters => @correct_letters,
      :incorrect_letters => @incorrect_letters
    })
    File.open("saves/new-file.txt", 'w'){|f| f.write(data)}
  end

  def unserialize(string)
    data = YAML.load string
    p data
    Save.new(data[:secret_word], data[:errors], data[:correct_letters], data[:incorrect_letters])
  end
end