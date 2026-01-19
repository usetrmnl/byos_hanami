# auto_register: false
# frozen_string_literal: true

module Terminus
  module Aspects
    module Extensions
      module Importers
        module Remote
          # Defines import schema.
          Schema = Dry::Schema.Params do
            optional(:custom_fields).array(:hash)
            required(:dark_mode).filled :bool
            required(:name).filled :string
            required(:polling_body).maybe :hash
            required(:polling_headers).maybe :hash
            required(:polling_url).maybe :array
            required(:polling_verb).filled :string
            required(:refresh_interval).filled :integer
            required(:static_data).maybe :hash
            required(:strategy).filled :string

            after(:value_coercer, &Schemas::Coercers::Hash.curry[:polling_body])
            after(:value_coercer, &Schemas::Coercers::QueryParameters.curry[:polling_headers])
            after(:value_coercer, &Schemas::Coercers::Array.curry[:polling_url])
            after(:value_coercer, &Schemas::Coercers::Hash.curry[:static_data])
          end
        end
      end
    end
  end
end
