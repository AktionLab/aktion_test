require 'aktion_test/module/base'

module AktionTest
  class SpecHelper
    attr_reader :modules, :options
    attr_writer :scope

    class << self
      def build(&block)
        new.tap do |sh|
          if block_given?
            sh.instance_eval(&block)
            sh.compile!
          end
        end
      end
    end

    def initialize
      reset
    end

    def reset
      @modules = []
      @scope   = %w(AktionTest Module)
    end

    def use(*names)
      options = names.extract_options!
      return names.each {|name| use name} if names.many?

      name = names.first

      klass = case name
      when Class then name
      when /^::/ then name.constantize
      else "#{@scope.join('::')}::#{name}".constantize
      end

      unless klass.ancestors.include? AktionTest::Module::Base
        raise ArgumentError.new("#{klass.name} must inherit from AktionTest::Module::Base") 
      end

      modules << klass.new(self, options)
    end

    def scope(name='')
      return @scope if name.blank?
      raise ArgumentError.new("A block is required when applying a temporary scope") unless block_given?

      begin
        scope << name
        yield
      ensure
        scope.pop
      end
    end

    def compile!
      modules.each &:prepare
      modules.each &:configure
      modules.each &:cleanup
    end
  end
end
