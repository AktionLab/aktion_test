require "aktion_test/version"
require 'active_support/dependencies'
require 'active_support/core_ext'

module AktionTest
  extend ActiveSupport::Autoload

  autoload :SpecHelper

  module Module
    extend ActiveSupport::Autoload

    autoload :AktionTest
    autoload :RSpec, 'aktion_test/module/rspec'
    autoload :Simplecov
  end
end
