# frozen_string_literal: true

require "dry/schema"

module Terminus
  module Endpoints
    module CurrentScreen
      # Defines API response contract.
      Contract = Dry::Schema.JSON do
        required(:refresh_rate).filled :integer
        required(:image_url).filled :string
        required(:filename).filled :string
      end
    end
  end
end
