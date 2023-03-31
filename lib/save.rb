# frozen_string_literal: true

require 'yaml'
require 'fileutils'

# handles all the operations related to creating, displaying and deleting saves
class Save
  attr_accessor :secret_word, :errors, :correct_letters, :incorrect_letters, :used_words, :file_name

  def initialize(secret_word, errors, correct_letters = [], incorrect_letters = [], used_words = [], file_name = '')
    @secret_word = secret_word
    @errors = errors
    @correct_letters = correct_letters
    @incorrect_letters = incorrect_letters
    @used_words = used_words
    @file_name = file_name
  end

  def serialize
    data = YAML.dump({
      secret_word: @secret_word,
      errors: @errors,
      correct_letters: @correct_letters,
      incorrect_letters: @incorrect_letters,
      used_words: @used_words,
      file_name: @file_name
    })
    File.open("saves/save-#{Dir.glob('saves/*').length + 1}.txt", 'w') { |f| f.write(data) }
  end

  def self.unserialize(string)
    data = YAML.load string
    Save.new(data[:secret_word], data[:errors], data[:correct_letters], data[:incorrect_letters], data[:used_words], data[:file_name])
  end

  def self.display_all_saves
    return true if Dir.glob('saves/*').empty?

    puts '----------------'
    fix_nameless_file
  end

  def self.delete_all_saves
    FileUtils.rm_f Dir.glob('saves/*')
    puts 'All saves have been deleted! Restart the program to play again.'
    true
  end

  def self.fix_nameless_file
    all_files = Dir.children('saves').sort
    all_files.each_with_index do |file, index|
      begin
        content = Save.unserialize(URI.open("saves/#{file}", 'r'))
        content.file_name = "SAVE N.#{index + 1}" if content.file_name.strip == ''
        puts "#{file.gsub(/[^0-9]/, '')}: #{content.file_name.strip}"
      rescue StandardError
        next
      end
    end
  end
end
