# frozen_string_literal: true

require "securerandom"

module Terminus
  module Aspects
    module Superfluid
      module Filters
        RandomNumber = lambda do |_value, minimum = nil, maximum = nil, randomizer: SecureRandom|
          unless minimum
            minimum = 0
            maximum = 100
          end

          lower = minimum.to_i

          unless maximum
            minimum = 0
            maximum = lower
          end

          lower, upper = [minimum.to_i, maximum.to_i].minmax

          lower + randomizer.random_number(upper - lower + 1)
        end
      end
    end
  end
end
