# frozen_string_literal: true

require "pipeable"

module Terminus
  module Endpoints
    module Firmware
      # Acquires API repsonse.
      class Requester
        include Dependencies[
          :client,
          contract: "contracts.firmware",
          response: "responses.firmware"
        ]

        include Pipeable

        def call
          pipe client.get("firmware/latest"),
               try(:parse, catch: JSON::ParserError),
               validate(contract, as: :to_h),
               to(response, :for)
        end
      end
    end
  end
end
