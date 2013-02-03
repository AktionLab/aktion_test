module AktionTest
  module Module
    class RSpec < Base
      def configure
        rspec.treat_symbols_as_metadata_keys_with_true_values = true
        rspec.run_all_when_everything_filtered = true
        rspec.order = 'random'
      end
    end
  end
end
