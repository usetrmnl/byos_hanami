# auto_register: false
# frozen_string_literal: true

require "dry/core"

module Terminus
  module Schemas
    # Coerces a missing key by adding the key back with an empty value.
    module Coercers
      Empty = lambda do |key, result, default = Dry::Core::EMPTY_ARRAY|
        attributes = result.to_h
        attributes[key] = default unless result.key? key

        attributes
      end
    end
  end
end
