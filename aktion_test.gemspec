# -*- encoding: utf-8 -*-
require File.expand_path('../lib/aktion_test/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Chris Boertien"]
  gem.email         = ["chris@aktionlab.com"]
  gem.description   = %q{Contains all required testing gems as well as some rake tasks and test helpers to make getting a test suite up and running easy and fast.}
  gem.summary       = %q{Gems, libs, helpers for test suites.}
  gem.homepage      = "http://aktionlab.com"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "aktion_test"
  gem.require_paths = ["lib"]
  gem.version       = AktionTest::VERSION

  # Don't add anything to this list that depends on Rails or any
  # other large frameworks/orms. This list should be suitable for
  # even the simplest gem.
  gem.add_dependency 'rspec'
  gem.add_dependency 'cucumber'
  gem.add_dependency 'faker'
  gem.add_dependency 'factory_girl'
  gem.add_dependency 'simplecov'
  gem.add_dependency 'timecop'
end
