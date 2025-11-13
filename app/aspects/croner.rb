# frozen_string_literal: true

require "dry/core"
require "functionable"

module Terminus
  module Aspects
    # Parses interval, type, and range into cron sytnax.
    module Croner
      extend Functionable

      def call unit = nil, type = "hour", **options
        case type
          when "minute" then unit ? "#{unit} * * * *" : "* * * * *"
          when "hour" then unit ? "0 #{unit} * * *" : "0 * * * *"
          when "day" then unit ? "0 0 #{unit} * *" : "0 0 * * *"
          when "week" then unit ? "0 #{unit} * * *" : "0 * * * *"
          when "month" then unit ? "0 #{unit} * * *" : "0 * * * *"
          when "year" then unit ? "0 #{unit} * * *" : "0 * * * *"
          else ""
        end
      end
    end
  end
end

# TODO: Remove when finished.
__END__

Fugit::Nat.parse("every 1 minute").original                              # "* * * * *"
Fugit::Nat.parse("every 1 hour").original                                # "0 * * * *"
Fugit::Nat.parse("every 1 day").original                                 # "0 0 * * *"
Fugit::Nat.parse("every 1 monday, wednesday, and friday").original       # "0 0 * * 1,3,5"
Fugit::Nat.parse("every second monday, wednesday, and friday").original  # nil
Fugit::Nat.parse("every 1 week").original                                # "0 0 * * 0"
Fugit::Nat.parse("every 1 month").original                               # "0 0 1 * *"
Fugit::Nat.parse("every 5th and 15th of the month").original             # Invalid
Fugit::Nat.parse("every last day of the month").original                 # nil
Fugit::Nat.parse("every 1 year").original                                # "0 0 1 1 *"
