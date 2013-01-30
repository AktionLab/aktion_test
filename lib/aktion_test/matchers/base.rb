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
        raise "Called failure message before determining a match from #{caller[0]}" if @matches.nil?
        raise "Called failure message while the match was positive from #{caller[0]}" if @matches
        "Expected #{expectation}\n#{problems_for_should}\n"
      end

      def negative_failure_message
        raise "Called negative failure message before determining a match from #{caller[0]}" if @matches.nil?
        raise "Called negative failure message while the match was unsucessful from #{caller[0]}" unless @matches
        "Did not expect #{expectation}\n#{problems_for_should_not}\n"
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
    end
  end
end
