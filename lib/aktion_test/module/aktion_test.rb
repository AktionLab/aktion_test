module AktionTest
  module Module
    class AktionTest < Base
      def initialize(spec, options={})
        super
        spec.use :Simplecov
      end

      def prepare
        require 'aktion_test/matchers/base'
      end

      def configure
        rspec.include Support::ClassBuilder
        rspec.include Matchers::FileSystem::DirectoryExistance
        rspec.include Matchers::FileSystem::FileExistance
        rspec.include Matchers::FileSystem::DirectoryContains
        rspec.include Matchers::FileSystem::FileContains
      end
    end
  end
end
