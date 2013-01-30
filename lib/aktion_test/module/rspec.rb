module AktionTest
  module Module
    module RSpec
      extend ActiveSupport::Concern
      
      included do |spec_helper|
        ::RSpec.configure do |config|
          config.treat_symbols_as_metadata_keys_with_true_values = true
          config.run_all_when_everything_filtered = true
          config.order = 'random'
        end
      end
    end
  end
end
