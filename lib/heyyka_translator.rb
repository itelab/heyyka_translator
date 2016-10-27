require "rails"
require "singleton"
require "yaml"

module Heyyka
  class Translator
    include Singleton

    DEFAULT_HEYYKA_STRING = "Heyyka 😁".freeze
    DEFAULT_WORDS = YAML.load(File.open(File.dirname(__FILE__) + "/blacklist.yml")).freeze

    POLISH_LETTERS = {
      "ą" => "a",
      "ę" => "e",
      "ń" => "n",
      "ć" => "c",
      "ź" => "z",
      "ż" => "z",
      "ó" => "o",
      "ś" => "s"
    }.freeze

    attr_accessor :replacement

    # entry point for translating
    def self.translate(sentence)
      instance.call(sentence)
    end

    def self.call(sentence)
      translate(sentence)
    end

    def self.add(word)
      instance.add(word)
    end

    def self.<<(word)
      add(word)
    end

    def self.remove(word)
      instance.remove(word)
    end

    def self.>>(word)
      remove(word)
    end

    def self.all_words
      instance.all_words
    end

    def self.all
      all_words
    end

    def self.replacement
      instance.replacement
    end

    def self.replacement=(val)
      instance.replacement = val
    end

    def initialize
      @replacement = DEFAULT_HEYYKA_STRING
    end

    def call(sentence)
      sentence.dup.tap do |translated_sentence|
        words.each do |word|
          if translated_sentence.include?(word)
            translated_sentence.gsub!(word, replacement_word)
          end
        end
      end
    end

    def add(word)
      if word.is_a?(Array)
        word.each do |w|
          build_add_word(all: words, word: w)
        end
      else
        build_add_word(all: words, word: word.to_s)
      end
    end

    def remove(word)
      if word.is_a?(Array)
        words.reject! {|w| word.include?(w) }
      else
        words -= [word]
      end
    end

    def all_words
      words.dup
    end

    def words
      @words ||= build_words(words: DEFAULT_WORDS)
    end

    private

    def build_words(words:)
      [].tap do |all|
        words.each do |word|
          build_add_word(all: all, word: word)
        end
      end.uniq!
    end

    def build_add_word(all:, word:)
      add_versions(all: all, word: word)

      POLISH_LETTERS.each do |k, v|
        if word.include?(k)
          w = word.gsub(k, v)

          add_versions(all: all, word: w)
        end
      end

      all
    end

    def add_versions(all:, word:)
      [
        :to_s,
        :camelize,
        :capitalize,
        :underscore,
        :titleize,
        :upcase,
        :downcase
      ].each do |meth|
        all << word.send(meth)
      end

      if word.include?(" ")
        ["_", "-", ".", ",", "`", "'", "\""].each do |c|
          add_versions(all: all, word: word.gsub(" ", c))
        end
      end

      all
    end

    def replacement_word
      require "base64"
      # numbers chosen by fair irb rand
      if rand(1..2453) == 879
        Base64.decode64 "QmFsd2FueSByemFkemEgc3dpYXRlbQ==\n"
      else
        replacement
      end
    end
  end
end
