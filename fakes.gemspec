# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name        = 'fakes'
  s.version     = '1.1.6'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Develop With Passion®']
  s.email       = ['open_source@developwithpassion.com']
  s.homepage    = 'http://www.developwithpassion.com'
  s.summary     = %q{Simple faking library}
  s.description = %q{Faking library that allows inspection of received calls after they have been made. Also supports tracking calls with multiple argument sets.}
  s.rubyforge_project = 'fakes'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ['lib']

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-rspec'
end
