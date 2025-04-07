# frozen_string_literal: true

require "dry/schema"

module Terminus
  module Endpoints
    module Firmware
      # Defines API response contract.
      Contract = Dry::Schema.JSON do
        required(:url).filled :string
        required(:version).filled :string
      end
    end
  end
end
