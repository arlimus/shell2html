# coding: utf-8
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
require 'shell2html'

require 'rake'
require 'rake/clean'

VERSION = Shell2Html::version
GEMSPEC = 'shell2html.gemspec'
GEM = "shell2html-#{VERSION}.gem"

desc 'Build the gem'
task :build do
  sh "mkdir -p target"
  sh "gem build #{GEMSPEC}"
  sh "mv #{GEM} target/"
end

task :default
