# auto_register: false
# frozen_string_literal: true

module Terminus
  module Schemas
    module Extensions
      # Defines extension patch schema.
      Patch = Dry::Schema.Params do
        optional(:name).filled :string
        optional(:label).filled :string
        optional(:description).maybe :string
        optional(:mode).filled :string
        optional(:kind).filled :string
        optional(:tags).maybe :array
        optional(:static_body).maybe :hash
        optional(:template).maybe :string
        optional(:fields).maybe :array
        optional(:data).maybe :hash
        optional(:interval).filled :integer
        optional(:unit).filled :string
        optional(:days).maybe :array
        optional(:last_day_of_month).filled :bool
        optional(:start_at).filled :date_time

        after(:value_coercer, &Coercers::LinesToArray.curry[:tags])
        after(:value_coercer, &Coercers::DefaultToFalse.curry[:last_day_of_month])
        after(:value_coercer, &Coercers::DefaultToArray.curry[:days])
        after(:value_coercer, &Coercers::JSONToHash.curry[:static_body])
        after(:value_coercer, &Coercers::JSONToHash.curry[:fields])
        after(:value_coercer, &Coercers::JSONToHash.curry[:data])
      end
    end
  end
end
