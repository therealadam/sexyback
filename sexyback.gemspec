# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sexyback/version"

Gem::Specification.new do |s|
  s.name        = "sexyback"
  s.version     = Sexyback::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Adam Keys"]
  s.email       = ["adam@therealadam.com"]
  s.homepage    = ""
  s.summary     = %q{Use handy data structures with Cassandra.}
  s.description = %q{Sexyback gives you usable data structures that use Cassandra for storage.}

  s.rubyforge_project = "sexyback"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'activesupport', '~> 3.0.0'
  s.add_dependency 'cassandra', '~> 0.11.1'
end
