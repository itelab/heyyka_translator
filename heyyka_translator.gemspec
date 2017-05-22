$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "heyyka_translator/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "heyyka_translator"
  s.version     = HeyykaTranslator::VERSION
  s.authors     = ["Adam-Stomski"]
  s.email       = ["adam.stomski@gmail.com"]
  s.homepage    = "https://github.com/Adam-Stomski/heyyka_translator"
  s.summary     = "HeyykaTranslator for Heyyka app"
  s.description = "HeyykaTranslator translates beautiful words into Heyyka"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5", ">= 5.0.0.1"

  s.add_development_dependency "sqlite3"
end
