# frozen_string_literal: true

require "pipeable"
require "refinements/hash"

module Terminus
  module Aspects
    module Firmware
      # Parses firmware HTTP headers.
      class Header
        include Deps[:logger]
        include Pipeable

        using Refinements::Hash

        def initialize(
          contract: Terminus::Contracts::Firmware::Header,
          model: Terminus::Models::Firmware::Header,
          **
        )
          @contract = contract
          @model = model
          super(**)
        end

        def call headers
          logger.debug(tags: tags(headers)) { "Processing device request headers." }
          pipe headers, validate(contract, as: :to_h), to(model, :for)
        end

        private

        attr_reader :contract, :model

        def tags(headers) = [headers.slice(*contract.key_map.map(&:name)).symbolize_keys]
      end
    end
  end
end
