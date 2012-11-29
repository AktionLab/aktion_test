module AktionTest
  module Matchers
    module FileSystem
      def match_lines(lines, options={})
        FileContentMatcher.new(lines, options)
      end

      class FileContentMatcher < Matchers::Base
        def initialize(lines, options={})
          @lines, @options = init_lines(lines), options
          @options[:match_method] = (@options.delete(:allow_any) ? :any? : :all?)
          @options[:after] = regexp(@options[:after]) unless @options[:after].nil?
          @options[:before] = regexp(@options[:before]) unless @options[:before].nil?
        end

        def init_lines(lines)
          lines.map { |line| regexp(line) }.flatten
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
          @options[:after] = regexp(match_after)
          self
        end

        def before(match_before)
          @options[:before] = regexp(match_before)
          self
        end

        def sequentially
          @options[:sequentially] = true
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
          scope = -> lines, match, default { lines.find_index{|line| line =~ @options[match]} || default }
          lines = -> lines { lines.take(scope[lines, :before, lines.count]).drop(scope[lines, :after, -1] + 1) }

          scoped_lines = lines[open(@file).readlines]

          if @options[:sequentially]
            result = @lines.map do |line|
              scoped_lines.find_index{|fline| line =~ fline}
            end
            return false if result.first.nil?
            result == ((result.first)..(result.first + @lines.count - 1)).to_a
          else
            @lines.send(@options[:match_method]) do |line|
              scoped_lines.any? {|fl| fl =~ line}
            end
          end
        end

        def regexp(object)
          case object
          when Regexp then object
          when Array  then object.map {|item| regexp(item)} 
          when String
            if object.include? "\n"
              object.split("\n").map{|item| %r(^#{item}$)}
            else
              %r(^#{object}$)
            end
          else
            %r(^#{object.to_s}$)
          end
        end
      end
    end
  end
end

