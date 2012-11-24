module AktionTest
  module Matchers
    module FileSystem
      def be_a_file
        FileExistanceMatcher.new
      end

      class FileExistanceMatcher < Matchers::Base
        def initialize
        end

        def matches?(subject)
          @subject = subject
          File.exists? @subject
        end

      protected
        
        def expectation
          "#{@subject} to be a file"
        end

        def problem
          ""
        end
      end
    end
  end
end

