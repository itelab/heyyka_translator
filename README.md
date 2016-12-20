# HeyykaTranslator

Translates beautiful Polish words into anything you want. Designed for http://heyyka.com/

## Usage

```ruby
# core functionality
Heyyka::Translator.translate("Masz jakiś problem kurwa?") # => "Masz jakiś problem Heyyka 😁?"

# add more words
Heyyka::Translator.add ["jajko", "kura"]
Heyyka::Translator.translate("Co było pierwsze jajko czy kura?") # => "Co było pierwsze Heyyka 😁 czy Heyyka 😁?"

# change replacement sentence
Heyyka::Translator.replacement = "So hard to write good documentation"
Heyyka::Translator.translate("jajko") # => "So hard to write good documentation"
```

A custom blacklist can be genereated:

```bash
$ rails g heyyka_translator:blacklist
```

Generator will create file config/blacklist.yml, where you can add your own words without adding them explicitly.

Otherwise the translator will load words from default list.

Running with parameter --empty will create an empty file.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'heyyka_translator', git: 'https://github.com/Minus10Degrees/heyyka_translator.git'
```

And then execute:
```bash
$ bundle
```

## License

The gem is available as open source under the terms of the [WTFPL](http://www.wtfpl.net/about/).

## Thanks

Thanks to my friends Ola and Magda for helping with blacklist.
