# frozen_string_literal: true

require "pipeable"

module Terminus
  module Endpoints
    module Display
      # Gets API repsonse.
      class Requester
        include Dependencies[:client, contract: "contracts.display", response: "responses.display"]
        include Pipeable

        def call access_token:
          pipe client.get("display", access_token:),
               try(:parse, catch: JSON::ParserError),
               validate(contract, as: :to_h),
               to(response, :for)
        end
      end
    end
  end
end
