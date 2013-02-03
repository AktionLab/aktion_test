module AktionTest
  module Module
    class Base
      class << self
      protected
        def depends_on(klass)
        end
      end

      def initialize(spec, options={})
        @options, @spec = options, spec
        @rspec = ::RSpec.configuration
      end

      def prepare
      end

      def configure
      end

      def cleanup
      end

    protected
      attr_reader :rspec, :options
    end
  end
end
