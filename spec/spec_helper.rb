$: << File.dirname(__FILE__)
require 'aktion_test'
require 'support/autoload'

AktionTest::SpecHelper.build do
  use :AktionTest, :FactoryGirl, :Faker, :RSpec, :Timecop
end

SimpleCov.add_group 'Matchers', 'lib/aktion_test/matchers'
SimpleCov.add_group 'Modules',  'lib/aktion_test/module'
