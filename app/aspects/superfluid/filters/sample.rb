# frozen_string_literal: true

module Terminus
  module Aspects
    module Superfluid
      module Filters
        Sample = -> collection { collection.sample }
      end
    end
  end
end
