# frozen_string_literal: true

module Terminus
  module HTTP
    module Headers
      Contract = Dry::Schema.Params do
        required(:HTTP_ACCESS_TOKEN).filled :string
        required(:HTTP_BATTERY_VOLTAGE).filled :float
        required(:HTTP_FW_VERSION).filled Types::Version
        required(:HTTP_HOST).filled :string
        required(:HTTP_ID).filled :string
        required(:HTTP_REFRESH_RATE).filled :integer
        required(:HTTP_RSSI).filled :integer
        required(:HTTP_USER_AGENT).filled :string
        required(:HTTP_WIDTH).filled :integer
        required(:HTTP_HEIGHT).filled :integer
      end
    end
  end
end
