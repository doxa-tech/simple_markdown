# encoding: utf-8

$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "simple_markdown/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "simple_markdown"
  s.version     = SimpleMarkdown::VERSION
  s.authors     = ["Noémien Kocher"]
  s.email       = ["nkcr.je@gmail.com"]
  s.homepage    = "https://github.com/JS-Tech/simple_markdown"
  s.summary     = "Add `simple_markdown` method to your rails app. It will parse markdown to html"
  s.description = "Given a markdown formated text, transforms it to html via a simple method `simple_markdown`"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency 'rails', '>= 4.2.0'

  s.add_development_dependency 'sqlite3', '>= 1.3.10'
end
