require "aktion_test/version"
require 'active_support/dependencies'
require 'active_support/core_ext'

module AktionTest
  extend ActiveSupport::Autoload

  autoload :SpecHelper

  module Module
    extend ActiveSupport::Autoload

    autoload :AktionTest
    autoload :FactoryGirl
    autoload :Faker
    autoload :RSpec, 'aktion_test/module/rspec'
    autoload :Simplecov
    autoload :Timecop
  end

  module Matchers
    module FileSystem
      extend ActiveSupport::Autoload
      
      autoload :DirectoryContains
      autoload :DirectoryExistance
      autoload :FileContains
      autoload :FileExistance
    end
  end

  module Support
    extend ActiveSupport::Autoload

    autoload :ClassBuilder
  end
end
