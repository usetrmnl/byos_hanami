# frozen_string_literal: true

require "pipeable"

module Terminus
  module Endpoints
    module CurrentScreen
      # Acquires API repsonse.
      class Requester
        include Dependencies[
          :client,
          contract: "contracts.current_screen",
          response: "responses.current_screen"
        ]

        include Pipeable

        def call api_key:
          pipe client.get("current_screen", api_key:),
               try(:parse, catch: JSON::ParserError),
               validate(contract, as: :to_h),
               to(response, :for)
        end
      end
    end
  end
end
