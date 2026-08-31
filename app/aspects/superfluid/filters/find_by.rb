# frozen_string_literal: true

module Terminus
  module Aspects
    module Superfluid
      module Filters
        FindBy = -> collection, key, value { collection.find { it[key] == value } }
      end
    end
  end
end
