# frozen_string_literal: true

require "refinements/string"

module Terminus
  module Aspects
    module Superfluid
      # Renders pluralized words.
      module Filters
        using Refinements::String

        Pluralize = lambda do |value, count = 0, suffix = "s", replace = /$/|
          "#{count} #{value.pluralize suffix, count, replace:}"
        end
      end
    end
  end
end
