# auto_register: false
# frozen_string_literal: true

module Terminus
  module Schemas
    # Defines device schema.
    Device = Dry::Schema.Params do
      required(:label).filled :string
      required(:friendly_id).filled :string
      required(:mac_address).filled Types::MACAddress
      required(:api_key).filled :string
      required(:refresh_rate).filled { int? > gteq?(10) }
      required(:image_timeout).filled { int? > gteq?(0) }
      optional(:proxy).filled :bool
      optional(:firmware_update).filled :bool
      optional(:sleep_start_at).maybe :time
      optional(:sleep_end_at).maybe :time

      after :value_coercer do |result|
        next unless result.output

        attributes = result.to_h

        attributes[:proxy] = false unless result.key? :proxy
        attributes[:firmware_update] = false unless result.key? :firmware_update

        attributes
      end
    end
  end
end
