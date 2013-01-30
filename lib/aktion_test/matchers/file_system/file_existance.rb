module AktionTest
  module Matchers
    module FileSystem
      module FileExistance
        def be_a_file
          Matcher.new
        end

        class Matcher < Matchers::Base
          def initialize
          end

          def matches?(subject)
            @subject = subject
            file_exists? and file_is_not_a_directory?
          end

        protected

          def expectation
            "#{@subject} to be a file."
          end

          def problem
            if File.exists?(@subject)
              if File.directory?(@subject)
                "#{@subject} is a directory."
              else
                "Unknown"
              end
            else
              "#{@subject} does not exist."
            end
          end

          def file_exists?
            File.exists? @subject
          end

          def file_is_not_a_directory?
            !File.directory? @subject
          end
        end
      end
    end
  end
end

