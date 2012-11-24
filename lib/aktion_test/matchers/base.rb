module AktionTest
  module Matchers
    class Base
      def failure_message
        "Expected #{expectation}\n#{problem}"
      end

      def negative_failure_message
        "Did not expect #{expectation}"
      end
    end
  end
end
