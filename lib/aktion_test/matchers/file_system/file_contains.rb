module AktionTest
  module Matchers
    module FileSystem
      module FileContains
        def match_lines(lines, options={})
          Matcher.new(lines, options)
        end

        class Matcher < Matchers::Base
          def initialize(lines, options={})
            @original_lines = lines
            @lines, @options = init_lines(lines), options
            @options[:match_method] = :all
            allow_any    if @options.delete(:allow_any)
            sequentially if @options.delete(:sequentially)
            @options[:after]  = regexp(@options[:after])  unless @options[:after].nil?
            @options[:before] = regexp(@options[:before]) unless @options[:before].nil?
          end

          def init_lines(lines)
            lines.map { |line| regexp(line) }.flatten
          end

          def allow_any
            @options[:match_method] = :any
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
            @options[:match_method] = :sequence
            self
          end

        protected
          
          def expectation
            "#{@subject} to have contents:\n---\n#{print_lines}\n---"
          end

          def perform_match!
            file_exists? && file_has_contents?
          end

          def print_lines
            @original_lines.join("\n")
          end

          def problems_for_should
            if File.exists?(@subject)
              if File.directory?(@subject)
                "#{@subject} is a directory."
              end
            else
              "#{@subject} does not exist."
            end
          end

          def file_exists?
            File.exists?(@subject) && !File.directory?(@subject)
          end

          def file_has_contents?
            find  = -> lines, match { lines.find_index{|line| line =~ match} }
            scope = -> lines, scope, default { find[lines, @options[scope]] || default }
            lines = -> lines { lines.take(scope[lines, :before, lines.count]).drop(scope[lines, :after, -1] + 1) }


            match_method[@lines.map{|line| find[lines[open(@subject).readlines], line]}]
          end

          def match_method
            case @options[:match_method]
            when :sequence
              -> result { !result.first.nil? && (result == ((result.first)..(result.first + @lines.count - 1)).to_a) }
            when :any
              -> result { !result.all?(&:nil?) }
            when :all
              -> result { result.none?(&:nil?) }
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
end

