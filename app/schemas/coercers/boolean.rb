# auto_register: false
# frozen_string_literal: true

module Terminus
  module Schemas
    # A coerces a key's value as false when key is missing.
    module Coercers
      Boolean = lambda do |key, result|
        return unless result.output

        attributes = result.to_h
        attributes[key] = false unless result.key? key

        attributes
      end
    end
  end
end
