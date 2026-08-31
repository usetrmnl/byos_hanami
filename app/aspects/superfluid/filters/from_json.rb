# frozen_string_literal: true

require "json"

module Terminus
  module Aspects
    module Superfluid
      module Filters
        FromJSON = -> value { JSON value }
      end
    end
  end
end
