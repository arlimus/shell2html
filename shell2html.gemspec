# coding: utf-8
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
require 'shell2html'

spec = Gem::Specification.new do |s|
  s.name = 'shell2html'
  s.version = Shell2Html::version
  s.platform = Gem::Platform::RUBY
  s.summary = "get what happens in your shell as html output"
  s.description = s.summary
  s.author = "Dominik Richter"
  s.email = "dominik.richter@googlemail.com"
  s.homepage = "https://github.com/arlimus/shell2html"
  s.license = "MPLv2"

  s.add_dependency "trollop"
  s.add_dependency "eventmachine"
  s.add_dependency "rb-readline"

  s.files = `git ls-files`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
