module AktionTest
  module Support
    module ClassBuilder
      def self.included(example_group)
        example_group.class_eval do
          after do
            teardown_defined_constants
          end
        end
      end

      def define_class(class_name, base = Object, scope = Object, &block)
        class_name = class_name.to_s.camelize

        Class.new(base).tap do |constant_class|
          scope.const_set(class_name, constant_class)
          constant_class.unloadable
          constant_class.class_eval(&block) if block_given?
          constant_class.reset_column_information if constant_class.respond_to? :reset_column_information
        end
      end

      def teardown_defined_constants
        ActiveSupport::Dependencies.clear
      end
    end
  end
end

