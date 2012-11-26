#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new do |t|
  t.pattern = 'spec/**/*_spec.rb'
  t.rspec_opts = '--color --format progress'
  t.verbose = false
end

task :all do
  exec('rake spec')
end

task :default => [:all]
