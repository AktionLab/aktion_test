module AktionTest
  module Module
    class Simplecov < Base
      def initialize(spec, options={})
        super
        require 'simplecov'
        ::SimpleCov.start
      end
    end
  end
end

