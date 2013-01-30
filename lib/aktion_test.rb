require "aktion_test/version"
require 'active_support/dependencies'
require 'active_support/core_ext'

module AktionTest
  extend ActiveSupport::Autoload

  autoload :SpecHelper
  autoload :ClassBuilder

  module Module
    extend ActiveSupport::Autoload

    autoload :AktionTest
    autoload :RSpec, 'aktion_test/module/rspec'
    autoload :Simplecov
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
end
