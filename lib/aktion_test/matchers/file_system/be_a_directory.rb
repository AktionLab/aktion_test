module AktionTest
  module Matchers
    module FileSystem
      def be_a_directory
        DirectoryExistanceMatcher.new
      end

      class DirectoryExistanceMatcher < Matchers::Base
        def initialize
        end

        def matches?(subject)
          @subject = subject
          directory_exists?
        end

      protected
        
        def expectation
          "#{@subject} to be a directory."
        end

        def problem
          ""
        end

        def directory_exists?
          Dir.exists? @subject
        end
      end
    end
  end
end
