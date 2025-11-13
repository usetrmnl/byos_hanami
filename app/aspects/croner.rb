# frozen_string_literal: true

require "functionable"

module Terminus
  module Aspects
    # Parses interval, type, and range into cron sytnax.
    module Croner
      extend Functionable

      # :reek:UtilityFunction
      def call unit, type
        unit * type
      end
    end
  end
end
