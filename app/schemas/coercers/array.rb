# auto_register: false
# frozen_string_literal: true

require "refinements/hash"

module Terminus
  module Schemas
    # Coerces a comma delimited string into an array.
    module Coercers
      using Refinements::Hash

      Array = -> key, result { result.to_h.transform_value!(key) { String(it).split "," } }
    end
  end
end
