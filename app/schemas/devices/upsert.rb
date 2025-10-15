# auto_register: false
# frozen_string_literal: true

module Terminus
  module Schemas
    module Devices
      # Defines device upsert schema.
      Upsert = Dry::Schema.Params do
        required(:model_id).filled :integer
        required(:playlist_id).maybe :integer
        optional(:label).filled :string
        optional(:friendly_id).filled :string
        required(:mac_address).filled Types::MACAddress
        optional(:api_key).filled :string
        optional(:refresh_rate).filled { int? > gteq?(10) }
        optional(:image_timeout).filled { int? > gteq?(0) }
        optional(:proxy).filled :bool
        optional(:firmware_update).filled :bool
        optional(:firmware_beta).filled :bool
        optional(:sleep_start_at).maybe :string
        optional(:sleep_stop_at).maybe :string

        after(:value_coercer, &Coercers::Boolean.curry[:proxy])
        after(:value_coercer, &Coercers::Boolean.curry[:firmware_beta])
        after(:value_coercer, &Coercers::Boolean.curry[:firmware_update])
      end
    end
  end
end
