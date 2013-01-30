module AktionTest
  module Matchers
    module FileSystem
      module DirectoryContains
        def have_file(path)
          segments = path.split('/')
          file = segments.pop
          tree = segments.reverse.reduce([file]) {|a,b| [{b => a}] }
          have_tree(tree)
        end

        def have_tree(tree)
          Matcher.new(tree)
        end

        class Matcher < Matchers::Base
          def initialize(tree)
            @tree = tree
          end

        protected
          
          def perform_match!
            directory_exists? && matches_tree?(@tree)
          end

          def matches_tree?(tree, directory='')
            tree.all? do |entry|
              if entry.is_a? String
                Dir[File.join(@subject, directory, entry)].any?
              elsif entry.is_a? Hash
                entry.to_a.all?{|dir,subtree| matches_tree?(subtree, File.join(directory, dir))}
              end
            end
          end

          def directory_exists?
            Dir.exists?(@subject)
          end

          def expectation
            "#{@subject} to contain:\n#{print_tree}\n"
          end

          def flatten_tree(structure, directory='')
            structure.map do |entry|
              case entry
              when Hash
                entry.map{|dir,entries| flatten_tree(entries, "#{directory}#{dir}/")}
              when String
                "#{directory}#{entry}"
              end
            end.flatten
          end

          def problems_for_should
            unless directory_exists?
              if File.exists? @subject
                "#{@subject} is not a directory."
              else
                "#{@subject} does not exist."
              end
            else
              missing_files = flatten_tree(@tree).reject do |path|
                Dir["#{@subject}/#{path}"].any?
              end
              if missing_files.any?
                missing_files.map{|f| "#{f} was not found"}.join("\n")
              else
                "Unknown Problem"
              end
            end
          end

          def problems_for_should_not
          end

          def print_tree(tree=nil, depth=1)
            tree ||= @tree
            tree.map do |entry|
              case entry
              when String then
                print_file(entry, depth)
              when Hash
                entry.map do |k,v|
                  print_directory(k, depth) + "\n" +
                  print_tree(v, depth + 1)
                end.join("\n")
              end
            end.join("\n")
          end

          def print_file(file, depth)
            "#{"  " * depth}#{file}"
          end

          def print_directory(directory, depth)
            print_file(directory + '/', depth)
          end
        end
      end
    end
  end
end
