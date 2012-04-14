# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'jekyll-hasty/version'

Gem::Specification.new do |s|
  s.name          = "jekyll-hasty"
  s.version       = Jekyll::Hasty::VERSION
  s.authors       = ["Polarblau"]
  s.email         = ["polarblau@gmail.com"]
  s.homepage      = "https://github.com/polarblau/jekyll-hasty"
  s.summary       = "A wrapper for a small plugin in ease integration with jquery.hasty comments."
  # s.description   = "TODO: description"

  s.files         = `git ls-files app lib`.split("\n")
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']
  s.rubyforge_project = '[none]'
end
