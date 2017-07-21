require "rails"
require "singleton"
require "yaml"

module Heyyka
  class Translator
    include Singleton

    DEFAULT_HEYYKA_STRING     = "Heyyka 😁".freeze
    DEPRECATED_BLACKLIST_PATH = "config/blacklist.yml".freeze
    BLACKLIST_PATH            = "config/heyyka_translator/blacklist.yml".freeze
    WHITELIST_PATH            = "config/heyyka_translator/whitelist.yml".freeze

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
      translated_sentence = sentence.dup

      words.each do |word|
        if translated_sentence.include?(word)
          translated_sentence_words = translated_sentence.split

          translated_sentence_words.each do |tsw|
            next unless tsw.include?(word)
            change_word = true

            exclusion_fitlers.each do |filter|
              case filter
              when Regexp
                change_word = false if filter.match(tsw)
              when String
                change_word = false if tsw.include?(filter)
              end
              break unless change_word
            end

            tsw.gsub!(word, replacement) if change_word
          end

          translated_sentence = translated_sentence_words.join(" ")
        end
      end

      translated_sentence
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
      @words ||= build_words(words: fetch_words)
    end

    def exclusion_fitlers
      @exc_filters ||= fetch_exlusion_filters.to_a
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

    # ;)
    # def replacement_word
    #   require "base64"
    #   # numbers chosen by fair irb rand
    #   if rand(1..2453) == 879
    #     Base64.decode64 "QmFsd2FueSByemFkemEgc3dpYXRlbQ==\n"
    #   else
    #     replacement
    #   end
    # end

    def fetch_words
      unless File.exists?(DEPRECATED_BLACKLIST_PATH)
        fetch_yaml(BLACKLIST_PATH, File.dirname(__FILE__) + "/blacklist.yml")
      else
        YAML.load(File.open(DEPRECATED_BLACKLIST_PATH)).freeze
      end
    end

    def fetch_exlusion_filters
      fetch_yaml(WHITELIST_PATH, File.dirname(__FILE__) + "/whitelist.yml")
    end

    def fetch_yaml(config_path, default_file_path)
      if File.exists?(config_path)
        YAML.load(File.open(config_path)).freeze
      else
        YAML.load(File.open(default_file_path)).freeze
      end
    end
  end
end
