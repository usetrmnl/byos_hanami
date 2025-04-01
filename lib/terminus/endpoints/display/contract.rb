# frozen_string_literal: true

require "dry/schema"

module Terminus
  module Endpoints
    module Display
      # Defines API response contract.
      Contract = Dry::Schema.JSON do
        required(:filename).filled :string
        required(:firmware_url).filled :string
        required(:image_url).filled :string
        required(:refresh_rate).filled :integer
        required(:reset_firmware).filled :bool
        required(:special_function).filled :string
        required(:update_firmware).filled :bool
      end
    end
  end
end
