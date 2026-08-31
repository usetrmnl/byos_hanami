# frozen_string_literal: true

module Terminus
  module Aspects
    module Superfluid
      module Filters
        MapToI = -> collection { collection.map(&:to_i) }
      end
    end
  end
end
