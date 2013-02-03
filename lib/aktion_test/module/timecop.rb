module AktionTest
  module Module
    class Timecop < Base
      def prepare
        require 'timecop'
      end

      def configure
        rspec.after { ::Timecop.return }
      end
    end
  end
end
