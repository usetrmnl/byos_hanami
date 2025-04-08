# auto_register: false
# frozen_string_literal: true

module Terminus
  module Contracts
    module API
      # Defines device create and update contract.
      Device = Dry::Schema.Params do
        required(:label).filled :string
        required(:friendly_id).filled :string
        required(:mac_address).filled :string
        required(:api_key).filled :string
        required(:refresh_rate).filled :integer
        required(:image_timeout).filled :integer
        optional(:proxy).filled :bool
        optional(:firmware_update).filled :bool

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
end
