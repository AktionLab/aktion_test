module AktionTest
  module Module
    class FactoryGirl < Base
      def prepare
        require 'factory_girl'
      end

      def configure
        rspec.include ::FactoryGirl::Syntax::Methods
      end
    end
  end
end
