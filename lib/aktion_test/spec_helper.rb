require "aktion_test/version"
require "aktion_test/matchers/base"
require 'aktion_test/class_builder'
require "aktion_test/matchers/integrations/rspec"
require 'singleton'

module AktionTest
  class SpecHelper
    include Singleton

    attr_accessor :modules
    instance.modules = []

    class << self
      def load(*modules)
        modules.each do |mod|
          module_name = "AktionTest::Module::#{mod.to_s.classify}"
          begin
            module_const = module_name.constantize
            include module_const
          rescue NameError
            puts "Unknown module #{mod}."
          end
        end
      end
    end
  end
end
