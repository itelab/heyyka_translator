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

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'heyyka_translator', git: 'https://github.com/Adam-Stomski/heyyka_translator.git'
```

And then execute:
```bash
$ bundle
```

## License

The gem is available as open source under the terms of the [WTFPL](http://www.wtfpl.net/about/).

## Thanks

Thanks to my friends Ola and Magda for helping with blacklist.
