module AktionTest
  module Module
    module Simplecov
      extend ActiveSupport::Concern
      
      included do |base|
        require 'simplecov'
        SimpleCov.start
      end
    end
  end
end

