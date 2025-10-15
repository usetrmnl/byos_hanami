# auto_register: false
# frozen_string_literal: true

module Terminus
  module Schemas
    module Extensions
      # Defines device upsert schema.
      Upsert = Dry::Schema.Params do
        required(:name).filled :string
        required(:label).filled :string
        required(:description).maybe :string
        required(:kind).filled :string
        required(:mode).filled :string
        required(:tags).maybe :array
        required(:headers).maybe :hash
        required(:verb).filled :string
        required(:uris).maybe :array
        required(:poll_body).maybe :hash
        required(:static_body).maybe :hash
        required(:fields).maybe :hash
        required(:padding).filled :bool
        required(:template_full).maybe :string
        required(:template_horizontal).maybe :string
        required(:template_vertical).maybe :string
        required(:template_quarter).maybe :string
        required(:template_shared).maybe :string
        required(:repeat_interval).maybe { int? > gteq?(0) }
        optional(:repeat_type).filled :string
        required(:repeat_days).maybe :array
        required(:last_day_of_month).filled :bool

        after(:value_coercer, &Coercers::Array.curry[:tags])
        after(:value_coercer, &Coercers::Array.curry[:uris])
        after(:value_coercer, &Coercers::Array.curry[:repeat_days])
        after(:value_coercer, &Coercers::Boolean.curry[:padding])
        after(:value_coercer, &Coercers::Boolean.curry[:last_day_of_month])
        after(:value_coercer, &Coercers::Hash.curry[:headers])
        after(:value_coercer, &Coercers::Hash.curry[:poll_body])
        after(:value_coercer, &Coercers::Hash.curry[:static_body])
        after(:value_coercer, &Coercers::Hash.curry[:fields])
      end
    end
  end
end
