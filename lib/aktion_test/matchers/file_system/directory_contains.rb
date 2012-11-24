module AktionTest
  module Matchers
    module FileSystem
      def have_file(file)
        DirectoryContentMatcher.new([file])
      end

      def have_files(files)
        DirectoryContentMatcher.new(files)
      end

      class DirectoryContentMatcher < Matchers::Base
        def initialize(structure, options={})
          @structure, @options = structure, options
        end

        def matches?(subject)
          @subject = subject
          directory_exists? && @structure.none? {|f| find(f).empty?}
        end

      protected

        def find(file_or_dir, dir=@subject)
          Dir.entries(dir).reject{|e| %w(. ..).include? e}.select do |e|
            if File.directory?(File.join(dir, e))
              find(file, File.join(dir, e)).any?
            else
              file == e
            end
          end
        end

        def directory_exists?
          Dir.exists?(@subject)
        end

        def expectation
          "#{@subject} to contain:\n#{print_structure}\n"
        end

        def problem
          unless directory_exists?
            if File.exists? @subject
              "#{@subject} is not a directory."
            else
              "#{@subject} does not exist."
            end
          else
            missing_files = @structure.select{|entry| find(entry).empty?}
            if missing_files.any?
              missing_files.map{|f| "#{f} was not found"}.join("\n")
            else
              "Unknown Problem"
            end
          end
        end

        def print_structure(structure=nil, depth=1)
          structure ||= @structure
          structure.map do |entry|
            case entry
            when String then
              print_file(entry, depth)
            when Hash
              entry.map do |k,v|
                print_directory(k, depth)
                print_structure(v, depth + 1)
              end.join("\n")
            end
          end.join("\n")
        end

        def print_file(file, depth)
          "#{"  " * depth}#{file}"
        end

        def print_directory(directory, depth)
          print_file(directory << '/')
        end
      end
    end
  end
end
