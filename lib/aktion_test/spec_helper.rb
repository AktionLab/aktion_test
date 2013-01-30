require 'singleton'

module AktionTest
  class SpecHelper
    include Singleton

    attr_reader :modules, :options, :scope

    class << self
      def load(*names, &block)
        options = names.extract_options!

        if names.any?
          load_constants(names)

          unless options.nil? || options.empty?
            names.each do |name|
              instance.options.merge! name => options
            end
          end

          instance.modules.each do |mod|
            include mod
          end
        end

        self.instance_eval(&block) if block_given?
      end

      def within(scope, &block)
        instance.scope << scope.to_s
        yield
        instance.scope.pop
      end

    private

      def load_constants(modules)
        modules.each do |mod|
          module_name = "#{instance.scope.join('::')}::#{mod}"
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
      reset
    end

    def reset
      @modules = []
      @options = {}
      @scope   = %w(AktionTest Module)
    end

    def loaded?(name)
      eval "defined? AktionTest::Module::#{name}"
    end
  end
end
