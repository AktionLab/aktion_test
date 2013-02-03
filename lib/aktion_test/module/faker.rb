module AktionTest
  module Module
    class Faker < Base
      def prepare
        require 'faker'
      end
    end
  end
end

