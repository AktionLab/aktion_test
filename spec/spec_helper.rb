require 'simplecov'

SimpleCov.start do
  add_filter '/spec/'
  refuse_coverage_drop
  minimum_coverage 100
end

require 'active_support/core_ext/string'
require 'aktion_test'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.order = 'random'
end
