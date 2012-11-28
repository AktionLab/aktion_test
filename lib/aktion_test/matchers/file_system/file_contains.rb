module AktionTest
  module Matchers
    module FileSystem
      def match_lines(lines, options={})
        FileContentMatcher.new(lines, options)
      end

      class FileContentMatcher < Matchers::Base
        def initialize(lines, options={})
          @lines, @options = lines, options
          @options[:match_method] = (@options.delete(:allow_any) ? :any? : :all?)
          @options[:after] ||= nil
          @options[:before] ||= nil
        end

        def matches?(file)
          @file = file
          file_exists? && file_has_contents?
        end
      
        def allow_any
          @options[:match_method] = :any?
          self
        end

        def after(match_after)
          @options[:after] = match_after
          self
        end

        def before(match_before)
          @options[:before] = match_before
          self
        end

      protected
        
        def expectation
          "#{@file} to have contents:\n#{@lines}"
        end

        def problem
          ""
        end

        def file_exists?
          File.exists? @file
        end

        def file_has_contents?
          file_lines = File.open(@file, 'r').read.split("\n")
          if @options[:after]
            file_lines = file_lines.drop_while do |line|
              case @options[:after]
              when String
                line != @options[:after]
              when Regexp
                !(line =~ @options[:after])
              end
            end
          end

          if @options[:before]
            file_lines = file_lines.take_while do |line|
              case @options[:before]
              when String
                line != @options[:before]
              when Regexp
                !(line =~ @options[:before])
              end
            end
          end

          @lines.send(@options[:match_method]) do |line|
            case line
            when String
              file_lines.include? line
            when Regexp
              file_lines.any? {|fl| fl =~ line}
            end
          end
        end
      end
    end
  end
end

