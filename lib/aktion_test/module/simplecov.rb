module AktionTest
  module Module
    class Simplecov < Base
      def initialize(spec, options={})
        super
        require 'simplecov'
        ::SimpleCov.start do
          add_filter '/spec/'
        end
      end
    end
  end
end

