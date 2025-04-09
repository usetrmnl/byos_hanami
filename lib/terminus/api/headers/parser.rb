# frozen_string_literal: true

require "initable"
require "pipeable"

module Terminus
  module API
    module Headers
      # Parses firmware specific HTTP headers.
      class Parser
        include Initable[contract: proc { Terminus::API::Headers::Contract }, model: Model]
        include Pipeable

        def call(headers) = pipe headers, validate(contract, as: :to_h), to(model, :for)
      end
    end
  end
end
