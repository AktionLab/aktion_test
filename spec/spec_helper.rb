$: << File.dirname(__FILE__)
require 'aktion_test'
require 'support/autoload'

AktionTest::SpecHelper.build do
  use :Simplecov
  use :AktionTest, :FactoryGirl, :Faker, :RSpec, :Timecop
end
