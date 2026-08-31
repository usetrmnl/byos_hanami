# frozen_string_literal: true

require "core"
require "securerandom"

module Terminus
  module Aspects
    module Superfluid
      module Filters
        AppendRandom = lambda do |value, delimiter = Core::EMPTY_STRING, randomizer: SecureRandom|
          "#{value}#{delimiter}#{randomizer.hex 2}"
        end
      end
    end
  end
end
