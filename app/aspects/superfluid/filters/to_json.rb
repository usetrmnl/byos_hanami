# frozen_string_literal: true

require "json"

module Terminus
  module Aspects
    module Superfluid
      module Filters
        ToJSON = -> value { JSON.generate value }
      end
    end
  end
end
