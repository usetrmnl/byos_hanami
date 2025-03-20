# frozen_string_literal: true

module Terminus
  module HTTP
    module Headers
      Contract = Dry::Schema.Params do
        required(:HTTP_ACCESS_TOKEN).filled :string
        optional(:HTTP_BATTERY_VOLTAGE).filled :float
        optional(:HTTP_FW_VERSION).filled Types::Version
        optional(:HTTP_HOST).filled :string
        required(:HTTP_ID).filled :string
        optional(:HTTP_REFRESH_RATE).filled :integer
        optional(:HTTP_RSSI).filled :integer
        optional(:HTTP_USER_AGENT).filled :string
        optional(:HTTP_WIDTH).filled :integer
        optional(:HTTP_HEIGHT).filled :integer
      end
    end
  end
end
