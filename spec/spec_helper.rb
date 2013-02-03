$: << File.dirname(__FILE__)
require 'aktion_test'
require 'support/autoload'

require 'simplecov'
SimpleCov.start do
  add_group 'Matchers', 'lib/aktion_test/matchers'
  add_group 'Modules',  'lib/aktion_test/module'
end

AktionTest::SpecHelper.build do
  use :AktionTest, :FactoryGirl, :Faker, :RSpec, :Timecop
end

