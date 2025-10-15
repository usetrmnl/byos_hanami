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
        required(:tags).maybe :array
        required(:headers).maybe :hash
        required(:verb).filled :string
        required(:uris).maybe :array
        required(:body).maybe :hash
        required(:template).maybe :string
        required(:data).maybe :hash
        required(:interval).maybe { int? > gteq?(0) }
        optional(:unit).filled :string
        optional(:days).maybe :array
        required(:last_day_of_month).filled :bool
        required(:start_at).filled :date_time

        after(:value_coercer, &Coercers::Array.curry[:tags])
        after(:value_coercer, &Coercers::Array.curry[:uris])
        after(:value_coercer, &Coercers::Boolean.curry[:last_day_of_month])
        after(:value_coercer, &Coercers::Empty.curry[:days])
        after(:value_coercer, &Coercers::Hash.curry[:headers])
        after(:value_coercer, &Coercers::Hash.curry[:body])
        after(:value_coercer, &Coercers::Hash.curry[:data])
      end
    end
  end
end
