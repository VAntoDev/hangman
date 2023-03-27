require 'yaml'

class Save
  attr_accessor :secret_word, :errors, :correct_letters, :incorrect_letters, :used_words, :file_name 
  def initialize(secret_word, errors, correct_letters = [], incorrect_letters = [], used_words = [], file_name)
    @secret_word = secret_word
    @errors = errors
    @correct_letters = correct_letters
    @incorrect_letters = incorrect_letters
    @used_words = used_words
    @file_name = file_name
  end

  def serialize
    data = YAML.dump ({
      :secret_word => @secret_word,
      :errors => @errors,
      :correct_letters => @correct_letters,
      :incorrect_letters => @incorrect_letters,
      :used_words => @used_words,
      :file_name => @file_name,
    })
    File.open("saves/save-#{Dir.glob('saves/*').length + 1}.txt", 'w'){|f| f.write(data)}
  end

  def self.unserialize(string)
    data = YAML.load string
    Save.new(data[:secret_word], data[:errors], data[:correct_letters], data[:incorrect_letters], data[:used_words], data[:file_name])
  end

  def self.display_all_saves
    if Dir.glob('saves/*').length == 0
      return true
    end
    all_files = Dir.children("saves")
    puts "----------------"
    all_files.each_with_index do | file, index |
      begin
        content = Save.unserialize(URI.open("saves/#{file}", "r"))
        if content.file_name == ""
          content.file_name = "Save n.#{index + 1}"
        end
        puts "#{file.gsub(/[^0-9]/, '')}: #{content.file_name}"
      rescue
        next
      end
    end
  end
end