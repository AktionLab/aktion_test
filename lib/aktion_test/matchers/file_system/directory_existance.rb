module AktionTest
  module Matchers
    module FileSystem
      module DirectoryExistance
        def be_a_directory
          Matcher.new
        end

        class Matcher < Matchers::Base
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
            if File.exists? @subject
              unless File.directory? @subject
                "#{@subject} is not a directory."
              else
                "Unknown"
              end
            else
              "#{@subject} does not exist."
            end
          end

          def directory_exists?
            Dir.exists? @subject
          end
        end
      end
    end
  end
end