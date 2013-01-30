module AktionTest
  module Module
    module Faker
      extend ActiveSupport::Concern
      
      included do |spec_helper|
        require 'faker'
      end
    end
  end
end

