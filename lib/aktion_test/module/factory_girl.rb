module AktionTest
  module Module
    module FactoryGirl
      extend ActiveSupport::Concern
      
      included do |spec_helper|
        require 'factory_girl'

        ::RSpec.configure do |config|
          config.include ::FactoryGirl::Syntax::Methods
        end
      end
    end
  end
end
