spec = Gem::Specification.new do |s|
  s.name = 'shell2html'
  s.version = '0.0'
  s.platform = Gem::Platform::RUBY
  s.summary = "get what happens in your shell as html output"
  s.description = s.summary
  s.author = "Dominik Richter"
  s.email = "dominik.richter@googlemail.com"

  s.add_dependency "trollop"
  s.add_dependency "eventmachine"
  s.add_dependency "rb-readline"

  s.files = `git ls-files`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
