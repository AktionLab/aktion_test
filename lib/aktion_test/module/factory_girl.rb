module AktionTest
  module Module
    module FactoryGirl
      extend ActiveSupport::Concern
      
      included do |spec_helper|
        require 'factory_girl'
      end
    end
  end
end
