require 'singleton'

module AktionTest
  class SpecHelper
    include Singleton

    attr_accessor :modules

    class << self
      include ActiveSupport::Callbacks
      define_callbacks :load

      def load(*modules)
        load_constants(modules)

        instance.modules.each do |mod|
          include mod
        end

        puts "Loaded #{modules.map(&:to_s).join(', ')}"
      end

    private

      def load_constants(modules)
        modules.each do |mod|
          module_name = "AktionTest::Module::#{mod}"
          begin
            module_const = module_name.constantize
            instance.modules << module_const
          rescue NameError
            puts "Unknown module #{mod}."
          end
        end
      end
    end

    def initialize
      @modules = []
    end
  end
end
