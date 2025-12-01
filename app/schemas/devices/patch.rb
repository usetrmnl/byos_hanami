# auto_register: false
# frozen_string_literal: true

module Terminus
  module Schemas
    module Devices
      # Defines device patch schema.
      Patch = Dry::Schema.Params do
        optional(:model_id).filled :integer
        optional(:playlist_id).filled :integer
        optional(:friendly_id).filled :string
        optional(:label).filled :string
        optional(:mac_address).filled Types::MACAddress
        optional(:api_key).filled :string
        optional(:refresh_rate).filled { int? > gteq?(10) }
        optional(:image_timeout).filled { int? > gteq?(0) }
        optional(:proxy).filled :bool
        optional(:firmware_update).filled :bool
        optional(:sleep_start_at).maybe :string
        optional(:sleep_stop_at).maybe :string
      end
    end
  end
end
