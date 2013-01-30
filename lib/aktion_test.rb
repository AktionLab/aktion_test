require 'active_support/dependencies'
require 'active_support/core_ext'

module AktionTest
  extend ActiveSupport::Autoload

  autoload :SpecHelper

  module Module
    extend ActiveSupport::Autoload

    autoload :Simplecov
    autoload :RSpec
  end
end
