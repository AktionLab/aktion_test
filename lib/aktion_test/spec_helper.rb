require 'singleton'

module AktionTest
  class SpecHelper
    include Singleton

    attr_reader :modules, :options, :scope

    class << self
      def load(*names, &block)
        if names.any?
          instance.load(*names)
        end

        instance.instance_eval(&block) if block_given?

        instance.modules.each{|mod| include mod}
      end

      def add_module(name, options={})
      end

      def add_modules(*names)
        names.each{|name| add_module(name)}
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

    def load(*names)
      options = names.extract_options!

      names.each do |name|
        unless options.nil? or options.empty?
          self.options.merge! name => options
        end
        load_constant(name)
      end
    end

    def within(scope, &block)
      self.scope << scope.to_s
      yield
      self.scope.pop
    end

  private

    def load_constant(name)
      name = "#{self.scope.join('::')}::#{name}"
      begin
        const = name.constantize
        self.modules << const
      rescue NameError
        puts "Unknown module #{name}."
      end
    end
  end
end
