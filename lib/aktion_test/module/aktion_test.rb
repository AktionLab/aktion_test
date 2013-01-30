module AktionTest
  module Module
    module AktionTest
      extend ActiveSupport::Concern
      
      included do |spec_helper|
        require 'aktion_test/matchers/base'
        require 'aktion_test/class_builder'
        require 'aktion_test/matchers/file_system/file_existance'
        require 'aktion_test/matchers/file_system/directory_existance'
        require 'aktion_test/matchers/file_system/directory_contains'
        require 'aktion_test/matchers/file_system/file_contains'

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
