# frozen_string_literal: true

require "core"
require "rqrcode"

module Terminus
  module Aspects
    module Superfluid
      module Filters
        # Renders day as ordinal.
        class Ordinalize
          def self.suffix number
            case number % 10
              when 1 then "st"
              when 2 then "nd"
              when 3 then "rd"
              else "th"
            end
          end

          def initialize placeholder: "<<ordinal_day>>", time_pattern: /\A[0-9]+\z/
            @placeholder = placeholder
            @time_pattern = time_pattern
          end

          def call value, pattern
            time = to_time value
            time.strftime pattern.gsub("<<ordinal_day>>", to_ordinal(time.day))
          end

          private

          attr_reader :placeholder, :time_pattern

          def to_time value
            case value
              when "now", "today" then Time.now
              when time_pattern then Time.at(value.to_i)
              else Time.parse value
            end
          end

          def to_ordinal number
            return "#{number}th" if (11..13).cover? number % 100

            "#{number}#{self.class.suffix number}"
          end
        end
      end
    end
  end
end
