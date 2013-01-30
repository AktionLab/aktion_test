module AktionTest
  module Module
    module AktionTest
      extend ActiveSupport::Concern
      
      included do |spec_helper|
        require 'aktion_test/matchers/base'

        ::RSpec.configure do |config|
          config.include ClassBuilder
          config.include Matchers::FileSystem::DirectoryExistance
          config.include Matchers::FileSystem::FileExistance
          config.include Matchers::FileSystem::DirectoryContains
          config.include Matchers::FileSystem::FileContains
        end
      end
    end
  end
end
