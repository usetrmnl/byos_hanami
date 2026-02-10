# auto_register: false
# frozen_string_literal: true

module Terminus
  module Schemas
    module Models
      # Defines model upsert schema.
      Upsert = Dry::Schema.Params do
        required(:name).filled :string
        required(:label).filled :string
        required(:description).maybe :string
        required(:mime_type).filled :string
        required(:colors).filled :integer
        required(:bit_depth).filled :integer
        required(:rotation).filled :integer
        required(:offset_x).filled :integer
        required(:offset_y).filled :integer
        required(:scale_factor).filled :float
        required(:width).filled :integer
        required(:height).filled :integer
        required(:palette_ids).maybe :array
        required(:css).maybe :hash

        after(:value_coercer, &Coercers::Array.curry[:palette_ids])
        after(:value_coercer, &Coercers::Hash.curry[:css])
      end
    end
  end
end
