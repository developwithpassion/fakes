# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib",__FILE__)
require "developwithpassion_fakes/version"

Gem::Specification.new do |s|
  s.name        = "developwithpassion_fakes"
  s.version     = DevelopWithPassion::Fakes::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Develop With Passion®"]
  s.email       = ["open_source@developwithpassion.com"]
  s.homepage    = "http://www.developwithpassion.com"
  s.summary     = %q{Simple faking library}
  s.description = %q{Faking library that allows inspection of received calls after they have been made. Also supports tracking calls with multiple argument sets.}
  s.rubyforge_project = "developwithpassion_fakes"

  s.files         = `git ls-files | grep -v -P "^(dev|lib)"`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec-core"
  s.add_development_dependency "rspec-expectations"
  s.add_development_dependency "rake"
  s.add_development_dependency "guard"
  # s.add_runtime_dependency "rest-client"
end
