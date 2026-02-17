# auto_register: false
# frozen_string_literal: true

module Terminus
  module Schemas
    module Devices
      module Sensors
        # Defines device sensor upsert schema.
        Upsert = Dry::Schema.Params do
          required(:make).filled :string
          required(:model).filled :string
          required(:kind).filled :string
          required(:value).filled :float
          required(:unit).filled :string
          required(:created_at).filled :integer
        end
      end
    end
  end
end
