# auto_register: false
# frozen_string_literal: true

module Terminus
  module Schemas
    module Firmware
      # Defines firmware upsert schema.
      Upsert = Dry::Schema.Params do
        required(:version).filled Types::String.constrained(format: /\A[0-9]\.[0-9]\.[0-9]\Z/)
        required(:kind).filled :string
      end
    end
  end
end
