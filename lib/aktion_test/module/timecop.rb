module Aktion
  module Module
    module Timecop
      extend ActiveSupport::Concern

      included do |spec_helper|
        require 'timecop'
      end
    end
  end
end
