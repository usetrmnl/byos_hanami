# frozen_string_literal: true

module Terminus
  module Aspects
    module Superfluid
      module Filters
        GroupBy = -> collection, key { collection.group_by { it[key] } }
      end
    end
  end
end
