$: << File.dirname(__FILE__)
require 'aktion_test'
require 'support/autoload'

AktionTest::SpecHelper.load :Simplecov, :RSpec, :AktionTest, :Timecop, :FactoryGirl, :Faker
