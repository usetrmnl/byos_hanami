# auto_register: false
# frozen_string_literal: true

require "json"

module Terminus
  module Aspects
    module Liquid
      # A collection of custom Liquid filters.
      module Filters
        def json(data) = JSON.generate data
      end
    end
  end
end
