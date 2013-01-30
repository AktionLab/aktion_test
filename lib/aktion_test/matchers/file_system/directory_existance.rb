module AktionTest
  module Matchers
    module FileSystem
      module DirectoryExistance
        def be_a_directory
          Matcher.new
        end

        class Matcher < Matchers::Base
          def initialize
            super
          end

        protected
          
          def perform_match!
            directory_exists?
          end
          
          def expectation
            "#{@subject} to be a directory."
          end

          def problems_for_should
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

          def problems_for_should_not
          end

          def directory_exists?
            Dir.exists? @subject
          end
        end
      end
    end
  end
end
