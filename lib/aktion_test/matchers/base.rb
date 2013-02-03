module AktionTest
  module Matchers
    class Base
      def initialize
        @matches = nil
      end

      def matches?(subject)
        return @matches unless @matches.nil?
        @subject = subject
        @matches = !!perform_match!
      end

      def failure_message
        message(false)
      end

      def negative_failure_message
        message(true)
      end

    protected

      def expectation
        "Override expectation to provide expectation details"
      end
      
      def problems_for_should
        "Override problem_for_should to set problems in the failure message output."
      end

      def problems_for_should_not
        "Override problem_for_should_not to set problems in the failure message output."
      end

      def perform_match!
        raise "Override perform_match! with your custom matching logic. The subject is available through @subject"
      end

    private
      
      def message(match)
        check_match(match)
        "#{match ? 'Did not expect' : 'Expected'} #{expectation}\n#{send(match ? :problems_for_should_not : :problems_for_should)}\n"
      end

      def check_match(match)
        method = match ? 'negative failure message' : 'failure message'
        raise "Called #{method} before determining a match from #{caller[0]} " if @matches.nil?
        raise "Called #{method} while the match was #{match ? 'negative' : 'positive'} from #{caller[0]}" unless @matches == match
      end
    end
  end
end
