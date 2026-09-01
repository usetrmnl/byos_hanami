# frozen_string_literal: true

require "initable"

module Terminus
  module Aspects
    module Superfluid
      module Filters
        # Renders locale date.
        class LocalizeDate
          include Deps[:i18n]
          include Initable[time_pattern: /\A[0-9]+\z/]

          def call value, format, locale = "en"
            time = case value
                     when "now", "today" then Time.now
                     when time_pattern then Time.at(value.to_i)
                     else Time.parse value
                   end

            format = format.to_sym unless format.include? "%"

            i18n.localize time, format:, locale:
          end
        end
      end
    end
  end
end
